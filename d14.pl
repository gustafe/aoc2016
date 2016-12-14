#!/usr/bin/perl
# Advent of Code 2016 - complete solution
# Problem link: http://adventofcode.com/2016/day/14
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d14
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use Digest::MD5 qw(md5_hex);

#### INIT
my $debug   = 0;
my $testing = 0;
my $salt    = $testing ? 'abc' : 'qzyelonm';

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
    my ($str, $c, $hex) = @_;
    say sprintf("%5d %6s %s %s", $index, $str, $c, $hex);
}
###############

while ( scalar @keys <= 70 ) {
    my $hex = md5_hex( $salt . $index );
    if ($part2) {
        for ( 1 .. 2016 ) { $hex = md5_hex($hex) }
    }

    # check for triples
    if ( $hex =~ m/(.)\1{2}/ ) {
	dbg_line('triple', $1, $hex) if $debug;
        push @{ $lookup{$1} }, $index;
    }

    # check for quints
    if ( $hex =~ m/(.)\1{4}/ ) {
	dbg_line('quint', $1, $hex) if $debug;
        if ( exists $lookup{$1} ) {

            # get the lists of indexes found for this hex char
            while ( @{ $lookup{$1} } ) {
                my $el = shift @{ $lookup{$1} };
                if ( $index == $el ) {
                    say "  **> skip $el for now, check later" if $debug;
                    next;
                } elsif ( $index - $el < 1000 ) {
                    say "  ==> add $el to keys" if $debug;
                    push @keys, $el;
                } else {
                    say "  --> $el too old, discard" if $debug;
                }
            }
        }
	# finally add the quint to the lookup
        push @{ $lookup{$1} }, $index;
    }
    $index++;
    if ( $debug and $index % 1_000 == 0 ) { dump_state }
}
@keys = sort { $a <=> $b } @keys;
say '==>', $keys[63];
