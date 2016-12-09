#!/usr/bin/perl
# Advent of Code 2016 Day 2 - part 1
# Problem link: http://adventofcode.com/2016/day/2
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d02
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################

use strict;
use warnings;
use feature qw/say/;

#### INIT

my $testing = 0;
my $file = $testing ? 'test.txt' : 'input.txt';
open F, "<$file" or die "can't open file: $!\n";
my @input;
while (<F>) {
    chomp;
    s/\r//gm;
    push @input, $_;
}
close F;

### CODE

my $keypad = [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ];
my $next_move = { U => [ 0,  1 ],
                  D => [ 0,  -1 ],
                  L => [ -1, 0 ],
                  R => [ 1,  0 ] };

# start with a Cartesian grid with the origin at 5:
# 1 2 3
# 4 5 6
# 7 8 9

my $key = [ 0, 0 ];
my $solution;
foreach my $line (@input) {
    my @instructions = split( //, $line );
    foreach my $move (@instructions) {
        my $next = [ $key->[0] + $next_move->{$move}->[0],
                     $key->[1] + $next_move->{$move}->[1] ];
        if ( abs( $next->[0] ) > 1 or abs( $next->[1] ) > 1 ) {
            next;
        } else {
            $key = $next;
        }
    }

    # To get the keys from the arrayref,
    # rotate 90 degrees counter-clockwise: ( x , y ) -> ( -y, x )
    # and translate [+1,+1]
    $solution .= $keypad->[ -$key->[1] + 1 ]->[ $key->[0] + 1 ];
}
say $solution;
