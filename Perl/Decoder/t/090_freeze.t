#!perl
use strict;
use warnings;
use File::Spec;

# These tests use an installed Encoder.
# Purpose: See if we correctly set overload magic on deserialized
#          objects in funny circumstances.

use lib File::Spec->catdir(qw(t lib));
BEGIN {
    lib->import('lib')
        if !-d 't';
}

use Sereal::TestSet qw(:all);
use Test::More;
use IO::File;
use Sereal::Encoder;

use Local::Foo;
my $foo        = Local::Foo->new;
my $serialized = Sereal::Encoder->new( { freeze_callbacks => 1 } )->encode( $foo );

sysopen( my $fh, 'freezethaw-hooks-test.serialized', O_RDWR|O_CREAT );
print $fh $serialized;

ok $serialized, 'encoding worked';
done_testing;
