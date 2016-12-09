#!/usr/bin/perl
# Advent of Code 2016 Day 2 - part 2, alternate version
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
# Inspired by 
# https://www.reddit.com/r/adventofcode/comments/5g1hfm/2016_day_2_solutions/dap5cuj/
my $movemap = { 1 => { D => 3 },
                2 => { R => 3, D => 6 },
                3 => { U => 1, D => 7, L => 2, R => 4 },
                4 => { D => 8, L => 3 },
                5 => { R => 6 },
                6 => { U => 2, D => 'A', L => 5, R => 7 },
                7 => { U => 3, D => 'B', L => 6, R => 8 },
                8 => { U => 4, D => 'C', L => 7, R => 9 },
                9 => { L => 8 },
                A => { U => 6, R => 'B' },
                B => { U => 7, D => 'D', L => 'A', R => 'C' },
                C => { U => 8, L => 'B' },
                D => { U => 'B' } };

my $pos = 5;
my $solution;
foreach my $line (@input) {
    foreach my $move ( split( //, $line ) ) {
        if ( exists $movemap->{$pos}->{$move} ) {
            $pos = $movemap->{$pos}->{$move};
        }
    }
    $solution .= $pos;
}
say $solution;

