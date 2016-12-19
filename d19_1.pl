#!/usr/bin/perl
# Advent of Code 2016 Day 19 - part 1
# Problem link: http://adventofcode.com/2016/day/19
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d19
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my $no_of_elves = $testing ? 5 : 3005290;

### CODE

my @elves = (1..$no_of_elves);

while (scalar @elves > 1 ) {
    my $taker = shift @elves;
    shift @elves;
    push @elves, $taker;
}

say ">>> ", join('', @elves);
