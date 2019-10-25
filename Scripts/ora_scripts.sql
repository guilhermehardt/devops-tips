-- SELECT USER SESSION
select sesion.sid,
       sesion.username,
       optimizer_mode,
       hash_value,
       address,
       cpu_time,
       elapsed_time,
       sql_text
  from v$sqlarea sqlarea, v$session sesion
where sesion.username like '%_USER_NAME_HERE_%'

-- SELECT SESSION IN EXECUTION
SELECT * FROM v$session WHERE username IN UPPER('_USER_NAME_HERE_');

-- SELECT ERROR MSG
select name, error_msg, start_time, suspend_time, sql_text from dba_resumable;

-- JOBS DETAILS
select * from ALL_SCHEDULER_JOB_RUN_DETAILS where job_name like '%_USER_NAME_HERE_%'
SELECT job_name, log_date, status, actual_start_date, run_duration, cpu_used FROM dba_scheduler_job_run_details where job_name like '%_USER_NAME_HERE_%';
select * from dba_datapump_jobs;

SELECT b.username, a.sid, b.opname, b.target,
            round(b.SOFAR*100/b.TOTALWORK,0) || '%' as "%DONE", b.TIME_REMAINING,
            to_char(b.start_time,'YYYY/MM/DD HH24:MI:SS') start_time
     FROM v$session_longops b, v$session a
     WHERE a.sid = b.sid      ORDER BY 6;


SELECT sl.sid, sl.serial#, sl.sofar, sl.totalwork, dp.owner_name, dp.state, dp.job_mode
FROM v$session_longops sl, v$datapump_job dp
WHERE sl.opname = dp.job_name
AND sl.sofar != sl.totalwork;


-- DUMP RESTORE/IMPORT
impdp system/_PASSWORD_@_DATABASE_INSTANCE_ \
  dumpfile=expdir:"dump.dmp" \
  job_name=imp_dump \
  schemas="_DUMP_SCHEMA_" \
  remap_schema="_DUMP_SCHEMA_":"_NEW_SCHEMA_" \
  remap_tablespace=_DUMP_TBS_:_NEW_TBS_DATA > /tmp/import.log


-- KILL SESSIONS TO USER
BEGIN
    FOR r IN (SELECT sid,serial# FROM v$session WHERE username IN UPPER('_USER_NAME_HERE_'))
    LOOP
       EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || r.sid || ',' || r.serial# || '''';
    END LOOP;
END;
--
-- DROP USER AND TABLESPACE
DROP USER _USER_NAME_HERE_ CASCADE;
DROP TABLESPACE _TABLESPACE_NAME_HERE_ INCLUDING CONTENTS AND DATAFILES;

-- SELECT DATA_FILES
SELECT  FILE_NAME, BLOCKS, TABLESPACE_NAME  FROM DBA_DATA_FILES where FILE_NAME LIKE '%_USER_NAME_HERE_%';

