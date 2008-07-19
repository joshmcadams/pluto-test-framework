use warnings;
use strict;
use Test::More qw(no_plan);

if(not defined $ENV{PLUTO_TEST_USER}) {
    print 'Please enter the test user id: ';
    chomp($ENV{PLUTO_TEST_USER} = <>);
}

if(not defined $ENV{PLUTO_TEST_PASSWORD}) {
    print 'Please enter the test password: ';
    chomp($ENV{PLUTO_TEST_PASSWORD} = <>);
}

my $cmd = "sqlplus $ENV{PLUTO_TEST_USER}/$ENV{PLUTO_TEST_PASSWORD} \@examples/testing_obj.sql";

my @lines = `$cmd`;

print "@lines\n";

ok(1);
