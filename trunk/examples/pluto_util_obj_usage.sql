set serveroutput on;
set feedback off;
set echo off;

declare
  util1  pluto_util_obj := pluto_util_obj( );
  util2  pluto_util_obj
                := pluto_util_obj( output_object => pluto_output_tap_obj( ));
begin
  util1.set_test_count( 2 );
  util1.ok( test_passed => true, test_label => 'the first test' );
  util1.ok( test_passed => false, test_label => 'yet another test' );
  util1.finish;

  util2.set_test_count( 1 );
  util2.ok( test_passed => true, test_label => 'first test for numer two' );
  util2.finish;
end;
/
