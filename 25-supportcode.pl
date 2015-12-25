#!/bin/perl

use strict;
use warnings;
use bigint;

my $row = 2981;
my $col = 3075;

# count number of iterations based on table coordinates, starts from 0
my $numbers = ($row + $col - 2) * ($row + $col - 1) / 2 + $col - 1;

my $n = 20151125;
for my $i (1 .. $numbers) {
  $n = ( $n * 252533 ) % 33554393;
}

print "Code is $n\n";
