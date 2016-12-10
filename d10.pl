#!/usr/bin/perl
# Advent of Code 2016 Day 10 - part 1 / part 2 / complete solution
# Problem link: http://adventofcode.com/2016/day/10
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d10
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
my %state;
while ( scalar @input > 0 ) {
    my $cmd = shift @input;
    if ( $cmd =~ m/^value/ ) {
        my ( $init, $recip ) = $cmd =~ /value (\d+) goes to (bot \d+)/;
        push @{ $state{$recip} }, $init;
    } elsif ( $cmd =~ m/^bot.*low.*high/ ) {
        my ( $giver, $lo, $hi )
            = $cmd
            =~ /(bot \d+) gives low to (\S+\s\d+) and high to (\S+\s\d+)/;
        my @c = sort { $a <=> $b } @{ $state{$giver} }
            if exists $state{$giver};
        if ( scalar @c != 2 ) {
            push @input, $cmd;
        } else {
            push @{ $state{$lo} }, shift @c;
            push @{ $state{$hi} }, shift @c;
        }
    } else {
        die "can't parse $cmd";
    }
}

my $part2 = 1;
foreach my $e ( keys %state ) {
    my @a = sort { $a <=> $b } @{ $state{$e} };
    if ( scalar @a == 2 and $a[0] == 17 and $a[1] == 61 ) {
	say "Part 1: $e" ;
    }
    if ( $e eq 'output 0' or $e eq 'output 1' or $e eq 'output 2' ) {
	$part2 *= ${ $state{$e} }[0];
    }
}
say "Part 2: $part2";
