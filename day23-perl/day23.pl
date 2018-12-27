use POSIX;
use strict;
use warnings;

my $file = "23.input";
open (my $lines, $file);

my @xx;
my @yy;
my @zz;
my @rr;

sub man_dist {
    my ($x1, $y1, $z1, $x2, $y2, $z2) = @_;
    return abs($x1 - $x2) + abs($y1 - $y2)+ abs($z1 - $z2);
}

sub dist {
    my ($i1, $i2) = @_;
    return man_dist($xx[$i1], $yy[$i1], $zz[$i1], $xx[$i2], $yy[$i2], $zz[$i2]);
}

sub pq_parent {
    my ($i) = @_;
    return floor(($i - 1) / 2);
}

sub pq_left {
    my ($i) = @_;
    return 2 * $i + 1;
}

sub pq_right {
    my ($i) = @_;
    return 2 * $i + 2;
}

sub pq_compare {
    my ($v1, $v2) = @_;
    my $b1 = $v1->[0];
    my $b2 = $v2->[0];
    if ($b1 > $b2) {
        return 1;
    }
    if ($b2 > $b1) {
        return 0;
    }
    my $x1 = $v1->[1];
    my $y1 = $v1->[2];
    my $z1 = $v1->[3];
    my $x2 = $v2->[1];
    my $y2 = $v2->[2];
    my $z2 = $v2->[3];
    my $d1 = man_dist(0, 0, 0, $x1, $y1, $z1);
    my $d2 = man_dist(0, 0, 0, $x2, $y2, $z2);
    if ($d1 < $d2) {
        return 1;
    }
    if ($d2 < $d1) {
        return 0;
    }
    my $r1 = $v1->[4];
    my $r2 = $v2->[4];
    if ($r1 < $r2) {
        return 1;
    }
    return 0;
}

my @pq = ();

sub pq_push {
    my ($v) = @_;
    push(@pq, $v);
    my $l = @pq;
    my $i = $l - 1;
    while ($i != 0 && pq_compare($pq[$i], $pq[pq_parent($i)])) {
        my $tmp = $pq[$i];
        $pq[$i] = $pq[pq_parent($i)];
        $pq[pq_parent($i)] = $tmp;
        $i = pq_parent($i);
    }
}

sub pq_heapify {
    my ($i) = @_;
    my $l = pq_left($i);
    my $r = pq_right($i);
    my $smallest = $i;
    if ($l < $#pq && pq_compare($pq[$l], $pq[$i])) {
        $smallest = $l;
    }
    if ($r < $#pq && pq_compare($pq[$r], $pq[$smallest])) {
        $smallest = $r;
    }
    if ($smallest != $i) {
        my $tmp = $pq[$i];
        $pq[$i] = $pq[$smallest];
        $pq[$smallest] = $tmp;
        pq_heapify($smallest);
    }
}

sub pq_pop {
    my $l = $#pq;
    if ($l == 1) {
        return shift(@pq);
    }

    my $root = $pq[0];
    $pq[0] = $pq[$l - 1];
    pop(@pq);
    pq_heapify(0);
    return $root;
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
my $min_x = $xx[0];
my $min_y = $yy[0];
my $min_z = $zz[0];

for my $i (0...$#rr) {
    if (dist($i, $strongest) <= $rr[$strongest]) {
        $in_range++;
    }
    if ($xx[$i] < $min_x) {
        $min_x = $xx[$i];
    }
    if ($yy[$i] < $min_y) {
        $min_y = $yy[$i];
    }
    if ($zz[$i] < $min_z) {
        $min_z = $zz[$i];
    }
}

print "Part 1: ", $in_range, "\n";

sub outside_len {
    my ($v, $l, $r) = @_;
    if ($v < $l) {
        return $l - $v;
    }
    if ($v > $r) {
        return $v - $r;
    }
    return 0;
}

my @start = ($#rr, $min_x, $min_y, $min_z, 2147483648);
pq_push(\@start);
my $dist = 0;
my $found = 0;

while ($found == 0 && @pq) {
    my $curr = pq_pop();
    my $bots = $curr->[0];
    my $x = $curr->[1];
    my $y = $curr->[2];
    my $z = $curr->[3];
    my $r = $curr->[4];

    if ($r == 1) {
        $dist = man_dist(0, 0, 0, $x, $y, $z);
        $found = 1;
    } else {
        my $newR = $r / 2;
        for my $i (0..1) {
            for my $j (0..1) {
                for my $k (0..1) {
                    my $newBots = 0;
                    my $newX1 = $x + $i * $newR;
                    my $newY1 = $y + $j * $newR;
                    my $newZ1 = $z + $k * $newR;
                    my $newX2 = $newX1 + $newR - 1;
                    my $newY2 = $newY1 + $newR - 1;
                    my $newZ2 = $newZ1 + $newR - 1;
                    for my $l (0...$#rr) {
                        my $d = 0;
                        $d += outside_len($xx[$l], $newX1, $newX2);
                        $d += outside_len($yy[$l], $newY1, $newY2);
                        $d += outside_len($zz[$l], $newZ1, $newZ2);
                        if ($d <= $rr[$l]) {
                            $newBots++;
                        }
                    }
                    if ($newBots > 0) {
                        my @newCube = ($newBots, $newX1, $newY1, $newZ1, $newR);
                        pq_push(\@newCube);
                    }
                }
            }
        }
    }
}

print "Part 2: ", $dist, "\n";
