#!/bin/perl

use strict;
use warnings;
use Algorithm::Combinatorics qw/combinations/;
use Data::Dump qw/pp/;

my @items;

sub group_weight {
  my @group = @_;
  my $weight = 0;
  $weight += $_ for @group;
  return $weight;
}

sub group_qe {
  my @group = @_;
  my $qe = 1;
  $qe *= $_ for @group;
  return $qe;
}

while (<STDIN>) {
  chomp;
  next unless $_;
  push @items, $_;
}

my $weight = group_weight(@items);
# for part B divide by 4, before it was 3
my $target = $weight / 4;
my $minqe = 999999;
my $minsize = 999999;

# find smallest combination of @items to get $target weight
for my $i (1 .. scalar @items) {
  my $cg = combinations(\@items, $i);
  while (my $c = $cg->next) {
    next if group_weight(@$c) != $target;
    if ( scalar @$c < $minsize) {
      $minsize = scalar @$c;
      $minqe = group_qe(@$c);
      print "new minsize: $minsize, qe: $minqe\n";pp($c);
    }
    elsif ( scalar @$c == $minsize and $minqe > group_qe(@$c)) {
      $minqe = group_qe(@$c);pp($c);
      print "new qe: $minqe\n";
    }
  }
  last if $minsize < 999999;
}

print "Minimal QE: $minqe\n";
