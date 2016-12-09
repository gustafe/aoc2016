#!/usr/bin/perl
# Advent of Code 2016 Day 7 - part 1
# Problem link: http://adventofcode.com/2016/day/7
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d07
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
    my (@hypernets) = $line =~ m/\[([^]]+)\]/g;
    my @parts = split( /\[.*?\]/, $line );
    my $taboo = 0;
    foreach my $hn (@hypernets) {
        $taboo++ if ( $hn =~ m/(.)(.)\2\1/ and $1 ne $2 );
    }
    next if $taboo;
    my $matches = 0;
    foreach my $part (@parts) {
        if ( $part =~ m/(.)(.)\2\1/ and $1 ne $2 ) {
            $matches++;
        }
    }
    $count++ if $matches > 0;
}
say $count;
