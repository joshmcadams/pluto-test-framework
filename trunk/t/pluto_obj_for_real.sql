begin
    execute immediate 
'create or replace type testing_obj under pluto_obj(
  member procedure startup_testing,
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
    execute immediate ''create table x ( i number )'';
  end startup_testing;
  member procedure setup_testing is
  begin
    execute immediate ''insert into x (i) values (1)'';
  end setup_testing;
  member procedure teardown_testing is
  begin
    execute immediate ''delete from x'';
  end teardown_testing;
  member procedure shutdown_testing is
  begin
    execute immediate ''drop table x'';
    m_util_object.finish;
  end shutdown_testing;
  member procedure test_one is
    v_i number;
  begin
    select i into v_i from x;
    m_util_object.is_ok(
      got_value      => v_i,
      expected_value => 1,
      test_label     => ''checking value of one''
    );
  end test_one;
  member procedure test_two is
    v_i number;
  begin
    select count(*) into v_i from x; 
    m_util_object.is_ok(
      got_value      => v_i,
      expected_value => 1,
      test_label     => ''checking count of one''
    );
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
