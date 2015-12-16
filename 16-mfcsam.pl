#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;

my @passed = ();
my $sue = 0;
while (<STDIN>) {
  chomp;
  next unless $_;
  # next aunts that doesn't pass
  $sue += 1;
  next if /children: [^3]/;
  # next if /cats: [^7]/;
  next if /cats: [^89]/;
  next if /samoyeds: [^2]/;
  # next if /pomeranians: [^3]/;
  next if /pomeranians: [^012]/;
  next if /akitas: [^0]/;
  next if /vizslas: [^0]/;
  # next if /goldfish: [^5]/;
  next if /goldfish: [^0-4]/;
  # next if /trees: [^3]/;
  next if /trees: [^4-9]/;
  next if /cars: [^2]/;
  next if /perfumes: [^1]/;
  push @passed, $sue;
}

pp @passed;
