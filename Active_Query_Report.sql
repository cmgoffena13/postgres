/*====================================================================================================
Active Queries - Cortland Goffena

Shows information about current running queries in all databases.
====================================================================================================*/

SELECT
datname AS "DatabaseName",
pid AS "PID",
usename AS "Username",
application_name AS "ApplicationName",
--client_addr AS "ClientIPAddress",
--client_hostname AS "ClientHostName",
client_port AS "ClientPort",
state AS "ProcessState",
backend_start AS "ProcessStart",
xact_start AS "TransactionStart",
query_start AS "QueryStart",
--query_id AS "QueryID",
query AS "QueryText",
wait_event_type AS "WaitEventType",
wait_event AS "WaitEvent"
FROM pg_stat_activity
WHERE pid != pg_backend_pid()
AND wait_event_type != 'Activity'
AND state = 'active'