#!/usr/bin/perl
# Advent of Code 2016 Day 18 - alternative solution
# Problem link: http://adventofcode.com/2016/day/18
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d18
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum/;
#### INIT - load input data into array
my $part2 = shift || 0;
my $testing = 0;
my @input;
my $target = $testing? 10 : 40;
$target =  400_000 if $part2;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
# inspiration:
# https://www.reddit.com/r/adventofcode/comments/5iyp50/2016_day_18_solutions/dbcp5m0/
# don't load all data, just count 2 at a time

my $safe = 1;
my $trap = 0;
my $safe_count = 0;
my @row = ( $safe,
	    map  {$_ eq '^' ? $trap : $safe } (split //, $input[0]),
	    $safe );

$safe_count = sum( @row ) - 2;

for my $count ( 1 .. $target - 1 ) {
    my @new = (undef) x @row;
    $new[0] = $new[-1] = $safe;
    for ( my $i = 1; $i < @row -1 ; $i++ ) {
	$new[$i] //= ( $row[$i-1] xor $row[$i+1])? $trap : $safe ;
    }
    $safe_count = sum( @new ) - 2;
    @row = @new;
}
say ">>> $safe_count";
