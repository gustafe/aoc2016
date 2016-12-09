#!/usr/bin/perl
# Advent of Code 2016 Day 1 - part 1
# Problem link: http://adventofcode.com/2016/day/1
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d01
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use strict;
use warnings;
use feature qw/say/;

my $testing = 0;
my $file = $testing ? 'test.txt' : 'input.txt' ;
my @input;
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

my %new_dir = ( N => { L => ['W',-1, 0],
		       R => ['E', 1, 0] },
		E => { L => ['N', 0, 1],
		       R => ['S', 0,-1] },
		S => { L => ['E', 1, 0],
		       R => ['W',-1, 0] },
		W => { L => ['S', 0,-1],
		       R => ['N', 0, 1] } );

my $pos = [ 'N', 0, 0 ];

my @dirs= split(/,\ /, $input[0]);

foreach my $turn ( @dirs ) {
    my ( $v, $l ) = $turn =~ m/(.)(\d+)/;
    say "$turn $v $l" if $testing;
    my $dest = $new_dir{$pos->[0]}->{$v};
    $pos->[0] = $dest->[0];
    $pos->[1] = $pos->[1] + $dest->[1] * $l;
    $pos->[2] = $pos->[2] + $dest->[2] * $l;
}

say join(' ', ('End position:',@{$pos}));
say "Distance: ", abs($pos->[1])+abs($pos->[2]);
