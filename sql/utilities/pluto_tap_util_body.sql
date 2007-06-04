set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace package body pluto_tap_util as
  procedure plan( test_count in number ) is
  begin
    if test_count > 0 then
      dbms_output.put_line('1..' || test_count );
    end if;
  end plan;

  procedure diag( message in varchar ) is
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
      starting_message           :=
                             substr( starting_message, newline_location + 1 );
    end loop;

    if starting_message is not null then
      dbms_output.put_line('# ' || starting_message );
    end if;
  end diag;

  procedure ok( ok_or_not boolean, test_label varchar ) is
    result  boolean;
  begin
    result                     := pluto_tap_util.ok( ok_or_not, test_label );
  end ok;

  function ok( ok_or_not boolean, test_label varchar )
    return boolean is
    l_test_label  varchar2( 4000 );
  begin
    l_test_label               :=
                                replace( trim( test_label ), chr( 10 ), ' ' );

    if ( ok_or_not = true ) then
      dbms_output.put( 'ok' );
    else
      dbms_output.put( 'not ok' );
    end if;

    if l_test_label is not null then
      dbms_output.put(' - ' || l_test_label );
    end if;

    dbms_output.put_line( '' );
    return true;
  end ok;
end pluto_tap_util;
/
