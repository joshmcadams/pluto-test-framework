set serveroutput on;
set feedback off;
set echo off;

begin
	 pluto_util.initialize(pluto_output_tap_obj());
	 pluto_util.set_test_count(2);
	 pluto_util.ok(test_passed => true, test_label => 'the first test');
	 pluto_util.ok(test_passed => false, test_label => 'yet another test');
	 pluto_util.finish;
end;
/

