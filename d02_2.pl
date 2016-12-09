#!/usr/bin/perl
# Advent of Code 2016 Day 2 - part 2
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

# Layout - circle in taxicab geometry!
#
#      1
#    2 3 4
#  5 6 7 8 9
#    A B C
#      D

# Cartesian coordinates, center the origin at 7, x,y for the keys as below

my $keypad = { -2 => {                       0 => 5 },
               -1 => {            -1 => 'A', 0 => 6, 1 => 2 },
                0 => { -2 => 'D', -1 => 'B', 0 => 7, 1 => 3, 2 => 1 },
                1 => {            -1 => 'C', 0 => 8, 1 => 4 },
                2 => {                       0 => 9 } };

my $next_move = { U => [  0,  1 ],
                  D => [  0, -1 ],
                  L => [ -1,  0 ],
                  R => [  1,  0 ] };

my $key = [ -2, 0 ];
my $solution;
foreach my $line (@input) {
    my @instructions = split( //, $line );
    foreach my $move (@instructions) {
        my $next = [ $key->[0] + $next_move->{$move}->[0],
                     $key->[1] + $next_move->{$move}->[1] ];
        if ( abs( $next->[0] ) + abs( $next->[1] ) > 2 ) {
            next;
        } else {
            $key = $next;
        }
    }
    $solution .= $keypad->{ $key->[0] }->{ $key->[1] };
}
say $solution;
