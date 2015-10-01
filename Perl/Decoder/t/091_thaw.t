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
use Sereal::Decoder;
use Module::Runtime qw/ use_module /;

sysopen( my $fh, 'freezethaw-hooks-test.serialized', O_RDWR|O_CREAT );
my $serialized = '';
while ( my $line = <$fh> ) {
    $serialized .= $line;
}

# This first method *should* work, but bombs.
# For someone coming from Storable, this is at least
# the expected behaviour.

my $foo1 = Sereal::Decoder->new( { freeze_callbacks => 1 } )->decode( $serialized );
is $foo1->{ scalar }, 42, 'the scalar came back ok';
is &{$foo1->{ code_ref }}, 1234, 'code_ref was correctly inserted';

# This method actually works and was dreamed up by mst.
# No idea where and if this could be incorporated into
# the Decoder

my $foo2 = do {
    no warnings 'once';
    my $thaw;
    $thaw = local *UNIVERSAL::THAW = sub {
        my ( $class, @args ) = @_;
        my $real_thaw = use_module( $class )->can( 'THAW' );
        die "Could not find a THAW method in package $class"
          unless $real_thaw ne $thaw;
        &$real_thaw;
    };
    Sereal::Decoder->new( { freeze_callbacks => 1 } )->decode( $serialized );
};

is $foo2->{ scalar }, 42, 'the scalar came back ok';
is &{$foo2->{ code_ref }}, 1234, 'code_ref was correctly inserted';

done_testing;
