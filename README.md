# Project Report: Automated Feed Generation, Duplicate Handling, and Comparison in PostgreSQL
## The goal of this project was to design and implement an automated data processing system in PostgreSQL that can
1. Generate test feeds (tables) dynamically with configurable rows and columns.
2. Identify and store duplicate records from feeds.
3. Remove duplicates and keep unique records.
4. Verify that duplicates are removed successfully.
5. Compare data between different feeds and store mismatches or missing records.
6. Run automated tests to validate the above steps.

## Dataset Details
Data is not manually entered.
Instead, dummy test data is generated automatically using MD5(RANDOM()) to create random strings.
Each feed (e.g., Feed1, Feed2) is created with variable numbers of rows and columns depending on test requirements.
Example: Feed1 had 10 columns × 10 rows, while Feed2 had 15 columns × 15 rows.

## Step 1 – Generate Feeds
A stored procedure generate_feed was created.
It dynamically builds a table (Feed1, Feed2, etc.) with the required number of columns and rows.
Example: CALL generate_feed('Feed1', 10, 10); creates a table with 10 columns and 10 random rows.
An extra duplicate row is added deliberately to test duplicate handling.

## Step 2 – Identify and Store Duplicates
A table duplicates was created to store information about duplicate rows.
A procedure find_and_store_duplicates finds duplicates in a given feed.
Duplicate records are stored in JSON format along with their frequency.
Example output: Feed1 had 1 duplicate row group.

## Step 3 – Remove Duplicates
A procedure replace_duplicates_with_unique was written.
It removes duplicate records by keeping only distinct rows.
After cleanup, Feed1 was reduced from 11 rows → 10 rows (unique only).

## Step 4 – Verify No Duplicates
A procedure verify_no_duplicates was created.
It re-checks the feed after cleanup.
Feed1 was verified successfully with 0 duplicate groups remaining.

## Step 5 – Compare Feeds
A table comparison_results was created.
A procedure compare_feeds compares two feeds record by record.
Differences are logged as JSON with status:
In source only → present in Feed2 but missing in Feed1.
In target only → present in Feed1 but missing in Feed2.
Example: Comparing Feed2 with Feed1 generated several mismatches because Feed2 had 15 columns and more rows.

## Step 6 – Automated Testing
A procedure run_automated_tests was created to test the whole flow.
It automatically performs:
Feed generation (Feed1, Feed2).
Duplicate detection.
Duplicate removal.
Duplicate verification.
Feed comparison.
Test cases (TC-01 to TC-07) confirm whether each step Passed or Failed.
Example:
TC-01: Feed1 generated → Passed
TC-04: Duplicate found in Feed1 → Passed
TC-05: Duplicates removed → Passed
TC-07: Feed2 compared with Feed1 → Passed
