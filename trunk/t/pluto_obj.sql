begin
    execute immediate 
'create or replace type testing_obj under pluto_obj(
  member procedure startup_testing,
  member procedure startup_testing_again,
  member procedure setup_testing,
  member procedure teardown_testing,
  member procedure shutdown_testing,
  member procedure test_one,
  member procedure test_two,
  constructor function testing_obj
    return self as result
)
instantiable not final';

    execute immediate
'create or replace type body testing_obj is
  member procedure startup_testing is
  begin
    m_util_object.set_test_count( 2 );
  end startup_testing;
  member procedure startup_testing_again is
  begin
    m_util_object.log( ''running startup_testing_again'' );
  end startup_testing_again;
  member procedure setup_testing is
  begin
    m_util_object.log( ''running setup_testing'' );
  end setup_testing;
  member procedure teardown_testing is
  begin
    m_util_object.log( ''running teardown_testing'' );
  end teardown_testing;
  member procedure shutdown_testing is
  begin
    m_util_object.finish;
  end shutdown_testing;
  member procedure test_one is
  begin
    m_util_object.ok(
      test_passed    => true,
      test_label     => ''running test_one''      ||
                        chr( 10 )               ||
                        ''i hope that it worked''
    );
  end test_one;
  member procedure test_two is
  begin
    m_util_object.ok( test_passed => true, test_label => ''running test_two'' );
  end test_two;
  constructor function testing_obj
    return self as result is
  begin
    m_util_object              :=
                   pluto_util_obj( output_object => pluto_output_tap_obj( ));
    return;
  end testing_obj;
end;';

    execute immediate
'declare
  testing  testing_obj;
begin
  testing                    := testing_obj( );
  testing.run_tests;
end;';

    execute immediate 'drop type testing_obj';

end;
/* EXPECTED RESULTS
1..2
# running startup_testing_again
# running setup_testing
ok - running test_one i hope that it worked
# running teardown_testing
# running setup_testing
ok - running test_two
# running teardown_testing
*/
