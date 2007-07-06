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
  member procedure is_ok(
    data_got       in  anydata,
    data_expected  in  anydata,
    test_label     in  varchar
  ) is
    result              boolean;
    v_got_number        number;
    v_expected_number   number;
    v_got_date          date;
    v_expected_date     date;
    v_got_varchar       varchar2( 4000 );
    v_expected_varchar  varchar2( 4000 );
  begin
    if data_got.gettypename( ) <> data_expected.gettypename( ) then
      raise_application_error
                      (
        -20001,
        'Only equivalent type comparisions supported. Got ' ||
        data_got.gettypename( )                             ||
        ' and '                                             ||
        data_expected.gettypename( )
      );
    end if;

    case data_got.gettypename( )
      when 'SYS.NUMBER' then
        if data_got.getnumber( v_got_number ) <> dbms_types.success then
          raise_application_error
                            ( -20003,
            'Unable to convert anytype of number to number' );
        end if;

        if data_expected.getnumber( v_expected_number ) <> dbms_types.success then
          raise_application_error
                            ( -20003,
            'Unable to convert anytype of number to number' );
        end if;

        is_ok( v_got_number, v_expected_number, test_label );
      when 'SYS.DATE' then
        if data_got.getdate( v_got_date ) <> dbms_types.success then
          raise_application_error
                                ( -20003,
            'Unable to convert anytype of date to date' );
        end if;

        if data_expected.getdate( v_expected_date ) <> dbms_types.success then
          raise_application_error
                                ( -20003,
            'Unable to convert anytype of date to date' );
        end if;

        is_ok( v_got_date, v_expected_date, test_label );
      when 'SYS.VARCHAR' then
        if data_got.getvarchar( v_got_varchar ) <> dbms_types.success then
          raise_application_error
                          ( -20003,
            'Unable to convert anytype of varchar to varchar' );
        end if;

        if data_expected.getvarchar( v_expected_varchar ) <>
                                                            dbms_types.success then
          raise_application_error
                          ( -20003,
            'Unable to convert anytype of varchar to varchar' );
        end if;

        is_ok( v_got_varchar, v_expected_varchar, test_label );
      else
        raise_application_error
                    (
          -20002,
          'Unsupported type of '                                   ||
          data_got.gettypename( )                                  ||
          ' encountered when trying to convert an anydata element'
        );
    end case;
  end is_ok;
--
  member procedure is_ok(
    data_got       in  number,
    data_expected  in  number,
    test_label     in  varchar
  ) is
    result  boolean;
  begin
    is_ok_helper(
      data_got = data_expected,
      to_char( data_got ),
      to_char( data_expected ),
      test_label
    );
  end is_ok;
--
  member procedure is_ok(
    data_got       in  varchar,
    data_expected  in  varchar,
    test_label     in  varchar
  ) is
    result  boolean;
  begin
    is_ok_helper(
      data_got = data_expected,
      to_char( data_got ),
      to_char( data_expected ),
      test_label
    );
  end is_ok;
--
  member procedure is_ok(
    data_got       in  boolean,
    data_expected  in  boolean,
    test_label     in  varchar
  ) is
    result      boolean;
    v_got       varchar2( 10 );
    v_expected  varchar2( 10 );
  begin
    if data_got is null then
      v_got                      := 'NULL';
    elsif data_got then
      v_got                      := 'TRUE';
    else
      v_got                      := 'FALSE';
    end if;

    if data_expected is null then
      v_expected                 := 'NULL';
    elsif data_expected then
      v_expected                 := 'TRUE';
    else
      v_expected                 := 'FALSE';
    end if;

    is_ok_helper( data_got = data_expected, v_got, v_expected, test_label );
    null;
  end is_ok;
--
  member procedure is_ok(
    data_got       in  date,
    data_expected  in  date,
    test_label     in  varchar
  ) is
    result  boolean;
  begin
    is_ok_helper(
      data_got = data_expected,
      to_char( data_got ),
      to_char( data_expected ),
      test_label
    );
  end is_ok;
--
  member procedure is_ok_helper(
    test_passed    in  boolean,
    data_got       in  varchar,
    data_expected  in  varchar,
    test_label     in  varchar
  ) is
  begin
    ok( test_passed, test_label );

    if not test_passed then
      m_output_obj.log_message(
        'Got ''' || data_got || ''' when expected ''' || data_expected || ''''
      );
    end if;
  end is_ok_helper;
--
end;
/

show errors;
