#!/usr/bin/perl
# Advent of Code 2016 Day 16 - complete solution
# Problem link: http://adventofcode.com/2016/day/16
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d16
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################

use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $part2 = shift || 0;
my $testing = 0;
my $input;
my $target_length;
if ($testing) {
    $input         = '10000';
    $target_length = 20;
} else {
    $input = '10111100110001111';
    $target_length = $part2 ? 35651584 : 272;
}
### CODE
sub generate_curve {
    my ( $str, $target ) = @_;
    return $str if length($str) >= $target;
    my $cpy = $str;
    my $out = $str . '0';

    # fsck regex
    for my $c ( reverse split( //, $cpy ) ) {
        if   ( $c == 1 ) { $out .= '0' }
        else             { $out .= '1' }
    }
    generate_curve( $out, $target );
}

sub generate_checksum {
    my ($str) = @_;
    my $out;
    my @a = split( //, $str );
    while (@a) {
        my @pair = splice( @a, 0, 2 );
        if   ( $pair[0] == $pair[1] ) { $out .= '1' }
        else                          { $out .= '0' }
    }
    if ( ( length $out ) % 2 == 0 ) {
        generate_checksum($out);
    } else {
        return $out;
    }
}
if ($testing) {
    for my $teststr (qw/1 0 11111 111100001010/) {
        say $teststr, ' becomes ',
            generate_curve( $teststr, 2 * length($teststr) + 1 ) . '.';
    }
    say generate_checksum('110010110100');
}

my $curve = generate_curve( $input, $target_length );
if ( length $curve > $target_length ) {
    $curve = substr( $curve, 0, $target_length );
}
say generate_checksum($curve);
