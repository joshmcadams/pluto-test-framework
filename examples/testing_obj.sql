set serveroutput on;
set feedback off;
set echo off;

create or replace type testing_obj under pluto_obj(
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
instantiable not final;
/

create or replace type body testing_obj is
  member procedure startup_testing is
  begin
    pluto_util.initialize( pluto_output_tap_obj( ));
  end startup_testing;
  member procedure startup_testing_again is
  begin
    pluto_util.log( 'running startup_testing_again' );
  end startup_testing_again;
  member procedure setup_testing is
  begin
    pluto_util.log( 'running setup_testing' );
  end setup_testing;
  member procedure teardown_testing is
  begin
    pluto_util.log( 'running teardown_testing' );
  end teardown_testing;
  member procedure shutdown_testing is
  begin
    pluto_util.log('running shutdown_testing' || chr( 10 )
      || 'no, really shut down' );
  end shutdown_testing;
  member procedure test_one is
  begin
    pluto_util.ok(
      test_passed    => true,
      test_label     => 'running test_one'      ||
                        chr( 10 )               ||
                        'i hope that it worked'
    );
  end test_one;
  member procedure test_two is
  begin
    pluto_util.ok( test_passed => true, test_label => 'running test_two' );
  end test_two;
  constructor function testing_obj
    return self as result is
  begin
    return;
  end testing_obj;
end;
/

show errors;

set serveroutput on;
set feedback on;
set echo on;

declare
  testing  testing_obj;
begin
  testing                    := testing_obj( );
  testing.run_tests;
end;
/

drop type testing_obj;
