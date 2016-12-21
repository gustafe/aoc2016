#!/usr/bin/perl
# Advent of Code 2016 Day 21 - part 2
# Problem link: http://adventofcode.com/2016/day/21
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d21
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use Algorithm::Combinatorics qw(permutations);

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### SUBS
sub rotate_right {
    my ( $ary, $offset, $no_of_rotations ) = @_;
    my @a = @{$ary};
    my @t = @a;
    for my $idx ( 0 .. $#t ) {
        $t[ ( $idx + $offset * $no_of_rotations ) % scalar @t ] = $a[$idx];
    }
    return \@t;
}

sub rotate_left {
    my ( $ary, $offset, $no_of_rotations ) = @_;
    my @a = @{$ary};
    my @t = @a;
    for my $idx ( 0 .. $#t ) {
        $t[ ( $idx - $offset * $no_of_rotations ) % scalar @t ] = $a[$idx];
    }
    return \@t;
}

sub move_pos {
    my ( $ary, $from, $to ) = @_;
    my @a = @{$ary};
    my $el = splice @a, $from, 1;
    splice @a, $to, 0, ($el);
    return \@a;
}

### CODE
my $target = 'fbgdceah';
my @start  = sort split( //, $target );
my $iter   = permutations( \@start );
my $found  = 0;
my $count  = 0;
while ( my $c = $iter->next and !$found ) {
    my @code = @{$c};
    for my $line (@input) {
        if ( $line =~ m/^move position (\d+) to position (\d+)$/ ) {
            my $t = move_pos( \@code, $1, $2 );
            @code = @{$t};
        } elsif ( $line =~ m/^reverse positions (\d+) through (\d+)$/ ) {
            my @tmp = @code[ $1 .. $2 ];
            @tmp = reverse @tmp;
            my $count = 0;
            while (@tmp) {
                $code[ $1 + $count ] = shift @tmp;
                $count++;
            }
        } elsif ( $line =~ m/^rotate based on position of letter (.)$/ ) {

            # find the position of the letter
            # http://www.perlmonks.org/?node_id=75660
            my ($idx) = grep { $code[$_] eq $1 } 0 .. $#code;
            my $no_of_rotations = 1 + $idx;

            if ( $idx >= 4 ) { $no_of_rotations++ }
            my $t = rotate_right( \@code, 1, $no_of_rotations );
            @code = @{$t};
        } elsif ( $line =~ m/^rotate (left|right) (\d+) steps?$/ ) {
            my $t;
            if ( $1 eq 'left' ) {
                $t = rotate_left( \@code, $2, 1 );
                @code = @{$t};
            } elsif ( $1 eq 'right' ) {
                $t = rotate_right( \@code, $2, 1 );
                @code = @{$t};
            }
        } elsif ( $line =~ m/^swap letter (.) with letter (.)$/ ) {
            my ($idx1) = grep { $code[$_] eq $1 } 0 .. $#code;
            my ($idx2) = grep { $code[$_] eq $2 } 0 .. $#code;
            my @tmp    = @code;
            $tmp[$idx1] = $code[$idx2];
            $tmp[$idx2] = $code[$idx1];
            @code       = @tmp;
        } elsif ( $line =~ m/^swap position (\d+) with position (\d+)$/ ) {
            my @tmp = @code;
            $tmp[$1] = $code[$2];
            $tmp[$2] = $code[$1];
            @code    = @tmp;
        } else {
            die "can't parse line: $line";
        }
    }
    if ( join( '', @code ) eq $target ) {
        say '>> ', join( '', @{$c} );
        $found = 1;
    }
    $count++;
    if ( $count % 1000 == 0 ) {
        say $count, ' ', join( '', @{$c} );
    }
}
