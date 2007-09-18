set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

@sql/pre_installation_cleanup.sql;

@sql/core/pluto_proc_name_tab.sql;

@sql/utilities/pluto_output_obj.pks;

@sql/utilities/pluto_output_obj.pkb;

@sql/utilities/pluto_output_tap_obj.pks;

@sql/utilities/pluto_output_tap_obj.pkb;

@sql/utilities/pluto_util_obj.pks;

@sql/utilities/pluto_util_obj.pkb;

@sql/core/pluto_obj.pks;

@sql/core/pluto_obj.pkb;

exit;

