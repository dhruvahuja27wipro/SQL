-- Function: generate_feed
CREATE OR REPLACE FUNCTION generate_feed(table_name text, num_cols int, num_rows int)
RETURNS void AS $$
DECLARE
    i int;
    create_sql text;
    insert_sql text;
BEGIN
    -- Drop table if exists
    EXECUTE format('DROP TABLE IF EXISTS %I', table_name);

    -- Build CREATE TABLE dynamically
    create_sql := 'CREATE TABLE ' || quote_ident(table_name) || ' (';
    FOR i IN 1..num_cols LOOP
        create_sql := create_sql || format('col_%s text', i);
        IF i < num_cols THEN
            create_sql := create_sql || ', ';
        END IF;
    END LOOP;
    create_sql := create_sql || ')';

    EXECUTE create_sql;

    -- Insert rows
    FOR i IN 1..num_rows LOOP
        EXECUTE format(
            'INSERT INTO %I SELECT %s',
            table_name,
            string_agg('substr(md5(random()::text), 1, 8)', ', ')
        )
        FROM generate_series(1, num_cols);
    END LOOP;

    -- Add one duplicate row
    IF num_rows > 0 THEN
        EXECUTE format('INSERT INTO %I SELECT * FROM %I LIMIT 1', table_name, table_name);
    END IF;

END;
$$ LANGUAGE plpgsql;


-- Table to store duplicates
CREATE TABLE IF NOT EXISTS duplicates (
    table_name_source text,
    duplicate_data jsonb,
    count_of_duplicates int
);

-- Function: find_and_store_duplicates
CREATE OR REPLACE FUNCTION find_and_store_duplicates(source_table_name text)
RETURNS void AS $$
DECLARE
    cols text;
BEGIN
    SELECT string_agg(quote_ident(column_name), ', ')
    INTO cols
    FROM information_schema.columns
    WHERE table_name = source_table_name
      AND table_schema = 'public';

    EXECUTE format(
        'INSERT INTO duplicates (table_name_source, duplicate_data, count_of_duplicates)
         SELECT %L, jsonb_build_object(%s), COUNT(*)
         FROM %I
         GROUP BY %s
         HAVING COUNT(*) > 1',
        source_table_name,
        (
          SELECT string_agg(format('%L, %I', column_name, column_name), ', ')
          FROM information_schema.columns
          WHERE table_name = source_table_name
            AND table_schema = 'public'
        ),
        source_table_name,
        cols
    );
END;
$$ LANGUAGE plpgsql;


-- Function: replace_duplicates_with_unique
CREATE OR REPLACE FUNCTION replace_duplicates_with_unique(target_table_name text)
RETURNS void AS $$
BEGIN
    EXECUTE format('CREATE TEMP TABLE temp_distinct AS SELECT DISTINCT * FROM %I', target_table_name);
    EXECUTE format('TRUNCATE TABLE %I', target_table_name);
    EXECUTE format('INSERT INTO %I SELECT * FROM temp_distinct', target_table_name);
    DROP TABLE temp_distinct;
END;
$$ LANGUAGE plpgsql;


-- Function: verify_no_duplicates
CREATE OR REPLACE FUNCTION verify_no_duplicates(table_to_check text)
RETURNS text AS $$
DECLARE
    cols text;
    duplicate_count int;
BEGIN
    SELECT string_agg(quote_ident(column_name), ', ')
    INTO cols
    FROM information_schema.columns
    WHERE table_name = table_to_check
      AND table_schema = 'public';

    EXECUTE format(
        'SELECT count(*) FROM (
            SELECT %s, COUNT(*) as cnt
            FROM %I
            GROUP BY %s
            HAVING COUNT(*) > 1
        ) sub',
        cols, table_to_check, cols
    )
    INTO duplicate_count;

    IF duplicate_count = 0 THEN
        RETURN format('Verification successful for %s: No duplicate rows found.', table_to_check);
    ELSE
        RETURN format('Verification failed for %s: %s duplicate sets found.', table_to_check, duplicate_count);
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Table for comparison results
CREATE TABLE IF NOT EXISTS comparison_results (
    source_feed text,
    target_feed text,
    record_data jsonb,
    comparison_status text
);

-- Function: compare_feeds
CREATE OR REPLACE FUNCTION compare_feeds(source_feed_name text, target_feed_name text)
RETURNS void AS $$
BEGIN
    -- Clear old results
    DELETE FROM comparison_results
    WHERE source_feed = source_feed_name AND target_feed = target_feed_name;

    -- Source only
    EXECUTE format(
        'INSERT INTO comparison_results (source_feed, target_feed, record_data, comparison_status)
         SELECT %L, %L, to_jsonb(s), ''In source only''
         FROM %I s
         LEFT JOIN %I t ON s.col_1 = t.col_1
         WHERE t.col_1 IS NULL',
        source_feed_name, target_feed_name, source_feed_name, target_feed_name
    );

    -- Target only
    EXECUTE format(
        'INSERT INTO comparison_results (source_feed, target_feed, record_data, comparison_status)
         SELECT %L, %L, to_jsonb(t), ''In target only''
         FROM %I t
         LEFT JOIN %I s ON t.col_1 = s.col_1
         WHERE s.col_1 IS NULL',
        source_feed_name, target_feed_name, target_feed_name, source_feed_name
    );
END;
$$ LANGUAGE plpgsql;


-- Function: run_automated_tests
CREATE OR REPLACE FUNCTION run_automated_tests()
RETURNS TABLE(test_result text) AS $$
DECLARE
    row_count int;
BEGIN
    -- TC-01: Generate Feed1
    PERFORM generate_feed('feed1', 10, 10);
    EXECUTE 'SELECT COUNT(*) FROM feed1' INTO row_count;
    IF row_count = 11 THEN
        test_result := 'TC-01: Generate Feed-1 - PASSED'; RETURN NEXT;
    ELSE
        test_result := 'TC-01: Generate Feed-1 - FAILED'; RETURN NEXT;
    END IF;

    -- TC-04: Find duplicates
    TRUNCATE duplicates;
    PERFORM find_and_store_duplicates('feed1');
    SELECT COUNT(*) INTO row_count FROM duplicates WHERE table_name_source = 'feed1';
    IF row_count > 0 THEN
        test_result := 'TC-04: Identify Duplicates in Feed-1 - PASSED'; RETURN NEXT;
    ELSE
        test_result := 'TC-04: Identify Duplicates in Feed-1 - FAILED'; RETURN NEXT;
    END IF;

    -- TC-05: Replace duplicates
    PERFORM replace_duplicates_with_unique('feed1');
    EXECUTE 'SELECT COUNT(*) FROM feed1' INTO row_count;
    IF row_count = 10 THEN
        test_result := 'TC-05: Replace Duplicates in Feed-1 - PASSED'; RETURN NEXT;
    ELSE
        test_result := 'TC-05: Replace Duplicates in Feed-1 - FAILED'; RETURN NEXT;
    END IF;

    -- TC-06: Verify no duplicates
    test_result := verify_no_duplicates('feed1'); RETURN NEXT;

    -- TC-07: Compare feeds
    PERFORM generate_feed('feed2', 15, 15);
    TRUNCATE comparison_results;
    PERFORM compare_feeds('feed2', 'feed1');
    SELECT COUNT(*) INTO row_count FROM comparison_results;
    IF row_count > 0 THEN
        test_result := 'TC-07: Compare Feed-2 to Feed-1 - PASSED (Results generated)'; RETURN NEXT;
    ELSE
        test_result := 'TC-07: Compare Feed-2 to Feed-1 - FAILED (No results)'; RETURN NEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM run_automated_tests();