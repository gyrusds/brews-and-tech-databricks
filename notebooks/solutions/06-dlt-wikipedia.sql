-- Databricks notebook source
--- An example Delta Live Tables pipeline that ingests wikipedia click stream data and builds some simple summary tables.
-- DECLARE VARIABLE table_name STRING;
-- SET VAR table_name = concat(split_part(current_user, '.', 1), '_', 'clickstream_raw');
-- SELECT table_name;

-- CREATE LIVE TABLE concat(split_part(current_user, '.', 1), '_', 'clickstream_raw')
CREATE LIVE TABLE alvaro_clickstream_raw
COMMENT "The raw wikipedia click stream dataset, ingested from /databricks-datasets."
TBLPROPERTIES ("quality" = "bronze")
AS SELECT * FROM json.`/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/2015_2_clickstream.json`

-- COMMAND ----------

CREATE LIVE TABLE alvaro_clickstream_clean(
  CONSTRAINT valid_current_page EXPECT (current_page_id IS NOT NULL and current_page_title IS NOT NULL),
  CONSTRAINT valid_count EXPECT (click_count > 0) ON VIOLATION FAIL UPDATE
)
COMMENT "Wikipedia clickstream dataset with cleaned-up datatypes / column names and quality expectations."
TBLPROPERTIES ("quality" = "silver")
AS SELECT
  CAST (curr_id AS INT) AS current_page_id,
  curr_title AS current_page_title,
  CAST(n AS INT) AS click_count,
  CAST (prev_id AS INT) AS previous_page_id,
  prev_title AS previous_page_title
FROM live.alvaro_clickstream_raw

-- COMMAND ----------

CREATE LIVE TABLE alvaro_top_spark_referers
COMMENT "A table of the most common pages that link to the Apache Spark page."
TBLPROPERTIES ("quality" = "gold")
AS SELECT
  previous_page_title as referrer,
  click_count
FROM live.alvaro_clickstream_clean
WHERE current_page_title = 'Apache_Spark'
ORDER BY click_count DESC
LIMIT 10

-- COMMAND ----------

CREATE LIVE TABLE alvaro_top_pages
COMMENT "A list of the top 50 pages by number of clicks."
TBLPROPERTIES ("quality" = "gold")
AS SELECT
  current_page_title,
  SUM(click_count) as total_clicks
FROM live.alvaro_clickstream_clean
GROUP BY current_page_title
ORDER BY 2 DESC
LIMIT 50
