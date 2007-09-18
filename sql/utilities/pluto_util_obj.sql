create or replace type pluto_util_obj as object(
  m_output_obj  pluto_output_obj,
--
  constructor function pluto_util_obj(
    output_object  in  pluto_output_obj := null
  )
    return self as result,
--
  member procedure set_test_count(test_count in number),
--
  member procedure finish,
--
  member procedure log(message in varchar),
--
  member function ok(
    self         in out  pluto_util_obj,
    test_passed  in      boolean,
    test_label   in      varchar
  )
    return boolean,
--
  member procedure ok(test_passed in boolean, test_label in varchar),
--
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      anydata,
    data_expected  in      anydata,
    test_label     in      varchar
  )
    return boolean,
--
  member procedure is_ok(
    data_got       in  anydata,
    data_expected  in  anydata,
    test_label     in  varchar
  ),
--
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      number,
    data_expected  in      number,
    test_label     in      varchar
  )
    return boolean,
--
  member procedure is_ok(
    data_got       in  number,
    data_expected  in  number,
    test_label     in  varchar
  ),
--
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      varchar,
    data_expected  in      varchar,
    test_label     in      varchar
  )
    return boolean,
--
  member procedure is_ok(
    data_got       in  varchar,
    data_expected  in  varchar,
    test_label     in  varchar
  ),
--
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      boolean,
    data_expected  in      boolean,
    test_label     in      varchar
  )
    return boolean,
--
  member procedure is_ok(
    data_got       in  boolean,
    data_expected  in  boolean,
    test_label     in  varchar
  ),
--
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      date,
    data_expected  in      date,
    test_label     in      varchar
  )
    return boolean,
--
  member procedure is_ok(
    data_got       in  date,
    data_expected  in  date,
    test_label     in  varchar
  ),
--
  member function is_ok_helper(
    self           in out  pluto_util_obj,
    test_passed    in      boolean,
    data_got       in      varchar,
    data_expected  in      varchar,
    test_label     in      varchar
  )
    return boolean,
--
  member function table_exists(
    self        in out  pluto_util_obj,
    table_name  in      varchar
  )
    return boolean,
--
  member procedure table_exists(table_name in varchar)

--
)
instantiable not final;
/
