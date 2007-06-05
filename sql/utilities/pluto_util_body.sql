set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace package body pluto_util as
--
  m_output_obj  pluto_output_obj;
--
  procedure initialize( output_object pluto_output_obj ) is
  begin
    m_output_obj               := output_object;
  end initialize;
--
  procedure set_test_count( test_count number ) is
  begin
    m_output_obj.log_test_count( test_count );
  end set_test_count;
--
  procedure finish is
  begin
    m_output_obj.log_test_completion;
  end finish;
--
  procedure log( message varchar ) is
  begin
    null;
  end log;
--
  procedure ok( ok_or_not boolean, test_label varchar ) is
    result  boolean;
  begin
    result                     := pluto_tap_util.ok( ok_or_not, test_label );
  end ok;
--
  function ok( ok_or_not boolean, test_label varchar )
    return boolean is
    l_test_label  varchar2( 4000 );
  begin
    l_test_label               :=
                                replace( trim( test_label ), chr( 10 ), ' ' );

    return true;
  end ok;
--
end pluto_util;
/

show errors;
