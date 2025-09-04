DROP TABLE IF EXISTS Feed1;

CREATE TABLE Feed1 (
    col_1 INT,
    col_2 VARCHAR(255), col_3 VARCHAR(255), col_4 VARCHAR(255), col_5 VARCHAR(255),
    col_6 VARCHAR(255), col_7 VARCHAR(255), col_8 VARCHAR(255), col_9 VARCHAR(255), col_10 VARCHAR(255)
);
INSERT INTO Feed1 (col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10)
SELECT
  Rownums.n, 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8)
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
    SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) AS Rownums;
INSERT INTO Feed1
SELECT * FROM Feed1 LIMIT 1;

DROP TABLE IF EXISTS Feed2;

CREATE TABLE Feed2 (
    col_1 INT,
    col_2 VARCHAR(255), col_3 VARCHAR(255), col_4 VARCHAR(255), col_5 VARCHAR(255),
    col_6 VARCHAR(255), col_7 VARCHAR(255), col_8 VARCHAR(255), col_9 VARCHAR(255), col_10 VARCHAR(255),
    col_11 VARCHAR(255), col_12 VARCHAR(255), col_13 VARCHAR(255), col_14 VARCHAR(255), col_15 VARCHAR(255)
);

-- Insert 15 rows with random values
INSERT INTO Feed2 (col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15)
SELECT
  Rownums.n,
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8),
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8),
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8), 
  SUBSTRING(MD5(random()::text), 1, 8)
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
    SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL
    SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
) AS Rownums;
-- Copy 2 rows from existing Feed2 into Feed2
INSERT INTO Feed2 (col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15)
SELECT 
  (SELECT MAX(col_1) FROM Feed2) + ROW_NUMBER() OVER (),  -- generate new col_1 values to avoid duplicate key error
  col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15
FROM Feed2
LIMIT 2;

DROP TABLE IF EXISTS Feed3;

CREATE TABLE Feed3 (
    col_1 INT,
    col_2 VARCHAR(255), col_3 VARCHAR(255), col_4 VARCHAR(255), col_5 VARCHAR(255),
    col_6 VARCHAR(255), col_7 VARCHAR(255), col_8 VARCHAR(255), col_9 VARCHAR(255), col_10 VARCHAR(255),
    col_11 VARCHAR(255), col_12 VARCHAR(255), col_13 VARCHAR(255), col_14 VARCHAR(255), col_15 VARCHAR(255),
    col_16 VARCHAR(255), col_17 VARCHAR(255), col_18 VARCHAR(255), col_19 VARCHAR(255), col_20 VARCHAR(255)
);
-- Insert 20 rows with random values
INSERT INTO Feed3 (col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, 
                   col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20)
SELECT
  Rownums.n,
  SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8),
  SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8),
  SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8),
  SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8), SUBSTRING(MD5(random()::text), 1, 8)
FROM (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
    SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL
    SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL
    SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
) AS Rownums;


INSERT INTO Feed3
SELECT 
  (SELECT MAX(col_1) FROM Feed3) + ROW_NUMBER() OVER () AS col_1,
  f.col_2, f.col_3, f.col_4, f.col_5, f.col_6, f.col_7, f.col_8, f.col_9, f.col_10,
  f.col_11, f.col_12, f.col_13, f.col_14, f.col_15, f.col_16, f.col_17, f.col_18, f.col_19, f.col_20
FROM Feed3 f
LIMIT 3;

INSERT INTO Feed3
SELECT * FROM Feed3 LIMIT 3;


CREATE OR REPLACE FUNCTION generate_feed(
    table_name TEXT,
    num_cols INT,
    num_rows INT
)
RETURNS void AS $$
DECLARE
    create_table_sql TEXT;
    insert_sql TEXT;
    col_list TEXT;
    i INT;
