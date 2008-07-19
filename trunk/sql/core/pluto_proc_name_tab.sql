set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace type pluto_proc_name_tab is table of varchar2( 30 );
/

show errors;

select case when status = 'INVALID' then 1/0 else 1 end
    did_the_object_compile
from user_objects
where object_name = 'PLUTO_PROC_NAME_TAB'
  and object_type = 'TYPE';

