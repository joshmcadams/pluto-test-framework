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

