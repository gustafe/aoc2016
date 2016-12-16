#!/usr/bin/perl
# Advent of Code 2016 Day 14 - complete solution, alternative implementation
# Problem link: http://adventofcode.com/2016/day/14
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d14
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use Digest::MD5 qw(md5_hex);

#### INIT
my $debug   = 1;
my $testing = 0;
my $salt    = $testing ? 'abc' : 'qzyelonm';

# mine: 'qzyelonm';
# Tenjou: 'yjdafjpo'
# pass an argument for part 2
my $part2 = shift || undef;

### CODE
my $index  = 0;
my @keys   = ();
my %lookup = ();

#### yak-shaving debug output
sub dump_state {
    say "  /// Index: $index";
    say map {
        sprintf( "%3x: %3d", $_, $lookup{$_} ? scalar @{ $lookup{$_} } : 0 )
    } ( 0 .. 7 );
    say map {
        sprintf( "%3x: %3d",
                 $_,
                 $lookup{ sprintf( "%x", $_ ) }
                 ? scalar @{ $lookup{ sprintf( "%x", $_ ) } }
                 : 0 )
    } ( 8 .. 15 );
    say '  Last 3 keys: ... ',
        join( ', ', ( sort { $a <=> $b } @keys )[ -3 .. -1 ] ), ' )';
}

sub dbg_line {
    my ( $str, $c, $hex ) = @_;
    say sprintf( "%5d %6s %s %s", $index, $str, $c, $hex );
}
###############

# code below inspired by this comment
# https://www.reddit.com/r/adventofcode/comments/5iaszm/how_long_does_day_14_take_to_run/db7id7f/

my %keys;
for ( my ( $index, $end ) = ( 0, 1e99 ) ; $index < $end ; $index++ ) {

    my $hex = md5_hex( $salt . $index );
    if ($part2) {
        for ( 1 .. 2016 ) { $hex = md5_hex($hex) }
    }

    # check for quints
    while ( $hex =~ m/(.)(?=\1\1\1\1)/g ) {
        next unless defined $lookup{$1};
        my @list = @{ $lookup{$1} };
        delete $lookup{$1};
        for my $candidate (@list) {
            next if $index - $candidate > 1000;
            $keys{$candidate}++;
            if ( keys %keys == 64 ) {
                $end = $index + 1000;
            }
        }
    }
    # add triples
    if ( $hex =~ m/(.)\1\1/ ) {
        push @{ $lookup{$1} }, $index;
    }
}
say '' . ( sort { $a <=> $b } keys %keys )[ 64 - 1 ];
