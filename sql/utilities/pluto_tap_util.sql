set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace package pluto_tap_util as
  type proc_name_tab is table of varchar2( 30 );

  procedure plan( test_count number );

  procedure diag( message varchar );

  procedure ok( ok_or_not boolean, test_label varchar );

  function ok( ok_or_not boolean, test_label varchar )
    return boolean;
end pluto_tap_util;
/
