#!/bin/perl

use strict;
use warnings;

my @program;
my $ip = 0;
# part B starts with reg_a as 1
my ($reg_a, $reg_b) = (1,0);

while (<STDIN>) {
  chomp;
  next unless $_;
  my ($ins, $par1, $par2);
  /(hlf|tpl|inc) (\w)/;
  if ($1) {
    push @program, {$1 => [$2]};
    next;
  }
  /(jmp) ([+-]\d+)/;
  if ($1) {
    push @program, {$1 => [$2]};
    next;
  }
  /(jie|jio) (\w), ([+-]\d+)/;
  if ($1) {
    push @program, {$1 => [$2, $3]};
    next;
  }
}
while ($program[$ip]) {
  my ($ins) = keys %{$program[$ip]};
  my ($par) = values %{$program[$ip]};
  my @par = @$par;
  print "ins: $ins\n";
  if ($ins eq 'hlf') {
    eval "\$reg_$par[0] /= 2;";
  }
  elsif ($ins eq 'tpl') {
    eval "\$reg_$par[0] *= 3;";
  }
  elsif ($ins eq 'inc') {
    eval "\$reg_$par[0] += 1;";
  }
  elsif ($ins eq 'jmp') {
    $ip += $par[0];
    next;
  }
  elsif ($ins eq 'jie') {
    if (!eval "\$reg_$par[0] % 2") {
      $ip += $par[1];
      next;
    }
  }
  elsif ($ins eq 'jio') {
    if (eval "\$reg_$par[0] == 1") {
      $ip += $par[1];
      next;
    }
  }
#  print "a: $reg_a, b: $reg_b, ip: $ip\n";
  $ip++;
}

print "Reg B is $reg_b\n";
