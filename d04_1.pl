#!/usr/bin/perl
# Advent of Code 2016 Day 4 - part 1
# Problem link: http://adventofcode.com/2016/day/4
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d04
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################

use strict;
use warnings;
use feature qw/say/;

#### INIT

my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open F, "<$file" or die "can't open $file: $!\n";
while (<F>) { chomp; s/\r//gm; push @input, $_; }
close F;

### CODE
my $sum = 0;
foreach my $line (@input) {
    my ( $code, $sector, $key ) = $line =~ m/(\D+)(\d+)\[(.*)\]/;
    my %freq;
    foreach my $c ( split( //, $code ) ) {
        next if $c eq '-';
        $freq{$c}++;
    }
    my @result;
    foreach ( sort { ( $freq{$b} <=> $freq{$a} ) || ( $a cmp $b ) }
              keys %freq )
    {
        push @result, $_;
    }
    if ( join( '', @result[ 0 .. 4 ] ) eq $key ) {
        $sum += $sector;
    }
}
say $sum;
