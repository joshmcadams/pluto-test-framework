use warnings;
use strict;
use Test::More qw(no_plan);
use Test::Differences;
use File::Slurp qw(read_file);
use DBI;

if ( not defined $ENV{PLUTO_TEST_USER} ) {
    print 'Please enter the test user id: ';
    chomp( $ENV{PLUTO_TEST_USER} = <> );
}

if ( not defined $ENV{PLUTO_TEST_PASSWORD} ) {
    print 'Please enter the test password: ';
    chomp( $ENV{PLUTO_TEST_PASSWORD} = <> );
}

if ( not defined $ENV{PLUTO_TEST_SID} ) {
    print 'Please enter the test sid: ';
    chomp( $ENV{PLUTO_TEST_SID} = <> );
}

my $dbh = DBI->connect(
    "dbi:Oracle:$ENV{PLUTO_TEST_SID}",
    $ENV{PLUTO_TEST_USER},
    $ENV{PLUTO_TEST_PASSWORD},
    { RaiseError => 1, PrintError => 1 }
);
die $DBI::errstr if $DBI::err;

$dbh->func( 1000000, 'dbms_output_enable' );

for my $file (qw( 
    t/pluto_output_obj.sql 
    t/pluto_output_tap_obj.sql 
    t/pluto_util_obj.sql 
    t/pluto_obj.sql 
    t/pluto_obj_named_like.sql 
    )) {
    my $sql = read_file $file;

    $dbh->do($sql);

    my ($expected) = $sql =~ /
    \/\*               # open the sql comment in the sql file
    \s*                # handle any white space before...
    EXPECTED\s+RESULTS # the keywords that let us know that this is our results
    \s*                # handle any spaces
    (                  # capture our expected output
        \S             # this makes sure that we don't pick up extra leading whitespace
        .*             # pick up the middle of the expected output
        \S             # this makes sure that we don't pick up extra trailing whitespace
    )                  # close the capture
    \s*                # pick up an extra whitespace before the close of the comment
    \*\/               # close the comment
/smx;

    my @text = $dbh->func('dbms_output_get');

    my $got = join( "\n", @text );

    eq_or_diff( $got, $expected, $file );

}

$dbh->disconnect();

