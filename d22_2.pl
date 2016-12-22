#!/usr/bin/perl
# Advent of Code 2016 Day 22 - part 2
# Problem link: http://adventofcode.com/2016/day/22
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d22
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
my $debug = 0;
my $nodes;
my ( $max_x, $max_y ) = ( 0, 0 );
for my $line (@input) {
    if ($line =~ m|node\-(x\d+\-y\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)\%$| )
    {
        my ( $id, $size, $used, $avail, $pct ) = ( $1, $2, $3, $4, $5 );
        my ( $x, $y ) = $id =~ m/^x(\d+)\-y(\d+)$/;
        if ( $x > $max_x ) { $max_x = $x }
        if ( $y > $max_y ) { $max_y = $y }
        $nodes->{$y}->{$x} = { id    => $id,
                               size  => $size,
                               used  => $used,
                               avail => $avail,
                               pct   => $pct };
    }
}
say "max_x $max_x max_y $max_y";
for my $x ( 0 .. $max_x ) {
    $nodes->{-1}->{$x} = { size => 10000 };
    $nodes->{ $max_y + 1 }->{$x} = { size => 10000 };
}
for my $y ( 0 .. $max_y ) {
    $nodes->{$y}->{-1} = { size => 10000 };
    $nodes->{$y}->{ $max_x + 1 } = { size => 10000 };
}

my $start;
# print the grid!
for my $y ( sort { $a <=> $b } keys %{$nodes} ) {
    next unless ( $y >= 0 and $y <= $max_y );
    for my $x ( sort { $a <=> $b } keys %{ $nodes->{$y} } ) {
        next unless ( $x >= 0 and $x <= $max_x );
        if ($debug) {
            printf( "%3d/%3d ",
                    map { $nodes->{$y}->{$x}->{$_} } qw/used size/ );
        } else {
            if ( $x == 0      and $y == 0 ) { print 'O'; next; }
            if ( $x == $max_x and $y == 0 ) { print 'G'; next; }
            if ( $nodes->{$y}->{$x}->{used} == 0 ) {
                $start->{x} = $x;
                $start->{y} = $y;
                print '_';
                next;
            }

            # can we transfer to neighbor?
	    # if not, it's a "wall"
            my $up    = $nodes->{ $y - 1 }->{$x}->{size};
            my $down  = $nodes->{ $y + 1 }->{$x}->{size};
            my $left  = $nodes->{$y}->{ $x - 1 }->{size};
            my $right = $nodes->{$y}->{ $x + 1 }->{size};
            my $used  = $nodes->{$y}->{$x}->{used};
            if (    $used > $up
                 or $used > $down
                 or $used > $left
                 or $used > $right )
            {
                print '#';
                next;
            } else {
                print '.';
            }
        }
    }
    print "\n";
}

printf( "Start: x=%d y=%d\n", $start->{x}, $start->{y} );

# Solution strategy:
# https://www.reddit.com/r/adventofcode/comments/5jor9q/2016_day_22_solutions/dbhvzaw/
#     move empty to 0,0: moves = start_x + start_y
# move empty to x_max,0: moves += x_max
# each move of goal data one step left is 5 moves:
#                        moves += (x_max - 1)*5

say "Part 2: ", $start->{x} + $start->{y} + $max_x + ( $max_x - 1 ) * 5;
