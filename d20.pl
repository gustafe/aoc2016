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

sub stringify {
    my ($n) = @_;
    die "can't stringify this giant number $n!" unless $n <= $MAX_IP;
    my @dotted = unpack 'C4', pack 'N', $n;
    return sprintf( "%10d (%3d.%3d.%3d.%3d)", $n, @dotted );
}

@ranges = sort { $a->[0] <=> $b->[0] } @ranges;

my $starting      = shift @ranges;
my $hwm           = $starting->[1];
my $allowed       = 0;
my $first_allowed = undef;
while (@ranges) {
    my $ending = shift @ranges;
    if ($debug) {
        say "  HWM: ", stringify($hwm);

        #        printf( "  HWM: %10s   %10d\n", '', $hwm );
        say "Start: ",
            stringify( $starting->[0] ), ' - ',
            stringify( $starting->[1] );
        say "  End: ",
            stringify( $ending->[0] ), ' - ',
            stringify( $ending->[1] );

    }
    if ( $debug and ( $starting->[1] >= $ending->[1] ) ) {
        printf( ">OVER: %10d < %10d (%d)\n",
                $ending->[1], $starting->[1], $starting->[1] - $ending->[1] );
    }

    if ( $ending->[0] - $hwm > 1 ) {
        if ( !defined $first_allowed ) {
            $first_allowed = $hwm + 1;
            say "1>> first not blocked: $first_allowed";
        }

        if ($debug) {
            say ">>GAP next highest: ", stringify( $ending->[0] );
            say "               HWM: ", stringify($hwm);
            say "              DIFF: ", $ending->[0] - $hwm;
        }
        $allowed += $ending->[0] - $hwm - 1;
    }
    my $this_max = max( @{$starting}, @{$ending} );
    $hwm = $this_max if ( $this_max > $hwm );
    $starting = $ending;
}
$allowed += $MAX_IP - $hwm;
say "2>> number of allowed: $allowed";
