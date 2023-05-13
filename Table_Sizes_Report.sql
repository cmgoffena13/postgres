/*====================================================================================================
Table Stats - Cortland Goffena

Shows space size and record size.
Gives index percent of the total space.
====================================================================================================*/

SELECT
t.schemaname || '.' || t.relname AS "TableName",
t.n_live_tup AS "RecordCount",
pg_size_pretty(pg_total_relation_size(t.schemaname || '.' || t.relname)) AS "TableTotalSize",
pg_size_pretty(pg_relation_size(t.schemaname || '.' || t.relname)) AS "TableDataSize",
CASE WHEN pg_total_relation_size(t.schemaname || '.' || t.relname) > 0 
	 AND pg_relation_size(t.schemaname || '.' || t.relname) > 0
	THEN CAST(
			CAST(pg_relation_size(t.schemaname || '.' || t.relname) AS NUMERIC(19,4)) / 
				CAST(pg_total_relation_size(t.schemaname || '.' || t.relname) AS NUMERIC(19,4)) 
		AS NUMERIC(19,4))
	ELSE 0 END AS "DataSizePercent",
pg_size_pretty(pg_indexes_size(t.schemaname || '.' || t.relname)) AS "TableIndexSize",
CASE WHEN pg_total_relation_size(t.schemaname || '.' || t.relname) > 0 
	 AND pg_indexes_size(t.schemaname || '.' || t.relname) > 0
	THEN CAST(
			CAST(pg_indexes_size(t.schemaname || '.' || t.relname) AS NUMERIC(19,4)) / 
				CAST(pg_total_relation_size(t.schemaname || '.' || t.relname) AS NUMERIC(19,4)) 
		AS NUMERIC(19,4))
	ELSE 0 END AS "IndexSizePercent"
FROM pg_stat_user_tables AS t
ORDER BY t.n_live_tup DESC;