#!/usr/bin/perl
# Advent of Code 2016 Day 9 - part 1
# Problem link: http://adventofcode.com/2016/day/9
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d09
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
# we will only have one line for "real" input, this is for testing
foreach my $line (@input) {
    my @stream = split( //, $line );
    my $count = 0;
    while (@stream) {
        my $c = shift @stream;
        if ( $c eq '(' ) {
            # process marker
            my $marker = $c;
            my $t      = shift @stream;

            while ( $t ne ')' ) { # get end
                $marker .= $t;
                $t = shift @stream;
            }
            $marker .= ')';

            # parse marker
            my ( $part, $rep ) = ( 0, 0 );
            if ( $marker =~ /\((\d+)x(\d+)\)/ ) {
                ( $part, $rep ) = ( $1, $2 );
            } else { # this is not a marker, instead it's chars enclosed in parens
                $count += length $marker;
                next;
            }

            # read input and decompress
            my @d = splice @stream, 0, $part;
            $count += ( scalar @d ) * $rep;

        } else {
            $count++;
        }
    }
    say $count;
}

