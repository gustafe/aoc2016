#!/usr/bin/perl
# Advent of Code 2016 Day 25 - complete solution
# Problem link: http://adventofcode.com/2016/day/25
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2016.html#d25
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

### CODE
my $debug = 0;
my %reg = map { $_ => 0 } qw(a b c d);

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
    } elsif ( $line =~ /^out (\S+)$/ ) {
        push @instr, [ 'out', $1, undef ];
    } else {
        die "cannot parse $line";
    }
}

my $in = 0;
LOOP: {
    for $in ( 0 .. 1000 ) {
        $reg{a} = $in;
        my $pos    = 0;
        my $count  = 0;
        my @output = ();
        warn "==> $in" if ( $debug and $in % 100 == 0 );
        while ( $pos >= 0 and $pos <= $#instr and scalar @output < 20 ) {
            my ( $cmd, $a1, $a2 ) = @{ $instr[$pos] };
            $count++;
            warn "==> $count" if ( $debug and $count % 10_000 == 0 );
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
            } elsif ( $cmd eq 'out' ) {
                push @output, $reg{$a1};
                $pos++;
            }
        }

        if (    join( '', @output[ 0 .. 7 ] ) eq '01010101'
             or join( '', @output[ 1 .. 8 ] ) eq '01010101' )
        {
            say "$in: ", join( ' ', @output );
            last LOOP;
        }
    }
}

