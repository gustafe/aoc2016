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
# https://www.reddit.com/r/adventofcode/comments/5j4lp1/2016_day_19_solutions/dbdnz4l/

# Divide the elves into left and right "halves", the right half being
# bigger if there's an odd number.
my @left = ( 1.. $no_of_elves / 2);
my @right= ( $no_of_elves/2 + 1 .. $no_of_elves );

while ( @left ) {
    # remove the giver
    shift @right;
    # keep the halves balanced
    if ( @right == @left ) {
	my $transfer = shift @right;
	push @left, $transfer;
    }
    # shift the taker to the end of the @right array
    my $taker = shift @left;
    push @right, $taker;
}

say ">>> ", join('',@right);
