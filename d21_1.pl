#!/usr/bin/perl
# Advent of Code 2016 Day 21 - part 1
# Problem link: http://adventofcode.com/2016/day/21
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d21
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

my $starting = $testing ? 'abcde' : 'abcdefgh';
my @code = split( //, $starting );
my $debug = 0;

for my $line (@input) {
    if ( $line =~ m/^move position (\d+) to position (\d+)$/ ) {
        printf( "%36s: %s -> ", $line, join( '', @code ) ) if $debug;
        my $t = move_pos( \@code, $1, $2 );
        @code = @{$t};
        say @code if $debug;
    } elsif ( $line =~ m/^reverse positions (\d+) through (\d+)$/ ) {
        printf( "%36s: %s -> ", $line, join( '', @code ) ) if $debug;
	@code[$1..$2] = reverse @code[$1..$2];
        say @code if $debug;
    } elsif ( $line =~ m/^rotate based on position of letter (.)$/ ) {
        printf( "%36s: %s -> ", $line, join( '', @code ) ) if $debug;

        # find the position of the letter
        # http://www.perlmonks.org/?node_id=75660
        my ($idx) = grep { $code[$_] eq $1 } 0 .. $#code;
        my $no_of_rotations = 1 + $idx;

        if ( $idx >= 4 ) { $no_of_rotations++ }
        my $t = rotate_right( \@code, 1, $no_of_rotations );
        @code = @{$t};
        say @code if $debug;
    } elsif ( $line =~ m/^rotate (left|right) (\d+) steps?$/ ) {
        printf( "%36s: %s -> ", $line, join( '', @code ) ) if $debug;
        my $t;
        if ( $1 eq 'left' ) {
            $t = rotate_left( \@code, $2, 1 );
            @code = @{$t};
        } elsif ( $1 eq 'right' ) {
            $t = rotate_right( \@code, $2, 1 );
            @code = @{$t};
        }
        say @code if $debug;
    } elsif ( $line =~ m/^swap letter (.) with letter (.)$/ ) {
        printf( "%36s: %s -> ", $line, join( '', @code ) ) if $debug;
        my ($idx1) = grep { $code[$_] eq $1 } 0 .. $#code;
        my ($idx2) = grep { $code[$_] eq $2 } 0 .. $#code;
        my @tmp    = @code;
        $tmp[$idx1] = $code[$idx2];
        $tmp[$idx2] = $code[$idx1];
        @code       = @tmp;
        say @code if $debug;
    } elsif ( $line =~ m/^swap position (\d+) with position (\d+)$/ ) {
        printf( "%36s: %s -> ", $line, join( '', @code ) ) if $debug;
	@code[$2,$1] = @code[$1,$2];
        say @code if $debug;
    } else {
        die "can't parse line: $line";
    }
}
say join( '', @code );
