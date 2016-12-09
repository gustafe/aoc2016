#!/usr/bin/perl
# Advent of Code 2016 Day 7 - part 2, alternative with regexp lookahead
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

	# following regex cargo-cult copied from
	# http://stackoverflow.com/questions/14259677/matching-two-overlapping-patterns-with-perl
        while ( $hn =~ m/(?=(.)(.)\1)/g ) {
            next if $1 eq $2;
            $compare{ $1 . $2 . $1 }++;
        }
    }
    foreach my $sn (@supernets) {
        while ( $sn =~ m/(?=(.)(.)\1)/g ) {
            next if $1 eq $2;
            if ( exists $compare{ $2 . $1 . $2 } ) {
                $matches++;
            }
        }
    }
    $count++ if $matches > 0;
}

say $count;
