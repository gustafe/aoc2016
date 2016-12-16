#!/usr/bin/perl
# Advent of Code 2016 Day 11 - complete solution
# Problem link: http://adventofcode.com/2016/day/11
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d11
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum all/;
use Algorithm::Combinatorics qw/combinations/;

#### INIT - load input data into array
my $testing = 0;
my $part2 = shift || 0;

# state->[0] = step, $state->[1] = elevator pos
# then a list of hashes with elements
# g = generator, m = microchip
# testing: h=Hydrogen l=Lithium
# t=Thulium p=Plutonium s=Strontium r=Ruthenium o=prOmethium
my $states;
my $target;

if ($testing) {
    $states = [
        {  steps => 0,
           floor => 0,
           state => [{ mh => 1, ml => 1, el => 1 },
		     { gh => 1 },
		     { gl => 1 },
                      {} ] } ];
    $target = 4;

} else {
    $states = [ { steps => 0,
                  floor => 0,
                  state => [ { gt => 1, mt => 1, gp => 1, gs => 1, el => 1 },
                             { mp => 1, ms => 1 },
                             { go => 1, mo => 1, gr => 1, mr => 1 },
                             {} ] } ];
    $target = 10;
    if ($part2) {
        $states->[0]->{state}->[0]->{ge}++;
        $states->[0]->{state}->[0]->{me}++;
        $states->[0]->{state}->[0]->{gd}++;
        $states->[0]->{state}->[0]->{md}++;
        $target += 4;
    }
}


### CODE ########################################
my %seen;

### SUBS ########################################
sub is_ok {
    my ($a) = @_;

    # none or 1 ok
    return 1 if ( !defined($a) );
    return 1 if ( scalar @{$a} <= 1 );

    # all generators ok
    return 1 if ( all { ( split( //, $_ ) )[0] eq 'g' } @$a );

    # all microchips ok
    return 1 if ( all { ( split( //, $_ ) )[0] eq 'm' } @$a );
    my %set;
    my @singles;
    for my $i ( sort @$a ) {
        my @c = split( //, $i );
        push @{ $set{ $c[1] } }, $c[0];
    }

    foreach my $el ( keys %set ) {
        next
            if scalar @{ $set{$el} } == 2;
        push @singles, $set{$el}->[0];
    }
    if (all {
            $_ eq 'g';
        }
        @singles )
    {
        return 1;
    } else {
        return 0;
    }
}

sub dump_state {
    my ($s) = @_;
    say "S: $s->{steps} F: $s->{floor}";
    for my $f ( @{ $s->{state} } ) {
        my $rest = $target - scalar keys %{$f};
        say '[ ', join( ' ', ( sort keys %{$f} ), ( '...' x $rest ) ), ' ]';
    }
    say join( '', '-' x 16 );
}

sub stringify_state {
    my ($state) = @_;
    return
        '<'
        . join( '|', map { join( '', sort keys %{$_} ) } @{$state} ) . '>';
}

########################################

my $count = 0;

LOOP: while (1) {

    my $move = shift @{$states} || die "no more states!";

    my $str = stringify_state( $move->{state} );
    if ( exists $seen{$str} ) {
        next;
    } else {
        $seen{$str}++;
    }

    my $steps      = $move->{steps};
    my $from_floor = $move->{floor};
    my $current    = $move->{state};

    delete $current->[$from_floor]->{el};

    my %from_items = %{ $current->[$from_floor] };

    # get the combinations of stuff to move from the source floor

    my @items = combinations( [ keys %from_items ], 1 );
    if ( scalar keys %from_items >= 2 ) {
        push @items, combinations( [ keys %from_items ], 2 );
    }
    @items = grep { is_ok($_) } @items;
    next unless scalar @items > 0;
    $steps += 1;

    # move up or down, if possible
STATE: for my $to_floor ( $from_floor - 1, $from_floor + 1 ) {

        next if ( $to_floor < 0 or $to_floor > 3 );
        for my $item_list (@items) {

            my $new = [ {}, {}, {}, {} ];

            # unchanged floors are copied over
            my @unchanged
                = grep { $_ != $to_floor and $_ != $from_floor } ( 0 .. 3 );
            map { $new->[$_] = $current->[$_] } @unchanged;

            # remove from origin floor
            my $invalid_flag = 0;
            for my $k ( keys %{ $current->[$from_floor] } ) {
                if ( grep { $k eq $_ } @{$item_list} ) {
                    next;
                } else {
                    $new->[$from_floor]->{$k}++;
                }
            }

            if ( !is_ok( [ keys %{ $new->[$from_floor] } ] ) ) {
                $invalid_flag += 1;
            }

            # add to dest floor
            for my $k ( keys %{ $current->[$to_floor] } ) {
                $new->[$to_floor]->{$k}++;
            }
            for my $j ( @{$item_list} ) {
                $new->[$to_floor]->{$j}++;
            }
            if ( !is_ok( [ keys %{ $new->[$to_floor] } ] ) ) {
                $invalid_flag += 1;
            }

            # check all are valid
            next unless ( $invalid_flag == 0 );

            # check we have reached goal
            if ( scalar keys %{ $new->[3] } == $target ) {
                say "$steps";
                last LOOP;
            }

            # heuristic: don't move down 2 items
            if (     ( $to_floor < $from_floor )
                 and ( scalar keys %{ $new->[$to_floor] } )
                 - ( scalar keys %{ $current->[$to_floor] } ) > 1 )
            {
                next;
            }

            # add elevator, then add to queue
            $new->[$to_floor]->{el}++;
            my $new_state = { steps => $steps,
                              floor => $to_floor,
                              state => $new };

            push @{$states}, $new_state;

        }
    }
    $count++;
}
