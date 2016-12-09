#!/usr/bin/perl
# Advent of Code 2016 Day 5 - part 2 with timer information
# Problem link: http://adventofcode.com/2016/day/5
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d05
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################

use strict;
use warnings;
use feature qw/say/;
use List::Util qw/sum notall/;
use Time::HiRes qw/gettimeofday tv_interval/;

# this module is available from CPAN
use Digest::MD5 qw(md5_hex);
#### INIT

my $testing = 0;
my $input = $testing ? 'abc' : 'abbhdwsy';

### CODE

my $t0 = [gettimeofday];
say " input: $input";
my @password = (undef) x 8;
my $i        = 0;

while ( notall { defined $_ } @password ) {
    my $hash = md5_hex( $input . $i );
    if ( $hash =~ m/^00000/ ) {

        # 6th char indicates position 0-7, 7th indicates character to
        # place there
        my $pos = ( split( //, $hash ) )[5];
        if ( $pos =~ m/[0-7]/ and !defined( $password[$pos] ) ) {
            $password[$pos] .= ( split( //, $hash ) )[6];

            # ANIMATE!
            #            say join( '', map { $_ ? $_ : '_' } @password );
        }
    }
    $i++;
}

#my $t1 = [gettimeofday];
my $elapsed = tv_interval($t0);
say 'answer: ', join( '', @password );
say sprintf( "%d hashes. Elapsed time: %d s, %.02f KH/s",
             $i, $elapsed, $i / 1_000 / $elapsed );
