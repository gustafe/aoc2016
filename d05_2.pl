#!/usr/bin/perl
# Advent of Code 2016 Day 5 - part 2
# Problem link: http://adventofcode.com/2016/day/5
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d05
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum notall/;
# this module is available from CPAN
use Digest::MD5 qw(md5_hex);

#### INIT
my $testing = 0;
my $input = $testing ? 'abc' : 'abbhdwsy';

### CODE
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
            say join( '', map { $_ ? $_ : '_' } @password );
        }
    }
    $i++;
}

say join( '', @password );
