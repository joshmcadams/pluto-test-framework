set serveroutput on;

declare
  po  pluto_output_tap_obj := pluto_output_tap_obj( );
begin
  po.log_test_count( 10 );
  po.log_test_results( test_label => 'test one', test_passed => true );
  po.log_message('test line one' || chr( 10 ) || chr( 10 ) || 'test line two' );
  po.log_test_results( test_label => 'test two', test_passed => true );
  po.log_test_results( test_label => 'test three', test_passed => true );
  po.log_test_results( test_label => 'test four', test_passed => true );
  po.log_test_results( test_label => 'test five', test_passed => true );
  po.log_test_results( test_label => 'test six', test_passed => true );
  po.log_test_results( test_label => 'test seven', test_passed => true );
  po.log_test_results( test_label => 'test eight', test_passed => true );
  po.log_test_results( test_label => 'test nine', test_passed => false );
  po.log_test_results( test_label => 'test ten', test_passed => true );
  po.log_test_completion;
end;
/

exit;
