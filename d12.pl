#!/usr/bin/perl
# Advent of Code 2016 Day 12 - complete solution
# Problem link: http://adventofcode.com/2016/day/12
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d12
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my $part    = 2;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my %reg = map { $_ => 0 } qw(a b c d);
$reg{c} = 1 unless $part == 1;

my @instr;
while (@input) {
    my ( $cmd, $arg1, $arg2 );
    my $line = shift @input;
    if ( $line =~ m/^(inc|dec) (.)$/ ) { push @instr, [ $1, $2, undef ] }
    elsif ( $line =~ /^cpy (\S+) (\S+)$/ ) { push @instr, [ 'cpy', $1, $2 ] }
    elsif ( $line =~ /^jnz (\S+) (-?\d+)$/ ) {
        push @instr, [ 'jnz', $1, $2 ];
    } else {
        die "cannot parse $line";
    }
}

my $pos = 0;
while ( $pos >= 0 and $pos <= $#instr ) {
    my ( $cmd, $a1, $a2 ) = @{ $instr[$pos] };
    if ( $cmd eq 'inc' ) {
        $reg{$a1} += 1;
        $pos++;
    } elsif ( $cmd eq 'dec' ) {
        $reg{$a1} -= 1;
        $pos++;
    } elsif ( $cmd eq 'cpy' ) {
        # can either copy integer or content of other register
        if   ( $a1 =~ /\d+/ ) { $reg{$a2} = $a1 }
        else                  { $reg{$a2} = $reg{$a1} }
        $pos++;
    } elsif ( $cmd eq 'jnz' ) {
        # value to compare can be integer (one case) or content of register
        if ( $a1 =~ /\d+/ ) { $pos = $pos + $a2 }
        elsif ( $a1 =~ /[a-d]/ ) {
            if ( $reg{$a1} != 0 ) { $pos = $pos + $a2 }
            else                  { $pos++ }
	}
    }
}
say $reg{a};
