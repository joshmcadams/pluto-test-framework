set serveroutput on; 
set feedback on; 
set echo on; 

whenever oserror exit failure;
whenever sqlerror exit failure;

CREATE OR REPLACE TYPE BODY pluto_util_obj is
-------------------------------------------------------------------------------
  constructor function pluto_util_obj(
    output_object  in  pluto_output_obj := null
  )
    return self as result is
  begin
    if output_object is null then
      m_output_obj    := pluto_output_obj();
    else
      m_output_obj    := output_object;
    end if;

    return;
  end pluto_util_obj;
-------------------------------------------------------------------------------
  member procedure set_test_count(test_count in number) is
  begin
    m_output_obj.log_test_count(test_count);
  end set_test_count;
--
  member procedure finish is
  begin
    m_output_obj.log_test_completion;
  end finish;
--
  member procedure log(message in varchar) is
  begin
    m_output_obj.log_message(message);
  end log;
-------------------------------------------------------------------------------
  member function ok(
    self         in out  pluto_util_obj,
    test_passed  in      boolean,
    test_label   in      varchar
  )
    return boolean is
  begin
    m_output_obj.log_test_results(test_label, test_passed);
    return test_passed;
  end ok;
--
  member procedure ok(test_passed in boolean, test_label in varchar) is
    v_result  boolean;
  begin
    v_result    := ok(test_passed, test_label);
  end ok;
-------------------------------------------------------------------------------
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      anydata,
    data_expected  in      anydata,
    test_label     in      varchar
  )
    return boolean is
    result              boolean;
    v_got_number        number;
    v_expected_number   number;
    v_got_date          date;
    v_expected_date     date;
    v_got_varchar       varchar2(4000);
    v_expected_varchar  varchar2(4000);
  begin
    if data_got.gettypename() <> data_expected.gettypename() then
      raise_application_error
                      (
        -20001,
        'Only equivalent type comparisions supported. Got ' ||
        data_got.gettypename()                              ||
        ' and '                                             ||
        data_expected.gettypename()
      );
    end if;

    case data_got.gettypename()
      when 'SYS.NUMBER' then
        if data_got.getnumber(v_got_number) <> dbms_types.success then
          raise_application_error
                             (-20003,
            'Unable to convert anytype of number to number');
        end if;

        if data_expected.getnumber(v_expected_number) <> dbms_types.success then
          raise_application_error
                             (-20003,
            'Unable to convert anytype of number to number');
        end if;

        return is_ok(v_got_number, v_expected_number, test_label);
      when 'SYS.DATE' then
        if data_got.getdate(v_got_date) <> dbms_types.success then
          raise_application_error
                                 (-20003,
            'Unable to convert anytype of date to date');
        end if;

        if data_expected.getdate(v_expected_date) <> dbms_types.success then
          raise_application_error
                                 (-20003,
            'Unable to convert anytype of date to date');
        end if;

        return is_ok(v_got_date, v_expected_date, test_label);
      when 'SYS.VARCHAR' then
        if data_got.getvarchar(v_got_varchar) <> dbms_types.success then
          raise_application_error
                           (-20003,
            'Unable to convert anytype of varchar to varchar');
        end if;

        if data_expected.getvarchar(v_expected_varchar) <> dbms_types.success then
          raise_application_error
                           (-20003,
            'Unable to convert anytype of varchar to varchar');
        end if;

        return is_ok(v_got_varchar, v_expected_varchar, test_label);
      else
        raise_application_error
                    (
          -20002,
          'Unsupported type of '                                   ||
          data_got.gettypename()                                   ||
          ' encountered when trying to convert an anydata element'
        );
    end case;
  end is_ok;
--
  member procedure is_ok(
    data_got       in  anydata,
    data_expected  in  anydata,
    test_label     in  varchar
  ) is
    v_result  boolean;
  begin
    v_result    := is_ok(data_got, data_expected, test_label);
  end is_ok;
-------------------------------------------------------------------------------
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      number,
    data_expected  in      number,
    test_label     in      varchar
  )
    return boolean is
  begin
    return is_ok_helper(
            data_got = data_expected,
            to_char(data_got),
            to_char(data_expected),
            test_label
          );
  end is_ok;
