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

