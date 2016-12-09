#!/usr/bin/perl
# Advent of Code 2016 Day 4 - part 2
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
    my ( $code, $sector, $chk ) = $line =~ m/(\D+)(\d+)\[(.*)\]/;
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
    if ( join( '', @result[ 0 .. 4 ] ) eq $chk ) {    # valid code, not decoy
        my $key = $sector % 26;
        my @decode;
        foreach my $c ( split( //, $code ) ) {
            if ( $c eq '-' ) { push @decode, ' '; next; }
            my $ord = ord($c) + $key;
            if ( $ord > ord('z') ) { $ord -= 26 }
            push @decode, chr($ord);
        }

        # use `grep` on the output to find the desired string
        say join( '', @decode ), $sector;
    }
}

