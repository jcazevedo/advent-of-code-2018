use strict;
use warnings;

my $file = "23.input";
open (my $lines, $file);

my @xx;
my @yy;
my @zz;
my @rr;

sub dist {
    my ($i1, $i2) = @_;
    return abs($xx[$i1] - $xx[$i2]) + abs($yy[$i1] - $yy[$i2]) + abs($zz[$i1] - $zz[$i2]);
}

while (my $line = <$lines>) {
    my ($x, $y, $z, $r) = $line =~ m/^pos=<([^,]+),([^,]+),([^,]+)>, r=(.*)$/g;
    push @xx, $x;
    push @yy, $y;
    push @zz, $z;
    push @rr, $r;
}

my $strongest = 0;
for my $i (1..$#rr) {
    if ($rr[$i] > $rr[$strongest]) {
        $strongest = $i;
    }
}

my $in_range = 0;

for my $i (0..$#rr) {
    if (dist($i, $strongest) <= $rr[$strongest]) {
        $in_range++;
    }
}

print "Part 1: ", $in_range, "\n";
