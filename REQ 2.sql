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

