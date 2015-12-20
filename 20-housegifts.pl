#!/bin/perl

use strict;
use warnings;
use Math::Prime::Util qw/divisor_sum divisors/;

my $input = readline;
chomp $input;
# from partA :divide both sides by 10 so I could use plain divisor_sum
# $input = $input / 10;

for my $i (1 .. $input) {
  # in part A just used simple sum
  #my $gifts = divisor_sum($i);
  # for part B get dividers, if divider is more than 50 times -> disregard
  my $gifts;
  for my $d (divisors($i)) {
    next if ($i / $d > 50);
    $gifts += 11*$d;
  }
  if ($gifts > $input) {
    print "First is $i\n";
    last;
  }
}
