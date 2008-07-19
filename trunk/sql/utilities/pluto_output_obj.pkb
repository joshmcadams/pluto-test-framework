set serveroutput on; 
set feedback on; 
set echo on; 

whenever oserror exit failure;
whenever sqlerror exit failure;

create or replace type body pluto_output_obj is
--
  constructor function pluto_output_obj
    return self as result is
  begin
    m_passed_test_count        := 0;
    m_failed_test_count        := 0;
    m_running_test_count       := 0;
    return;
  end pluto_output_obj;
--
  member procedure log_test_count( test_count in number ) is
  begin
    m_expected_test_count      := test_count;
    dbms_output.put_line('Test Count [' || m_expected_test_count || ']' );
  end log_test_count;
--
  member procedure log_test_results(
    test_label   in  varchar,
    test_passed  in  boolean,
    details      in  varchar
  ) is
  begin
    m_running_test_count       := m_running_test_count + 1;

    if test_passed = true then
      m_passed_test_count        := m_passed_test_count + 1;
      dbms_output.put_line(m_running_test_count || ' - ' || test_label
        || ' passed' );
    else
      m_failed_test_count        := m_failed_test_count + 1;
      dbms_output.put_line(m_running_test_count || ' - ' || test_label
        || ' failed' );
      dbms_output.put_line( details );
    end if;
  end log_test_results;
--
  member procedure log_message( message in varchar := '' ) is
  begin
    dbms_output.put_line( message );
  end log_message;
--
  member procedure log_test_completion is
  begin
    dbms_output.put_line(m_passed_test_count || ' tests passed' );
    dbms_output.put_line(m_failed_test_count || ' tests failed' );

    if ( m_expected_test_count <> m_running_test_count ) then
      dbms_output.put_line(
        'Expected '                 ||
        m_expected_test_count       ||
        ' tests, but actually ran ' ||
        m_running_test_count        ||
        ' tests'
      );

      if m_running_test_count < 1 then
        m_running_test_count       := 1;
      end if;

      dbms_output.put_line(
        (m_passed_test_count / m_running_test_count ) * 100 ||
        ' percent of actual tests successful'
      );
    end if;

    if m_expected_test_count < 1 then
      m_expected_test_count      := 1;
    end if;

    dbms_output.put_line(
      (m_passed_test_count / m_expected_test_count ) * 100 ||
      ' percent of expected tests successful'
    );
  end log_test_completion;
--
end;
/

show errors;

select case when status = 'INVALID' then 1/0 else 1 end
    did_the_object_compile
from user_objects
where object_name = 'PLUTO_OUTPUT_OBJ'
  and object_type = 'TYPE BODY';

