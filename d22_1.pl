#!/usr/bin/perl
# Advent of Code 2016 Day 22 - part 1
# Problem link: http://adventofcode.com/2016/day/22
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d22
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
my @nodes;
for my $line (@input) {
    if ($line =~ m|node\-(x\d+\-y\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)\%$| )
    {
        my ( $id, $size, $used, $avail, $pct ) = ( $1, $2, $3, $4, $5 );
        my ( $x, $y ) = $id =~ m/^x(\d+)\-y(\d+)$/;
        push @nodes,
            { id    => $id,
              x     => $x,
              y     => $y,
              size  => $size,
              used  => $used,
              avail => $avail,
              pct   => $pct };
    }
}
my @pairs;
for my $node1 (@nodes) {
    for my $node2 (@nodes) {
        next if ( $node1->{id} eq $node2->{id} );
        next if ( $node1->{used} == 0 );
        if ( $node1->{used} <= $node2->{avail} ) {
            push @pairs, [ $node1, $node2 ];
        }
    }
}

say scalar @pairs;
