create or replace type body pluto_obj is
--
  constructor function pluto_obj
    return self as result is
  begin
    m_util_object    := pluto_util_obj();
    return;
  end pluto_obj;
--
  member procedure run_tests is
  begin
    self.determine_calling_obj;
    self.collect_all_procedures;
    build_testing_block();

    execute immediate m_testing_block;
  end run_tests;
--
  member function source_revision
    return number is
      v_revision   VARCHAR (50) := '$Revision$';
  begin
    return to_number( regexp_replace ( 
      v_revision, '[^0-9]*([[:digit:]]+).*', '\1'
    ) );
  end source_revision;
--
  member procedure determine_calling_obj is
    holder     anydata;
    dot_index  number;
  begin
    holder              := anydata.convertobject(self);
    dot_index           := instr(holder.gettypename, '.');
    m_calling_schema    := substr(holder.gettypename, 1, dot_index - 1);
    m_calling_object    := substr(holder.gettypename, dot_index + 1);
  end determine_calling_obj;
--
  member function get_procedures(wildcard varchar)
    return pluto_proc_name_tab is
    cursor c_procedure_names(
      in_owner        varchar,
      in_object_name  varchar,
      in_wildcard     varchar
    ) is
      select distinct procedure_name
                 from all_procedures a
                where owner || object_name in(
                        select     owner || type_name
                              from all_types
                        start with owner = upper(in_owner)
                               and type_name = upper(in_object_name)
                        connect by prior supertype_owner = owner
                               and prior supertype_name = type_name)
                  and procedure_name like in_wildcard
                  and object_name <> procedure_name
             order by procedure_name;

    procedures  pluto_proc_name_tab                  := pluto_proc_name_tab();
    l_pname     all_procedures.procedure_name%type;
    loop_index  number;
  begin
    loop_index    := 1;

    for l_pname in c_procedure_names(m_calling_schema, m_calling_object,
                    wildcard)
    loop
      procedures.extend;
      procedures(loop_index)    := l_pname.procedure_name;
      loop_index                := loop_index + 1;
    end loop;

    return procedures;
  end get_procedures;
--
  member procedure collect_all_procedures is
  begin
    m_startup_procedures     := get_procedures('STARTUP%');
    m_shutdown_procedures    := get_procedures('SHUTDOWN%');
    m_setup_procedures       := get_procedures('SETUP%');
    m_teardown_procedures    := get_procedures('TEARDOWN%');
    m_testing_procedures     := get_procedures('TEST%');
  end collect_all_procedures;
--
  member procedure add_procedures_to_block(procedures pluto_proc_name_tab) as
    v_loop_index  number;
  begin
    for v_loop_index in 1 .. procedures.count
    loop
      m_testing_block    :=
         m_testing_block || 't.' || procedures(v_loop_index) || ';'
         || chr(10);
    end loop;
  end add_procedures_to_block;
--
  member procedure build_testing_block as
  begin
    m_testing_block    :=
      'declare t '     ||
      m_calling_schema ||
      '.'              ||
      m_calling_object ||
      '; '             ||
      chr(10)          ||
      'begin'          ||
      chr(10)          ||
      't := '          ||
      m_calling_schema ||
      '.'              ||
      m_calling_object ||
      '();'            ||
      chr(10);
    add_procedures_to_block(m_startup_procedures);

    for v_loop_index in 1 .. m_testing_procedures.count
    loop
      add_procedures_to_block(m_setup_procedures);
      m_testing_block    :=
        m_testing_block                    ||
        't.'                               ||
        m_testing_procedures(v_loop_index) ||
        ';'                                ||
        chr(10);
      add_procedures_to_block(m_teardown_procedures);
    end loop;

    add_procedures_to_block(m_shutdown_procedures);
    m_testing_block    := m_testing_block || 'end;';
  end build_testing_block;
--
end;
/
