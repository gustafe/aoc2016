#!/usr/bin/perl
# Advent of Code 2016 Day 1 - part 2
# Problem link: http://adventofcode.com/2016/day/1
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d01
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################

use strict;
use warnings;
use feature qw/say/;

my $testing = 0;
my $file = $testing ? 'test.txt' : 'input.txt' ;
open F, "<$file" or die "can't open file: $!\n";
my @input;
while ( <F> ) {
    chomp;
    s/\r//gm;
    push @input, $_;
}
close F;

my %new_dir = ( N => { L => ['W',-1, 0],
		       R => ['E', 1, 0] },
		E => { L => ['N', 0, 1],
		       R => ['S', 0,-1] },
		S => { L => ['E', 1, 0],
		       R => ['W',-1, 0] },
		W => { L => ['S', 0,-1],
		       R => ['N', 0, 1] } );

my $pos = [ 'N', 0, 0 ];
my $seen;
my $location = [$pos->[1], $pos->[2]];
my @dirs= split(/,\ /, $input[0]);

foreach my $turn ( @dirs ) {
    my ( $v, $l ) = $turn =~ m/(.)(\d+)/;

    my $direction = $new_dir{$pos->[0]}->{$v};
    my ( $x, $y ) = @{$pos}[1,2];
    if      ( $direction->[0] eq 'N' ) { # move positive Y
    	for ( my $i = $y; $i < $y+$l; $i++ ) {
	    $seen->{$x}->{$i}++ }
    } elsif ( $direction->[0] eq 'E' ) { # move positive X
    	for ( my $i = $x; $i < $x+$l; $i++ ) {
	    $seen->{$i}->{$y}++ }
    } elsif ( $direction->[0] eq 'S' ) { # move negative Y
    	for ( my $i = $y; $i > $y - $l; $i-- ) {
	    $seen->{$x}->{$i}++ }
    } elsif ( $direction->[0] eq 'W' ) { # move negative X
    	for ( my $i = $x; $i > $x - $l; $i-- ) {
	    $seen->{$i}->{$y}++ }
    } else {
    	die "what direction is this?! $direction->[0]";
    }
    # # check for intersections
    foreach my $x (keys %{$seen})  {
    	foreach  my $y (keys %{$seen->{$x}}) {
	    if ( $seen->{$x}->{$y} == 2 ) { 
		say "intersection at $x,$y, distance: ",abs($x)+abs($y);
		exit 0;
	    }
    	}
    }
    # set new starting position
    $pos->[0] = $direction->[0];
    $pos->[1] = $x + $direction->[1] * $l;
    $pos->[2] = $y + $direction->[2] * $l;
}

