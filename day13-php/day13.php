<?php

$file = fopen("13.input", "r");
$lines = array();
while (!feof($file)) {
    $lines[] = fgets($file);
}
fclose($file);

$cart_chars = array(
    '^' => array('d' => 0, 'n' => '|'),
    '>' => array('d' => 1, 'n' => '-'),
    'v' => array('d' => 2, 'n' => '|'),
    '<' => array('d' => 3, 'n' => '-'));

$carts = array();
for ($i = 0; $i < count($lines); ++$i) {
    for ($j = 0; $j < strlen($lines[$i]); ++$j) {
        if (array_key_exists($lines[$i][$j], $cart_chars)) {
            $carts[] = array(
                'i' => $i,
                'j' => $j,
                'd' => $cart_chars[$lines[$i][$j]]['d'],
                'n' => -1,
                'g' => true);
            $lines[$i][$j] = $cart_chars[$lines[$i][$j]]['n'];
        }
    }
}

function cart_comparison($cart1, $cart2) {
    if ($cart1['i'] < $cart2['i'] || ($cart1['i'] == $cart2['i'] && $cart1['j'] < $cart2['j']))
        return -1;
    if ($cart1['i'] == $cart2['i'] && $cart1['j'] == $cart2['j'])
        return 0;
    return 1;
}

function has_collision($cart_i, $carts) {
    for ($i = 0; $i < count($carts); ++$i) {
        if ($i == $cart_i || !$carts[$i]['g'])
            continue;
        if (cart_comparison($carts[$i], $carts[$cart_i]) == 0)
            return $i;
    }
    return -1;
}

$ddiff = array(array(-1, 0), array(0, 1), array(1, 0), array(0, -1));

$direction_changes = array(
    '\\' => array(0 => 3, 1 => 2, 2 => 1, 3 => 0),
    '/' => array(0 => 1, 1 => 0, 2 => 3, 3 => 2));

$ci = -1;
$cj = -1;
$good_carts = count($carts);
while ($good_carts > 1) {
    usort($carts, "cart_comparison");
    for ($i = 0; $i < count($carts); ++$i) {
        if (!$carts[$i]['g'])
            continue;
        $carts[$i]['i'] += $ddiff[$carts[$i]['d']][0];
        $carts[$i]['j'] += $ddiff[$carts[$i]['d']][1];
        $ni = $carts[$i]['i'];
        $nj = $carts[$i]['j'];
        $collision = has_collision($i, $carts);
        if ($collision != -1) {
            if ($ci == -1) {
                $ci = $ni;
                $cj = $nj;
            }
            $carts[$i]['g'] = $carts[$collision]['g'] = false;
            $good_carts -= 2;
            continue;
        }
        if ($lines[$ni][$nj] == '+') {
            $carts[$i]['d'] = ($carts[$i]['d'] + 4 + $carts[$i]['n']) % 4;
            $carts[$i]['n'] = (($carts[$i]['n'] + 2) % 3) - 1;
        } else if (array_key_exists($lines[$ni][$nj], $direction_changes)) {
            $carts[$i]['d'] = $direction_changes[$lines[$ni][$nj]][$carts[$i]['d']];
        }
    }
}

$fi = -1;
$fj = -1;
for ($i = 0; $i < count($carts); ++$i) {
    if (!$carts[$i]['g'])
        continue;
    $fi = $carts[$i]['i'];
    $fj = $carts[$i]['j'];
    break;
}

echo("Part 1: ".$cj.",".$ci."\n");
echo("Part 2: ".$fj.",".$fi."\n");

?>
