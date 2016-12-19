#!/usr/bin/perl
# Advent of Code 2016 Day 19 - part 2 (copied solution, see credit)
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
# Credit:
# https://www.reddit.com/r/adventofcode/comments/5j4lp1/2016_day_19_solutions/dbdgnwd/

my $winner = 1;
for ( my $i = 1 ; $i < $no_of_elves ; $i++ ) {
    $winner = $winner % $i + 1;
    if ( $winner > int( $i + 1 ) / 2 ) {
        $winner++;
    }
}

say ">>> $winner";
