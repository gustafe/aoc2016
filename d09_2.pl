#!/usr/bin/perl
# Advent of Code 2016 Day 9 - part 2
# Problem link: http://adventofcode.com/2016/day/9
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d09
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum/;
use Data::Dumper;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test2.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE

sub get_count {
    my @ary = @_;
    my $count = 0;
    while (@ary) {
        my $c = shift @ary;
        if ( $c eq '(' ) {
            my $marker = $c;
            my $t      = shift @ary;
            while ( $t ne ')' ) {
                $marker .= $t;
                $t = shift @ary;
            }
            $marker .= ')';
            my ( $part, $rep ) = ( 0, 0 );
            if ( $marker =~ /\((\d+)x(\d+)\)/ ) {
                ( $part, $rep ) = ( $1, $2 );
            } else {
                $count += length $marker;
            }
            my @d = splice @ary, 0, $part;
            $count += get_count(@d) * $rep;
        } else {
            $count++;
        }
    }
    return $count;
}

# we will only have one line for "real" input, the foreach loop is for testing
foreach my $line (@input) {
    my @stream = split( //, $line );
    say get_count(@stream);
}
