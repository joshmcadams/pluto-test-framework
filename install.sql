set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

@sql/pre_installation_cleanup.sql;

@sql/core/pluto_proc_name_tab.sql;

@sql/core/pluto_obj.sql;

@sql/core/pluto_obj_body.sql;

@sql/utilities/pluto_tap_util.sql;

@sql/utilities/pluto_tap_util_body.sql;

exit;

