#!/usr/bin/perl
# Advent of Code 2016 Day 3 - part 1
# Problem link: http://adventofcode.com/2016/day/3
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d03
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my $count = 0;
foreach my $line (@input) {
    my @triple = sort { $a <=> $b } ( $line =~ m/(\d+)\s+(\d+)\s+(\d+)/ );
    $count++ if ( $triple[2] < $triple[0] + $triple[1] );
}
say "Number of triangles is $count";
