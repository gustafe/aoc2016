#!/usr/bin/perl
# Advent of Code 2016 Day 18 - complete solution
# Problem link: http://adventofcode.com/2016/day/18
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d18
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $part2 = shift || 0;
my $testing = 0;
my @input;
my $target = $testing? 10 : 40;
$target =  400_000 if $part2;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my @rows;
my $safe_count = 0;
push @rows, $input[0];

while ( scalar @rows < $target ) {
    my @prev = split(//,$rows[-1]);
    my $new;
    for my $i (0..$#prev ){
	my ( $left, $center, $right ) = map {$prev[$i+$_]} (-1,0,1);
	if ( $i-1 < 0 ) { $left = '.' }
	if ( $i+1 > $#prev ) {$right = '.' }
	# apply rules
	if ( $left eq '^' and $center eq '^' and $right ne '^' ) {
	    $new .= '^'
	} elsif ( $left ne '^' and $center eq '^' and $right eq '^' ) {
	    $new .= '^'
	} elsif ( $left eq '^' and $center ne '^' and $right ne '^' ) {
	    $new .= '^'
	} elsif ( $left ne '^' and $center ne '^' and $right eq '^' ) {
	    $new .= '^'
	} else {
	    $new .= '.';
	}
    }
    push @rows, $new;
}
for my $r ( @rows ) {
    for my $i ( split //, $r) {
	$safe_count +=1 if $i eq '.'
    }
}

say ">>> $safe_count";
