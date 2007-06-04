set echo on;
set feedback on;
set serveroutput on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace type pluto_output_tap_obj under pluto_output_obj(
  constructor function pluto_output_tap_obj
    return self as result,
  overriding member procedure log_test_count( test_count number ),
  overriding member procedure log_test_results(
    test_name    in  varchar,
    test_passed  in  boolean,
    details      in  varchar := ''
  ),
  overriding member procedure log_test_completion
)
instantiable not final;
/

create or replace type body pluto_output_tap_obj is
--
  constructor function pluto_output_tap_obj
    return self as result is
  begin
    m_passed_test_count        := 0;
    m_failed_test_count        := 0;
    m_running_test_count       := 0;
    return;
  end pluto_output_tap_obj;
--
  overriding member procedure log_test_count( test_count number ) is
  begin
    m_expected_test_count      := test_count;
    dbms_output.put_line('1..' || m_expected_test_count );
  end log_test_count;
  overriding member procedure log_test_results(
    test_name    in  varchar,
    test_passed  in  boolean,
    details      in  varchar := ''
  ) is
  begin
    m_running_test_count       := m_running_test_count + 1;

    if test_passed = true then
      m_passed_test_count        := m_passed_test_count + 1;
      dbms_output.put_line('ok - ' || test_name );
    else
      m_failed_test_count        := m_failed_test_count + 1;
      dbms_output.put_line('not ok - ' || test_name );
    end if;
  end log_test_results;
  overriding member procedure log_test_completion is
  begin
    if m_expected_test_count is null then
      dbms_output.put_line('1..' || m_running_test_count );
    end if;
  end log_test_completion;
end;
/

