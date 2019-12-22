#!/usr/bin/perl
# Advent of Code 2016 Day 15 - Timing is Everything - complete solution
# Problem link: http://adventofcode.com/2016/day/15
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d15
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/all max/;
use Test::More;
#### INIT - load input data into array
my $testing = 0;
my $part2   = shift || 0; # call with any argument for part 2

my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my %discs;

for my $line (@input) {

    my ( $disc_id, $slots, $initial )
        = $line
        =~ m/^Disc \#(\d+) has (\d+) positions\; at time=0, it is at position (\d+)\.$/;
    $discs{$disc_id} = { slots => $slots, pos => $initial };
}

if ($part2) {
    my $new = max( keys %discs ) + 1;
    $discs{$new} = { slots => 11, pos => 0 };
}

my $t0 = 0;
my $solution;
while (1) {
    my @vec;
    for my $d ( sort { $a <=> $b } keys %discs ) {
        my $t   = $t0 + $d;
        my $pos = $discs{$d}->{pos} + $t;
        push @vec, $pos % $discs{$d}->{slots};

    }

    if ( all { $_ == 0 } (@vec) ) {
	$solution = $t0;
#        say $t0;
        last;
    }
    $t0++;
}

my %correct = (part1=>203660,
	       part2=>2408135);

is($solution,
   $part2?$correct{part2}:$correct{part1},
   $part2?"Part 2: ".$solution:"Part 1: ".$solution);
done_testing();
