declare
    v_output_obj pluto_output_tap_obj := pluto_output_tap_obj();
begin
    v_output_obj.log_test_count( test_count => 2 );
    v_output_obj.log_message( message => 'testing message one' );
    v_output_obj.log_test_results( test_label => 'test one', test_passed => true, details => 'test one of more than one' );
    v_output_obj.log_test_results( test_label => 'test two', test_passed => false, details => 'test two of more than one' );
    v_output_obj.log_test_completion();
end;

/* EXPECTED RESULTS
1..2
# testing message one
ok - test one
not ok - test two
*/
