#!/usr/bin/perl
# Advent of Code 2016 Day 5 - part 1
# Problem link: http://adventofcode.com/2016/day/5
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d05
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
# this module is available from CPAN
use Digest::MD5 qw(md5_hex);

#### INIT
my $testing = 0;
my $input = $testing ? 'abc' : 'abbhdwsy';

### CODE
my $password = '';
my $i        = 0;

while ( length($password) < 8 ) {
    my $hash = md5_hex( $input . $i );
    if ( $hash =~ m/^00000/ ) {
        say "$i $hash" if $testing;
        $password .= ( split( //, $hash ) )[5];
    }
    $i++;
}
say $password;