--
  member procedure is_ok(
    data_got       in  number,
    data_expected  in  number,
    test_label     in  varchar
  ) is
    v_result  boolean;
  begin
    v_result    := is_ok(data_got, data_expected, test_label);
  end is_ok;
-------------------------------------------------------------------------------
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      varchar,
    data_expected  in      varchar,
    test_label     in      varchar
  )
    return boolean is
  begin
    return is_ok_helper(
            data_got = data_expected,
            to_char(data_got),
            to_char(data_expected),
            test_label
          );
  end is_ok;
--
  member procedure is_ok(
    data_got       in  varchar,
    data_expected  in  varchar,
    test_label     in  varchar
  ) is
    v_result  boolean;
  begin
    v_result    := is_ok(data_got, data_expected, test_label);
  end is_ok;
-------------------------------------------------------------------------------
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      boolean,
    data_expected  in      boolean,
    test_label     in      varchar
  )
    return boolean is
    v_got       varchar2(10);
    v_expected  varchar2(10);
  begin
    if data_got is null then
      v_got    := 'NULL';
    elsif data_got then
      v_got    := 'TRUE';
    else
      v_got    := 'FALSE';
    end if;

    if data_expected is null then
      v_expected    := 'NULL';
    elsif data_expected then
      v_expected    := 'TRUE';
    else
      v_expected    := 'FALSE';
    end if;

    return is_ok_helper(data_got = data_expected, v_got, v_expected,
            test_label);
  end is_ok;
--
  member procedure is_ok(
    data_got       in  boolean,
    data_expected  in  boolean,
    test_label     in  varchar
  ) is
    v_result  boolean;
  begin
    v_result    := is_ok(data_got, data_expected, test_label);
  end is_ok;
-------------------------------------------------------------------------------
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      date,
    data_expected  in      date,
    test_label     in      varchar
  )
    return boolean is
  begin
    return is_ok_helper(
            data_got = data_expected,
            to_char(data_got),
            to_char(data_expected),
            test_label
          );
  end is_ok;
--
  member procedure is_ok(
    data_got       in  date,
    data_expected  in  date,
    test_label     in  varchar
  ) is
    v_result  boolean;
  begin
    v_result    := is_ok(data_got, data_expected, test_label);
  end is_ok;
-------------------------------------------------------------------------------
  member function is_ok(
    self           in out  pluto_util_obj,
    data_got       in      timestamp,
    data_expected  in      timestamp,
    test_label     in      varchar
  )
    return boolean is
  begin
    return is_ok_helper(
            data_got = data_expected,
            to_char(data_got),
            to_char(data_expected),
            test_label
          );
  end is_ok;
--
  member procedure is_ok(
    data_got       in  timestamp,
    data_expected  in  timestamp,
    test_label     in  varchar
  ) is
    v_result  boolean;
  begin
    v_result    := is_ok(data_got, data_expected, test_label);
  end is_ok;
-------------------------------------------------------------------------------
  member function is_ok_helper(
    self           in out  pluto_util_obj,
    test_passed    in      boolean,
    data_got       in      varchar,
    data_expected  in      varchar,
    test_label     in      varchar
  )
    return boolean is
  begin
    ok(test_passed, test_label);

    if not test_passed then
      m_output_obj.log_message(
        'Got ''' || data_got || ''' when expected ''' || data_expected || ''''
      );
    end if;

    return test_passed;
  end is_ok_helper;
-------------------------------------------------------------------------------
  member function table_exists(
    self        in out  pluto_util_obj,
    table_name  in      varchar
  )
    return boolean is
    v_exists      number       := 0;
    v_table_name  varchar2(50);
  begin
    v_table_name    := table_name;

    select count(*)
      into v_exists
      from user_tables
     where table_name = upper(v_table_name);

    return is_ok(
            data_got         => v_exists,
            data_expected    => 1,
            test_label       => v_table_name || ' exists'
          );
  end table_exists;
--
  member procedure table_exists(table_name in varchar) is
    v_result  boolean;
  begin
    v_result    := table_exists(table_name);
  end table_exists;
-------------------------------------------------------------------------------
end;
/

select case when status = 'INVALID' then 1/0 else 1 end
    did_the_object_compile
from user_objects
where object_name = 'PLUTO_UTIL_OBJ'
  and object_type = 'TYPE BODY';

