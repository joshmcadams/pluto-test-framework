create or replace type pluto_output_tap_obj under pluto_output_obj(
  constructor function pluto_output_tap_obj
    return self as result,
--
  overriding member procedure log_test_count( test_count number ),
--
  overriding member procedure log_test_results(
    test_label   in  varchar,
    test_passed  in  boolean,
    details      in  varchar := ''
  ),
--
  overriding member procedure log_message( message in varchar := '' ),
--
  overriding member procedure log_test_completion

--
)
instantiable not final;
/
