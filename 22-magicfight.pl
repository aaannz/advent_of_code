#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;
use Clone qw/clone/;

my %spells = (
  'MagicMissile' => { cost => 53, damage => 4 },
  'Drain' => { cost => 73, damage => 2, heal => 2},
  'Shield' => { cost => 113, lasts => 6, armor => 7},
  'Poison' => { cost => 173, damage => 3, lasts => 6 },
  'Recharge' => { cost => 229, mana => 101, lasts => 5 },
);

my %boss = ( hp => 58, dmg => 9 );
my %player = ( hp => 50, mana => 500, armor => 0 );

my $minuse = 999999;
my @winactions = ();

sub eval_action {
  my ($action, $state) = @_;
  # do feasability checks as first
  if ($action) {
    return if ($state->{player}{mana} < $spells{$action}{cost}); # can't cast spell we don't have mana for
    return if ($state->{$action} and $state->{$action} > 1); # can't recast already active spell which does not end in this turn
  }
  my $newstate = clone($state);

  # eval active spells
  for my $spell (qw/Poison Recharge/) {
    if ($newstate->{$spell} and $newstate->{$spell} > 0) {
      $newstate->{$spell}--;
      $newstate->{boss}{hp} -= $spells{$spell}{damage} || 0;
      $newstate->{player}{hp} += $spells{$spell}{heal} || 0;
      $newstate->{player}{mana} += $spells{$spell}{mana} || 0;
    }
  }
  if ($newstate->{Shield}) {
    # treat shield separately
    $newstate->{Shield}--;
    $newstate->{player}{armor} = $spells{Shield}{armor};
  }
  else {
    $newstate->{player}{armor} = 0;
  }

  # return when evaling boss turn - no action
  return $newstate unless $action;

  # cast spell
  $newstate->{$action} = $spells{$action}{lasts};
  $newstate->{player}{mana} -= $spells{$action}{cost};
  $newstate->{mana_used} += $spells{$action}{cost};

  # do casted actions if applicable
  if (grep /$action/, (qw/MagicMissile Drain/)) {
      $newstate->{boss}{hp} -= $spells{$action}{damage} || 0;
      $newstate->{player}{hp} += $spells{$action}{heal} || 0;
      $newstate->{player}{mana} += $spells{$action}{mana} || 0;
  }

  return $newstate;
}

sub fight {
  my ($turn, $state, $actions) = @_;

  if ($state->{player}{hp} <= 0) {
    return;
  }
  if ($state->{boss}{hp} <= 0) 
  {
    if ($state->{mana_used} < $minuse) {
      $minuse = $state->{mana_used};
      @winactions = @$actions;
      print "min mana: $minuse, turn $turn\n";pp($actions);pp($state);
    }
    return;
  }
  if (not $turn % 2) {
    # boss turn
    my $newstate = eval_action(undef, $state);
    my $dmg = ($boss{dmg} - $newstate->{player}{armor}) || 1;
    $newstate->{player}{hp} -= $dmg;
    fight($turn + 1, $newstate, [@$actions, "boss-$turn"]);
  }
  else {
    # player turn

    # part B, lose 1 HP each turn
    $state = clone($state);
    $state->{player}{hp}--;

    for my $action (keys %spells) {
      my $newstate = eval_action($action, $state);
      next unless $newstate;
      fight($turn + 1, $newstate, [@$actions, $action]);
    }
  }
}

fight(1, {boss => \%boss, player => \%player}, []);

print "Minimum used to win: $minuse\n";pp @winactions;
