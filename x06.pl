#!/usr/bin/perl
# Advent of Code 2016 Day 6 - complete solution, alternate map version
# Problem link: http://adventofcode.com/2016/day/6
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d06
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;
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
my $part = 1;
my $data;
my $sortings = { 1 => sub { $data->[$_]->{$a} <=> $data->[$_]->{$b} },
                 2 => sub { $data->[$_]->{$b} <=> $data->[$_]->{$a} }, };

foreach my $line (@input) {
    my @chars = split( //, $line );
    map { $data->[$_]->{ $chars[$_] }++ } ( 0 .. $#chars );
}

say join( '', map { ( sort { &{ $sortings->{$part} } }
		      keys %{ $data->[$_] } )[-1] } ( 0 .. $#{$data} ) );
