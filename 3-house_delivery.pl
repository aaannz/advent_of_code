#!/bin/perl -w

my $grid = {};
my $ins;
# arbitrary start
my ($posx, $posy) = (0,0);
# starting location is visited
$grid->{$posx}{$posy} = 1;

# robot stanta
my ($posRx, $posRy) = (0,0);

my $turn = 's'; # s for santa, r for robot
while(read(STDIN, $ins, 1)) {
  my ($deltaX, $deltaY) = (0,0);
  if ($ins eq '>') {
    $deltaX = 1;
  }
  elsif ($ins eq '<') {
    $deltaX = -1;
  }
  elsif ($ins eq '^') {
    $deltaY = 1;
  }
  elsif ($ins eq 'v') {
    $deltaY = -1;
  }
  if ($turn eq 's') {
    $posx += $deltaX;
    $posy += $deltaY;
    $grid->{$posx}{$posy} = 1;
    $turn = 'r';
  }
  elsif ($turn eq 'r') {
    $posRx += $deltaX;
    $posRy += $deltaY;
    $grid->{$posRx}{$posRy} = 1;
    $turn = 's';
  }
}

my $visited = 0;
for my $x (keys %$grid) {
  for my $y (keys %{$grid->{$x}}) {
    $visited += 1;
  }
}
print "Houses visited: $visited\n";
