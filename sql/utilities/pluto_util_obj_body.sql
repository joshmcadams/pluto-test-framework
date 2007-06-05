create or replace type body pluto_util_obj is
--
  constructor function pluto_util_obj(
    output_object  in  pluto_output_obj := null
  )
    return self as result is
  begin
    if output_object is null then
      m_output_obj               := pluto_output_obj( );
    else
      m_output_obj               := output_object;
    end if;

    return;
  end pluto_util_obj;
--
  member procedure set_test_count( test_count in number ) is
  begin
    m_output_obj.log_test_count( test_count );
  end set_test_count;
--
  member procedure finish is
  begin
    m_output_obj.log_test_completion;
  end finish;
--
  member procedure log( message in varchar ) is
  begin
    null;
  end log;
--
  member procedure ok( test_passed in boolean, test_label in varchar ) is
    result  boolean;
  begin
    m_output_obj.log_test_results( test_label, test_passed );
  end ok;
--
end;
/
