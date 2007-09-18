DECLARE
  l_result  BINARY_INTEGER;
BEGIN
  l_result := DBMS_PROFILER.start_profiler(run_comment => 'audit_external_table: ' || SYSDATE);
  audit_etl_pkg.audit_external_table(24);
  l_result := DBMS_PROFILER.stop_profiler; END; /

SELECT runid,
       run_date,
       run_comment,
       run_total_time
FROM   plsql_profiler_runs
ORDER BY runid;

SELECT u.runid,
       u.unit_number,
       u.unit_type,
       u.unit_owner,
       u.unit_name,
       d.line#,
       d.total_occur,
       d.total_time,
       d.min_time,
       d.max_time
FROM   plsql_profiler_units u
       JOIN plsql_profiler_data d ON u.runid = d.runid AND u.unit_number = d.unit_number
WHERE  u.runid = 1
ORDER BY u.unit_number, d.line#;