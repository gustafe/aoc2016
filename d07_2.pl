#!/usr/bin/perl
# Advent of Code 2016 Day 7 - part 2
# Problem link: http://adventofcode.com/2016/day/7
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d07
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test2.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my $count = 0;
foreach my $line (@input) {
    my (@hypernets) = $line =~ m/\[([^]]+)\]/g;
    my @supernets = split( /\[.*?\]/, $line );

    my %compare;
    my $matches = 0;
    foreach my $hn (@hypernets) {
        my @part = split( //, $hn );
        for ( my $i = 0 ; $i < scalar @part - 2 ; $i++ ) {
            if (     $part[$i] eq $part[ $i + 2 ]
                 and $part[$i] ne $part[ $i + 1 ] )
            {
                $compare{ $part[$i] . $part[ $i + 1 ] . $part[ $i + 2 ] }++;
            }
        }
    }
    foreach my $sn (@supernets) {
        my @part = split( //, $sn );
        for ( my $i = 0 ; $i < scalar @part - 2 ; $i++ ) {
            if (     $part[$i] eq $part[ $i + 2 ]
                 and $part[$i] ne $part[ $i + 1 ] )
            {
                if ( exists $compare{ $part[ $i + 1 ]
                             . $part[$i]
                             . $part[ $i + 1 ] } )
                {
                    $matches++;
                }
            }
        }
    }
    $count++ if $matches > 0;

}

say $count;
