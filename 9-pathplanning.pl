#!/bin/perl -w

use strict;
use Data::Dump qw/pp/;
my $graph;
my $min_price = 999999;
my $max_price = 0;

sub generate_paths {
  my ($price, $origin, @to_visit) = @_;
  print "computing route from $origin, price so far is $price\n";
  $DB::single=1;
  my $paths;
  if (scalar @to_visit > 1) {
    for my $next (@to_visit) {
      # remove $next from @to_visit
      my @next_visits = grep !/$next/, @to_visit;
      $paths->{$next} = generate_paths($price + $graph->{$origin}{$next}, $next, @next_visits);
    }
    return $paths;
  }
  else {
    my $final_price = $price + $graph->{$origin}{$to_visit[0]};
    print "arrived to $to_visit[0], for the price $final_price\n";
    $min_price = $final_price if ($final_price < $min_price);
    $max_price = $final_price if ($final_price > $max_price);
    return {$to_visit[0] => $final_price};
  }
}

while (<STDIN>) {
  chomp;
  my ($start, $stop, $price) = $_ =~ /^(\w+) to (\w+) = (\d+)$/;
  next unless $start;
  $graph->{$start}{$stop} = $price;
  $graph->{$stop}{$start} = $price;
}

# generate all possible routes - that's 7^7 options (fortunatelly, for provided input) and compute lengths

# generate paths and its price
my $paths;
for my $next (keys %$graph) {
  my @to_visit = grep !/$next/, keys(%$graph);
  $paths->{$next} = generate_paths(0, $next, @to_visit);
}

#pp ($paths);
print "Min price: $min_price and max price: $max_price\n";
