#!/usr/bin/perl
# Advent of Code 2016 Day 17 - complete solution
# Problem link: http://adventofcode.com/2016/day/17
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d17
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/max/;
use Digest::MD5 qw/md5_hex/;

#### INIT - load input data into array
my $testing = 0;
my $input;
if ( $testing ) {
    $input = 'hijkl';
} else {
    $input = shift || 'yjjvjgan';
}


### CODE
my @sequence = ( [ '', 0, 0 ] );
my @solutions;
LOOP: while (@sequence) {
    # grab the door configuration based on current path
    my $current = shift @sequence;
    my $path    = $current->[0];
    my ( $cur_x, $cur_y ) = @{$current}[ 1, 2 ];
    my $hex = md5_hex( $input . $path );

    # U D L R
    my ( $u, $d, $l, $r ) = $hex =~ m/^(.)(.)(.)(.)/;

    # generate potential paths
    my @tries;
    if ( $u =~ m/[b-f]/ ) { push @tries, [ 'U', $cur_x, $cur_y - 1 ] }
    if ( $d =~ m/[b-f]/ ) { push @tries, [ 'D', $cur_x, $cur_y + 1 ] }
    if ( $l =~ m/[b-f]/ ) { push @tries, [ 'L', $cur_x - 1, $cur_y ] }
    if ( $r =~ m/[b-f]/ ) { push @tries, [ 'R', $cur_x + 1, $cur_y ] }
    while (@tries) {
        my $next = shift @tries;

        # are the moves legal?
        if (    $next->[1] < 0
             or $next->[1] > 3
             or $next->[2] < 0
             or $next->[2] > 3 )
        {
            next;
        }
        if ( $next->[1] == 3 and $next->[2] == 3 ) {

            # say $path.$next->[0];
            push @solutions, $path . $next->[0];
            next;
        }
        push @sequence, [ $path . $next->[0], $next->[1], $next->[2] ];
    }
}
if (scalar @solutions == 0 ) {
    say "input $input didn't result in valid path";
    exit 1;
}

say "Part 1: ", $solutions[0];
say "Part 2: ", max map {length $_} @solutions;
