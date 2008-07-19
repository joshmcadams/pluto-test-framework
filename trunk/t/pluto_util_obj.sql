declare
    v_util_obj pluto_util_obj :=  pluto_util_obj( output_object => pluto_output_tap_obj() );
begin
    v_util_obj.set_test_count( test_count => 4 );
    v_util_obj.log( message => 'testing message one' );
    v_util_obj.ok( test_label => 'test one', test_passed => true );
    v_util_obj.ok( test_label => 'test two', test_passed => false );
    -- number
    v_util_obj.is_ok( data_got => 42, data_expected => 42, test_label => 'ok number' );
    v_util_obj.is_ok( data_got => 42, data_expected => 40, test_label => 'not ok number' );
    -- varchar
    v_util_obj.is_ok( data_got => 'a', data_expected => 'a', test_label => 'ok varchar' );
    v_util_obj.is_ok( data_got => 'a', data_expected => 'b', test_label => 'not ok varchar' );
    -- boolean
    v_util_obj.is_ok( data_got => true, data_expected => true, test_label => 'ok boolean' );
    v_util_obj.is_ok( data_got => true, data_expected => false, test_label => 'not ok boolean' );
    -- date
    v_util_obj.is_ok( data_got => to_date('20081022010203', 'YYYYMMDDHH24MISS'), data_expected => to_date('20081022010203', 'YYYYMMDDHH24MISS'), test_label => 'ok date' );
    v_util_obj.is_ok( data_got => to_date('20081022010204', 'YYYYMMDDHH24MISS'), data_expected => to_date('20081022010203', 'YYYYMMDDHH24MISS'), test_label => 'not ok date' );
    -- timestamp
    v_util_obj.is_ok( data_got => to_timestamp('20081022010203123456', 'YYYYMMDDHH24MISSFF6'), data_expected => to_timestamp('20081022010203123456', 'YYYYMMDDHH24MISSFF6'), test_label => 'ok timestamp' );
    v_util_obj.is_ok( data_got => to_timestamp('20081022010204123456', 'YYYYMMDDHH24MISSFF6'), data_expected => to_timestamp('20081022010203123456', 'YYYYMMDDHH24MISSFF6'), test_label => 'not ok timestamp' );
    v_util_obj.finish();
    -- table exists
    v_util_obj.table_exists( table_name => 'x' );
    execute immediate 'create table x ( i number )';
    v_util_obj.table_exists( table_name => 'x' );
    execute immediate 'drop table x';
end;

/* EXPECTED RESULTS
1..4
# testing message one
ok - test one
not ok - test two
ok - ok number
not ok - not ok number
# Got '42' when expected '40'
ok - ok varchar
not ok - not ok varchar
# Got 'a' when expected 'b'
ok - ok boolean
not ok - not ok boolean
# Got 'TRUE' when expected 'FALSE'
ok - ok date
not ok - not ok date
# Got '20081022010204' when expected '20081022010203'
ok - ok timestamp
not ok - not ok timestamp
# Got '20081022010204123456000' when expected '20081022010203123456000'
not ok - x exists
# Got '0' when expected '1'
ok - x exists
*/
