#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;

my %rules;
# reverted rules for part B
my %rrules;
my $start;
my %output;
my $cycles = 1;

while (<STDIN>) {
  chomp;
  next unless $_;
  if (/(\w+) => (\w+)/) {
    push @{$rules{$1}}, $2;
    $rrules{$2} = $1;
  }
  else {
    $start = $_;
  }
}

# part A
# tokenize the string based on rules
my @start;
my $token;
for my $c (split //, $start) {
  if ($rules{$c} and !$token) {
    push @start, $c;    
  }
  elsif ($token and $rules{"${token}$c"}) {
    push @start, "${token}$c";
    $token = '';
  }
  else {
    # adding back - we need to avoid false duplicities 
    push @start, $token if $token;
    $token = $c;
  }
}

# iterate through tokens
for my $i (0 .. $#start) {
  next unless defined $rules{$start[$i]};
  my @r = @{$rules{$start[$i]}};
  for my $r (@r) {
    my $new = $r;
    my $old = $start[$i];
    $start[$i] = $new;
    my $key = join('', @start);
    $output{$key} += 1;
    $start[$i] = $old;
  }
}

print "Distinct combinations: ".scalar(keys(%output))."\n";

# part B
# try to reduce the molecule from the longest to shortest. If this is commited it worked for me :)
my @tokens = sort { length $a cmp length $b } keys %rrules;
my $steps = 0;
while ($start ne 'e') {
  for my $t (@tokens) {
    if ($start =~ m/$t/) {
      $start =~ s/$t/$rrules{$t}/;
      $steps++;
      print "Reduction: $start\n";
    }
  }
}
print "Steps to create: $steps\n";
