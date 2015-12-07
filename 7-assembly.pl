#!/bin/perl

my $wires = {};
my @todo = ();

$counter = 0;

sub parse_instruction {
  my ($code) = @_;
  print "$code\n";
  if ($code =~ /^([a-z]+) (AND|OR) ([a-z]+) -> ([a-z]+)/) {
    push @todo, $code and return if (not(defined $wires->{$1} and defined $wires->{$3}));
    if ($2 eq 'AND') {
      $wires->{$4} = $wires->{$1} & $wires->{$3};
    }
    else {
      $wires->{$4} = $wires->{$1} | $wires->{$3};
    }
  }
  elsif ($code =~ /^([0-9]+) (AND|OR) ([a-z]+) -> ([a-z]+)/) {
    push @todo, $code and return if (not defined $wires->{$3});
    if ($2 eq 'AND') {
      $wires->{$4} = $1 & $wires->{$3};
    }
    else {
      $wires->{$4} = $1 | $wires->{$3};
    }
  }
  elsif ($code =~ /^([a-z]+) (LSHIFT|RSHIFT) ([0-9]+) -> ([a-z]+)/) {
#    print "$code\n";
    push @todo, $code and return if (not defined $wires->{$1});
    if ($2 eq 'LSHIFT') {
      $wires->{$4} = $wires->{$1} << $3;
      $wires->{$4} = $wires->{$4} & 0xFFFF;
    }
    else {
      $wires->{$4} = $wires->{$1} >> $3;
      $wires->{$4} = $wires->{$4} & 0xFFFF;
    }
  }
  elsif ($code =~ /^([a-z]+) -> ([a-z]+)/) {
    push @todo, $code and return if (not defined $wires->{$1});
    $wires->{$2} = $wires->{$1};
  }
  elsif ($code =~ /^NOT ([a-z]+) -> ([a-z]+)/) {
    push @todo, $code and return if (not defined $wires->{$1});
    $wires->{$2} = ~$wires->{$1};
    $wires->{$2} = $wires->{$2} & 0xFFFF;
  }
  elsif ($code =~ /END/) {
    $counter += 1;
    push @todo, 'END';
    print "Next iteration ($counter)\n";
  }
  else {
    print "Not matched: '$code'\n" if $code;
  }
}

while (<STDIN>) {
  chomp;
  if (/^([0-9]+) -> ([a-z]+)/) {
    $wires->{$2} = $1;
    $wires->{$2} = $wires->{$2} & 0xFFFF;
  }
  elsif (/^([0-9]+) -> ALL/) {
    # HACK for 7 part 2
    for (keys %$wires) {
      $wires->{$_} = 0 unless /b/;
    }
  }
  else {
    push @todo, $_
  }
}
push @todo, 'END';
print "All loaded, reiterating\n";

while (@todo and $counter < 1000) {
  my $code = shift @todo;
  parse_instruction($code);
}

for (keys %$wires) {
  print "Wire $_: $wires->{$_}\n";
}

print "Wire a: $wires->{a}\n";
