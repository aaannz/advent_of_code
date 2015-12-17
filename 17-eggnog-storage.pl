#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;

my $liters = 150;
my @bottles = ();

while (<STDIN>) {
  chomp;
  next unless $_;
  push @bottles, $_;
}

my $minbottles = 999;
my $combs_with_min = 0;

sub add_bottle {
  my ($capacity, $storage, @remaining) = @_;
  my $combs = 0;
  for  my $i (0 .. $#remaining) {
    my $r = sub { \@_ }->(@remaining);
    my $newcap = $capacity + $remaining[$i];
    my @new_storage = (@$storage, $remaining[$i]);
    if ($newcap > $liters) {
      next;
    }
    elsif ($newcap == $liters) {
      print 'match: '.pp(@new_storage) ."\n";
      $combs += 1;
      #part_b
      my $len = scalar @new_storage;
      if ($len < $minbottles) {
        $combs_with_min = 1;
        $minbottles = $len;
      }
      elsif ($len == $minbottles) {
        $combs_with_min += 1;
      }
    }
    else {
      splice @$r, 0, $i + 1;
      $combs += add_bottle($newcap, \@new_storage, @$r);
    }
  }
  return $combs;
}

my $combinations = add_bottle(0, [], @bottles);

print "Total combinations: $combinations\n";
print "Minimum bottles: $minbottles in $combs_with_min combinations\n";
