/*====================================================================================================
Query Stats - Cortland Goffena

Shows detailed performance information about queries.
Special Note to check TempNameSpaceWritesMB, this indicates spills
====================================================================================================*/

SELECT
au.rolname AS "Username",
d.datname AS "DBName",
s.calls AS "QueryExecutions", 
s.query AS "QueryStatement",
s.plans AS "QueryPlan",
CAST(s.mean_exec_time AS NUMERIC(17,2)) AS "MeanExecutionTime",
CAST(s.total_exec_time AS NUMERIC(17,2)) AS "TotalExecutionTime", /*in microseconds*/
s.rows AS "TotalAggRows",

CAST(s.shared_blks_hit * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "SharedBufferMemoryReadsMB", /* Hit memory (shared buffer) instead of disk, represents number of blocks/pages 8KB each */
CAST(s.shared_blks_read * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "SharedBufferDiskReadsMB", /* Had to read from disk because wasn't found in memory */
CAST(s.shared_blks_dirtied * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "SharedBufferChangedMB", /* How many blocks/pages were dirtied/changed */
CAST(s.shared_blks_written * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "SharedBufferDiskWritesMB", /* Out of dirtied blocks/pages how many were written to disk.  */

CAST(s.local_blks_hit * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "LocalBufferMemoryReadsMB", /* local buffer, specific for query sessions */
CAST(s.local_blks_read * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "LocalBufferDiskReadsMB",
CAST(s.local_blks_dirtied * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "LocalBufferChangedMB",
CAST(s.local_blks_written * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "LocalBufferDiskWritesMB",

CAST(s.temp_blks_read * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "TempNamespaceReadsMB", /* Disk reads, often from overflow of memory in execution plans */
CAST(s.temp_blks_written * 1.0 / (1024 * 1024) AS NUMERIC(17,2)) AS "TempNamespaceWritesMB", /* Data written to disk due to memory overflow, complex queries, etc. */
to_char((s.temp_blk_read_time || ' milliseconds')::interval, 'HH24:MI:SS') AS "TempNamespaceReadsTime", /*time in milliseconds reading from the temp namespace*/
to_char((s.temp_blk_write_time || ' milliseconds')::interval, 'HH24:MI:SS') AS "TempNamespaceWritesTime",
to_char((s.blk_read_time || ' milliseconds')::interval, 'HH24:MI:SS') AS "PermanentDiskReadsTime", /* time in milliseconds reading from permanent storage, tables */
to_char((s.blk_write_time || ' milliseconds')::interval, 'HH24:MI:SS') AS "MemoryAndDiskWritesTime" /* time in milliseconds for all writes, including buffer and disk */

FROM pg_stat_statements AS s
INNER JOIN pg_authid AS au
	ON au.oid = s.userid
INNER JOIN pg_database AS d
	ON d.oid = s.dbid
WHERE s.userid != 10 /*postgres*/
ORDER BY s.calls DESC;