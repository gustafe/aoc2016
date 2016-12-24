#!/usr/bin/perl
# Advent of Code 2016 Day 23 - complete solution
# Problem link: http://adventofcode.com/2016/day/23
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d23
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
my $debug = 0;
my %reg = map { $_ => 0 } qw(a b c d);
$reg{a} = $part == 2 ? 12 : 7;

my @instr;
while (@input) {
    my ( $cmd, $arg1, $arg2 );
    my $line = shift @input;
    if ( $line =~ m/^(inc|dec) (.)$/ ) { push @instr, [ $1, $2, undef ] }
    elsif ( $line =~ /^cpy (\S+) (\S+)$/ ) { push @instr, [ 'cpy', $1, $2 ] }
    elsif ( $line =~ /^jnz (\S+) (-?\d+)$/ ) {
        push @instr, [ 'jnz', $1, $2 ];
    } elsif ( $line =~ /^jnz (\d+) (\S+)$/ ) {
        push @instr, [ 'jnz', $1, $2 ];
    } elsif ( $line =~ /^tgl (\S+)$/ ) {
        push @instr, [ 'tgl', $1, undef ];
    } else {
        die "cannot parse $line";
    }
}
my %freq;

sub dump_state {
    my ( $count, $pos, $cmd, $a1, $a2 ) = @_;
    printf( "%d cmd=[%s %s %s] => reg:[%d %d %d %d] next=%d\n",
            $count, $cmd, $a1,
            $a2 ? $a2 : '_',
            ( map { $reg{$_} } qw/a b c d/ ), $pos );
    $freq{$pos}++;
}

my $pos   = 0;
my $count = 0;
while ( $pos >= 0 and $pos <= $#instr ) {
    my ( $cmd, $a1, $a2 ) = @{ $instr[$pos] };
    $count++;
    warn "==> $count" if ( $debug and $count % 10_000 == 0 );
    if ( $cmd eq 'inc' ) {
        $reg{$a1} += 1;
        $pos++;
        dump_state( $count, $pos, $cmd, $a1, $a2 ) if $debug;
    } elsif ( $cmd eq 'dec' ) {
        $reg{$a1} -= 1;
        $pos++;
        dump_state( $count, $pos, $cmd, $a1, $a2 ) if $debug;
    } elsif ( $cmd eq 'cpy' ) {

        # can either copy integer or content of other register
        if   ( $a1 =~ /\d+/ ) { $reg{$a2} = $a1 }
        else                  { $reg{$a2} = $reg{$a1} }
        $pos++;
        dump_state( $count, $pos, $cmd, $a1, $a2 ) if $debug;
    } elsif ( $cmd eq 'jnz' ) {
        my $compare;
        if   ( $a1 =~ /\d+/ ) { $compare = $a1 }
        else                  { $compare = $reg{$a1} }
        my $jump;
        if   ( $a2 =~ /\d+/ ) { $jump = $a2 }
        else                  { $jump = $reg{$a2} }

        if ( $compare != 0 ) {
            $pos = $pos + $jump;
        } else {
            $pos++;
        }
        dump_state( $count, $pos, $cmd, $a1, $a2 ) if $debug;
    } elsif ( $cmd eq 'tgl' ) {
        my $newpos;
        if ( $a1 =~ /\d+/ ) { $newpos = $pos + $a1 }
        elsif ( $a1 =~ /[a-d]/ ) {
            $newpos = $pos + $reg{$a1};
        }
        if ( $newpos < 0 or $newpos > $#instr ) {

            # NOP
        } elsif ( $newpos == $pos ) {
            $pos++;
        } else {

            # do the toggle!
            if ( !defined( $instr[$newpos]->[2] ) ) {
                if ( $instr[$newpos]->[0] eq 'inc' ) {
                    $instr[$newpos]->[0] = 'dec';
                } else {
                    $instr[$newpos]->[0] = 'inc';
                }
            } elsif ( defined( $instr[$newpos]->[2] ) ) {
                if ( $instr[$newpos]->[0] eq 'jnz' ) {
                    $instr[$newpos]->[0] = 'cpy';
                } else {
                    $instr[$newpos]->[0] = 'jnz';
                }
            }
        }
        $pos++;
        dump_state( $count, $pos, $cmd, $a1, $a2 ) if $debug;
    }
}
say $reg{a};
if ($debug) {
    for my $p ( sort { $a <=> $b } keys %freq ) {
        say "$p: $freq{$p}";
    }
}
