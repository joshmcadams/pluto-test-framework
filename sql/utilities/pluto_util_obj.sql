create or replace type pluto_util_obj as object(
  m_output_obj  pluto_output_obj,
--
  constructor function pluto_util_obj(
    output_object  in  pluto_output_obj := null
  )
    return self as result,
--
  member procedure set_test_count( test_count in number ),
--
  member procedure finish,
--
  member procedure log( message in varchar ),
--
  member procedure ok( test_passed in boolean, test_label in varchar )

--
)
instantiable not final;
/
