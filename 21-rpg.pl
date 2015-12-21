#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;

my %shop;
my %player = ( hp => 100, dmg => 0, arm => 0 );
my %boss = ( hp => 103, dmg => 9, arm => 2 );
my @weapons;
my @rings = ('none', 'none');
my @armors = ('none');
my $state;
# load up the shop
while (<STDIN>) {
  chomp;
  next unless $_;
  if (/(\w+)\s+(\d+)\s+(\d+)\s+(\d+)/) {
    my $item = $1;
    $shop{$item} = {cost => $2, dmg => $3, arm => $4};
    if ($state =~ /We/) {
      push @weapons, $item;
    }
    elsif ($state =~ /Ar/) {
      push @armors, $item;
    }
    elsif ($state =~ /Ri/) { 
      push @rings, $item;
    }
  }
  elsif (/(Weapons|Armor|Rings):/) {
    $state = $1;
  }
}
$shop{'none'} = {cost => 0, dmg => 0, arm => 0};

sub fight {
  my $print = shift;
  my @inv = @_;
  my ($atk, $arm) = (0,0);
  $atk += $shop{$_}{dmg} for @inv;
  $arm += $shop{$_}{arm} for @inv;
  my $dmg = ($atk - $boss{arm}) || 1;
  my $res = ($boss{dmg} - $arm) || 1;
  my $step = 1;
  my ($php, $bhp) = ($player{hp}, $boss{hp});
  while (1) {
    if (!($step % 2)) {
      $php -= $res;
    }
    else {
      $bhp -= $dmg;
    }
    print "Step $step, player: ".$php.", boss: ".$bhp."\n" if $print;
    # part A
    #return 1 if ($bhp <= 0);
    #return if ($php <= 0);
    # part B
    return if ($bhp <= 0);
    return 1 if ($php <= 0);
    $step++
  }
}

sub checkout {
  my @inv = @_;
  my $cost = 0;  
  $cost += $shop{$_}{cost} for @inv;
  return $cost;
}

# part A
#my $mincost = 999;
# part B
my $maxcost = 0;
my @wininv;

for my $w (@weapons) {
  for my $a (@armors) {
    for my $r (@rings) {
      my @rings2 = grep !/$r/, @rings;
      for my $r2 (@rings2) {
        if (fight(0, $w, $a, $r, $r2)) {
          my $cost = checkout($w, $a, $r, $r2);
           # part A
#          if ($cost and $cost < $mincost) {
#             $mincost = $cost;
           # part B
           if ($cost > $maxcost) {
             $maxcost = $cost;
             @wininv = ($w, $a, $r, $r2);
          }
        }
      }
    }
  }
}

pp @wininv;
# part A
#print "Minimal cost to defeat is $mincost\n";
# part B
print "Maximal cost to lose is $maxcost\n";

fight(1, @wininv);