BEGIN
    -- Drop table if exists
    EXECUTE format('DROP TABLE IF EXISTS %I', table_name);

    -- Build CREATE TABLE statement
    create_table_sql := 'CREATE TABLE ' || quote_ident(table_name) || ' (';
    FOR i IN 1..num_cols LOOP
        create_table_sql := create_table_sql || format('col_%s TEXT', i);
        IF i < num_cols THEN
            create_table_sql := create_table_sql || ', ';
        END IF;
    END LOOP;
    create_table_sql := create_table_sql || ')';

    EXECUTE create_table_sql;

    -- Build column list string
    col_list := '';
    FOR i IN 1..num_cols LOOP
        col_list := col_list || format('col_%s', i);
        IF i < num_cols THEN
            col_list := col_list || ', ';
        END IF;
    END LOOP;

    -- Insert rows with random values
    FOR i IN 1..num_rows LOOP
        insert_sql := 'INSERT INTO ' || quote_ident(table_name) || ' (' || col_list || ') VALUES (';
        insert_sql := insert_sql || (
            SELECT string_agg(quote_literal(substr(md5(random()::text), 1, 8)), ', ')
            FROM generate_series(1, num_cols)
        );
        insert_sql := insert_sql || ')';
        EXECUTE insert_sql;
    END LOOP;

    RAISE NOTICE 'Table % created with % columns and % rows', table_name, num_cols, num_rows;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE IF NOT EXISTS duplicates (
    table_name_source VARCHAR(255),
    count_of_duplicates INT,
    col_1 VARCHAR(255), col_2 VARCHAR(255), col_3 VARCHAR(255), col_4 VARCHAR(255), col_5 VARCHAR(255),
    col_6 VARCHAR(255), col_7 VARCHAR(255), col_8 VARCHAR(255), col_9 VARCHAR(255), col_10 VARCHAR(255),
    col_11 VARCHAR(255), col_12 VARCHAR(255), col_13 VARCHAR(255), col_14 VARCHAR(255), col_15 VARCHAR(255),
    col_16 VARCHAR(255), col_17 VARCHAR(255), col_18 VARCHAR(255), col_19 VARCHAR(255), col_20 VARCHAR(255)
);

TRUNCATE TABLE duplicates;

INSERT INTO duplicates (
    table_name_source, count_of_duplicates,
    col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10
)
SELECT
    'Feed1' AS table_name_source, COUNT(*) AS count_of_duplicates,
    col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10
FROM Feed1
GROUP BY col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10
HAVING COUNT(*) > 1;

INSERT INTO duplicates (
    table_name_source, count_of_duplicates,
    col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10,
    col_11, col_12, col_13, col_14, col_15
)
SELECT
    'Feed2' AS table_name_source, COUNT(*) AS count_of_duplicates,
    col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10,
    col_11, col_12, col_13, col_14, col_15
FROM Feed2
GROUP BY col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10,
    col_11, col_12, col_13, col_14, col_15
HAVING COUNT(*) > 1;

INSERT INTO duplicates (
    table_name_source, count_of_duplicates,
    col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10,
    col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20
)
SELECT
    'Feed3' AS table_name_source, COUNT(*) AS count_of_duplicates,
    col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10,
    col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20
FROM Feed3
GROUP BY col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10,
    col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20
HAVING COUNT(*) > 1;


-- Create the table to store comparison results
CREATE TABLE IF NOT EXISTS comparison_results (
    source_feed VARCHAR(255),
    target_feed VARCHAR(255),
    record_data_col1 VARCHAR(255),
    comparison_status VARCHAR(255)
);

-- Clear old results
TRUNCATE TABLE comparison_results;

-- Compare Feed2 to Feed1
INSERT INTO comparison_results (source_feed, target_feed, record_data_col1, comparison_status)
SELECT 'Feed2', 'Feed1', s.col_1, 'In source only'
FROM Feed2 s LEFT JOIN Feed1 t ON s.col_1 = t.col_1
WHERE t.col_1 IS NULL;

INSERT INTO comparison_results (source_feed, target_feed, record_data_col1, comparison_status)
SELECT 'Feed2', 'Feed1', t.col_1, 'In target only'
FROM Feed1 t LEFT JOIN Feed2 s ON t.col_1 = s.col_1
WHERE s.col_1 IS NULL;

-- Compare Feed3 to Feed1
INSERT INTO comparison_results (source_feed, target_feed, record_data_col1, comparison_status)
SELECT 'Feed3', 'Feed1', s.col_1, 'In source only'
FROM Feed3 s LEFT JOIN Feed1 t ON s.col_1 = t.col_1
WHERE t.col_1 IS NULL;

INSERT INTO comparison_results (source_feed, target_feed, record_data_col1, comparison_status)
SELECT 'Feed3', 'Feed1', t.col_1, 'In target only'
FROM Feed1 t LEFT JOIN Feed3 s ON t.col_1 = s.col_1
WHERE s.col_1 IS NULL;