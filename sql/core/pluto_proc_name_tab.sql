set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace type pluto_proc_name_tab is table of varchar2( 30 );
/
