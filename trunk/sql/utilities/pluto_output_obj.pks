set serveroutput on; 
set feedback on; 
set echo on; 

whenever oserror exit failure;
whenever sqlerror exit failure;

create or replace type pluto_output_obj authid current_user as object(
  m_expected_test_count  number,
  m_passed_test_count    number,
  m_failed_test_count    number,
  m_running_test_count   number,
--
/****************************************************************************
  Public Methods
****************************************************************************/
--
  constructor function pluto_output_obj
    return self as result,
--
  member procedure log_test_count( test_count in number ),
--
  member procedure log_test_results(
    test_label   in  varchar,
    test_passed  in  boolean,
    details      in  varchar := ''
  ),
--
  member procedure log_message( message in varchar := '' ),
--
  member procedure log_test_completion

--
)
instantiable not final;
/

show errors;

select case when status = 'INVALID' then 1/0 else 1 end
    did_the_object_compile
from user_objects
where object_name = 'PLUTO_OUTPUT_OBJ'
  and object_type = 'TYPE';

