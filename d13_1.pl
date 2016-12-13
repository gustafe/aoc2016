#!/usr/bin/perl
# Advent of Code 2016 Day 13 - part 1 
# Problem link: http://adventofcode.com/2016/day/13
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d13
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my ( $input, $target ) = ( 1358, [ 31, 39 ] );
if ($testing) { $input = 10; $target = [ 7, 4 ]; }

### CODE
my $maze;
my $seen;

sub count_ones {

    # http://docstore.mik.ua/orelly/perl/cookbook/ch02_05.htm
    my $str = unpack( "B32", pack( "N", shift ) );
    $str =~ s/^0+(?=\d)//;

    my $count = 0;
    for my $c ( split( //, $str ) ) {
        $count++ if ( $c == 1 );
    }
    return $count;
}

sub is_open {
    my ( $x, $y ) = @_;
    if ( $x < 0 or $y < 0 ) { return 0 }
    if ( exists $maze->{$x}->{$y} ) {
        return $maze->{$x}->{$y};
    }

    my $fact = ( $x * $x + 3 * $x + 2 * $x * $y + $y + $y * $y );
    $fact += $input;
    my $ones = count_ones($fact);
    if ( $ones % 2 == 0 ) {
        $maze->{$x}->{$y} = 1;
        return 1;
    } else {
        $maze->{$x}->{$y} = 0;
        return 0;
    }
}

my @states = ( [ 0, [ 1, 1 ] ] );
LOOP: {
    while (@states) {
        my $move = shift @states;
        my $step = $move->[0];
        my ( $x, $y ) = @{ $move->[1] };

        if ( exists $seen->{$x}->{$y} ) {
            next;
        } else {
            $seen->{$x}->{$y}++;
        }

        # try to move
        $step += 1;
        my @new;
        push @new,
	  ( [ $x + 1, $y ], [ $x - 1, $y ],
	    [ $x, $y + 1 ], [ $x, $y - 1 ] );

        while (@new) {
            my $el = shift @new;
            my ( $new_x, $new_y ) = @$el;
            if ( is_open( $new_x, $new_y ) ) {
                if (     $new_x == $target->[0]
                     and $new_y == $target->[1] )
                {

                    #break out reporting sucess
                    say "steps: $step";
                    last LOOP;
                }
                push @states, [ $step, $el ];
            }
        }

    }
}
