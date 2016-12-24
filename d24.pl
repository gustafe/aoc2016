#!/usr/bin/perl
# Advent of Code 2016 Day 24 - complete solution
# Problem link: http://adventofcode.com/2016/day/24
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d24
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################

# Pipe output through `sort -n | head` for solution

use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use Algorithm::Combinatorics qw(permutations);

#### INIT - load input data into array
my $testing = 0;
my $part2 = shift || 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my $maze;
my $targets;

sub find_shortest_path {
    my ( $start, $end ) = @_;
    my $seen;
    my $shortest = 0;
    my @states = ( [ 0, $start ] );
LOOP: {
        while (@states) {
            my $move = shift @states;
            my $step = $move->[0];
            my ( $r, $c ) = @{ $move->[1] };
            if ( exists $seen->{$r}->{$c} ) {
                next;
            } else {
                $seen->{$r}->{$c}++;
            }

            # try to move
            $step += 1;
            my @new = ( [ $r - 1, $c ],
                        [ $r + 1, $c ],
                        [ $r,     $c - 1 ],
                        [ $r,     $c + 1 ] );
            while (@new) {
                my $try = shift @new;
                my ( $t_r, $t_c ) = @{$try};
                if ( $maze->[$t_r]->[$t_c] ne '#' ) {
                    if ( $t_r == $end->[0] and $t_c == $end->[1] ) {
                        $shortest = $step;
                        last LOOP;
                    }
                    push @states, [ $step, $try ];
                }
            }
        }
    }
    return $shortest;
}

# load the maze
my $row = 0;
for my $line (@input) {
    my $col = 0;
    for my $cell ( split( //, $line ) ) {
        if ( $cell =~ /\d/ ) {
            $targets->{$cell} = [ $row, $col ];
        }
        $maze->[$row]->[$col] = $cell;
        $col++;
    }
    $row++;
}

# calculate distances using BFS
my $map;

for my $k ( sort keys %{$targets} ) {
    for my $j ( sort keys %{$targets} ) {
        next if $k == $j;
        $map->{$k}->{$j}
            = find_shortest_path( $targets->{$k}, $targets->{$j} );
    }
}

my @distances;

# always start at 0, so remove that for now
delete $targets->{0};
my $iter = permutations( [ keys %{$targets} ] );
while ( my $p = $iter->next ) {
    unshift @$p, '0';
    push @$p, '0' if $part2;
    my $dist = 0;
    for ( my $i = 0 ; $i < $#$p ; $i++ ) {
        my $j = $i + 1;
        $dist += $map->{ $p->[$i] }->{ $p->[$j] };
    }
    say "$dist: ", join( '-', @$p );
}
