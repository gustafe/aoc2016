#!/usr/bin/perl
# Advent of Code 2016 Day 20 - complete solution
# Problem link: http://adventofcode.com/2016/day/20
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d20
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/max/;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my $debug  = 0;
my $MAX_IP = 4294967295;

my @ranges;
for my $line (@input) {
    my ( $start, $end ) = $line =~ m/^(\d+)\-(\d+)$/;
    push @ranges, [ $start, $end ];
}

@ranges = sort { $a->[0] <=> $b->[0] } @ranges;

my $starting      = shift @ranges;
my $hwm           = $starting->[1];
my $allowed       = 0;
my $first_allowed = undef;
while (@ranges) {
    my $ending = shift @ranges;
    if ($debug) {
        printf( "  HWM: %10s   %10d\n", '', $hwm );
        printf( "Start: %10d - %10d\n", @{$starting} );
        printf( "  End: %10d - %10d\n", @{$ending} );
    }
    if ( $ending->[0] - $hwm > 1 ) {
        if ( !defined $first_allowed ) {
            $first_allowed = $hwm + 1;
            say "1>> first not blocked: $first_allowed";
        }


        if ($debug) {
            printf ">>GAP next highest: %10d\n", $ending->[0];
            printf "               hwm: %10d\n", $hwm;
            printf "              DIFF: %10d\n", $ending->[0] - $hwm;
        }
        $allowed += $ending->[0] - $hwm - 1;
    }
    my $this_max = max( @{$starting}, @{$ending} );
    $hwm = $this_max if ( $this_max > $hwm );
    $starting = $ending;
}
$allowed += $MAX_IP - $hwm;
say "2>> number of allowed: $allowed";
