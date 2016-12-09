#!/usr/bin/perl
# Advent of Code 2016 Day 6 - complete solution
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

my $data;
foreach my $line (@input) {
    my @chars = split( //, $line );
    map { $data->[$_]->{ $chars[$_] }++ } ( 0 .. $#chars );
}

my $answer;
foreach my $hash ( @{$data} ) {

    # reverse the position of $a and $b below for part 1
    my @freq = sort { $hash->{$b} <=> $hash->{$a} } keys %{$hash};
    $answer .= pop @freq;
}
say $answer;
