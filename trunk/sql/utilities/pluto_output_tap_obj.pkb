set serveroutput on; 
set feedback on; 
set echo on; 

whenever oserror exit failure;
whenever sqlerror exit failure;

create or replace type body pluto_output_tap_obj as
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

    if m_expected_test_count > 0 then
      dbms_output.put_line('1..' || m_expected_test_count );
    else
      dbms_output.put_line( '0..0' );
    end if;
  end log_test_count;
--
  overriding member procedure log_message( message in varchar := '' ) is
    newline_location  number;
    starting_message  varchar2( 4000 );
    current_line      varchar2( 4000 );
    empty_string      varchar2( 1 )    := '';
  begin
    starting_message           := message;

    loop
      newline_location           := instr( starting_message, chr( 10 ));
      exit when(newline_location is null or newline_location = 0 );
      current_line               :=
                          substr( starting_message, 1, newline_location - 1 );
      dbms_output.put_line('# ' || current_line );
      starting_message           :=
                             substr( starting_message, newline_location + 1 );
    end loop;

    if starting_message is not null then
      dbms_output.put_line('# ' || starting_message );
    end if;
  end log_message;
--
  overriding member procedure log_test_results(
    test_label   in  varchar,
    test_passed  in  boolean,
    details      in  varchar := ''
  ) is
    l_test_label  varchar2( 4000 );
  begin
    m_running_test_count       := m_running_test_count + 1;

    if test_passed = true then
      m_passed_test_count        := m_passed_test_count + 1;
      dbms_output.put( 'ok' );
    else
      m_failed_test_count        := m_failed_test_count + 1;
      dbms_output.put( 'not ok' );
    end if;

    l_test_label               := replace( test_label, chr( 10 ), ' ' );

    if test_label is not null then
      dbms_output.put(' - ' || l_test_label );
    end if;

    dbms_output.put_line( '' );
  end log_test_results;
--
  overriding member procedure log_test_completion is
  begin
    if m_expected_test_count is null then
      dbms_output.put_line('1..' || m_running_test_count );
    end if;
  end log_test_completion;
--
end;
/

show errors;

select case when status = 'INVALID' then 1/0 else 1 end
    did_the_object_compile
from user_objects
where object_name = 'PLUTO_OUTPUT_TAP_OBJ'
  and object_type = 'TYPE BODY';

