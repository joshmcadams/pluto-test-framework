set echo on;
set feedback on;
set serveroutput on;

declare
  type varchar_varray is varray( 4 ) of varchar2( 30 );

  va_types  varchar_varray
                      := varchar_varray( 
                        'PLUTO_OUTPUT_TAP_OBJ',
                        'PLUTO_OUTPUT_OBJ',
			'PLUTO_OBJ', 
                        'PLUTO_PROC_NAME_TAB' 
		      );
  found_it  number         := 0;
begin
  for i in 1 .. va_types.limit
  loop
    select count( * )
      into found_it
      from user_objects
     where object_name = va_types( i );

    if found_it > 0 then
      execute immediate 'drop type ' || va_types( i );
    end if;
  end loop;
end;
/
