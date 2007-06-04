set serveroutput on;
set feedback on;
set echo on;

whenever sqlerror exit failure;
whenever oserror exit failure;

create or replace type pluto_obj as object(
--
/****************************************************************************
  Private Attributes
****************************************************************************/
  m_startup_procedures   pluto_proc_name_tab,
  m_shutdown_procedures  pluto_proc_name_tab,
  m_setup_procedures     pluto_proc_name_tab,
  m_teardown_procedures  pluto_proc_name_tab,
  m_testing_procedures   pluto_proc_name_tab,
  m_calling_schema       varchar2( 30 ),
  m_calling_object       varchar2( 30 ),
  m_testing_block        varchar2( 32000 ),
--
/****************************************************************************
  Public Methods
****************************************************************************/
--
  constructor function pluto_obj
    return self as result,
--
  member procedure run_tests,
--
/****************************************************************************
  Private Methods
****************************************************************************/
--
  member procedure determine_calling_obj,
--
  member procedure collect_all_procedures,
--
  member function get_procedures( wildcard varchar )
    return pluto_proc_name_tab,
--
  member procedure add_procedures_to_block( procedures pluto_proc_name_tab ),
--
  member procedure build_testing_block

--
)
instantiable not final;
/
