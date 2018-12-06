$coords = []
$min_i = 1000000
$max_i = -1000000
$min_j = 1000000
$max_j = -1000000

File.open("06.input").each do |line|
  cc = line.split(", ").each { |s| s.strip! }
  i = cc[0].to_i
  j = cc[1].to_i
  $min_i = [$min_i, i].min
  $max_i = [$max_i, i].max
  $min_j = [$min_j, j].min
  $max_j = [$max_j, j].max
  $coords.push([i, j])
end

$areas = {}
$is_infinite = {}

def dist(c1, c2)
  (c1[0] - c2[0]).abs + (c1[1] - c2[1]).abs
end

def coord_dist_sum(c)
  sum = 0
  $coords.each { |x| sum += dist(c, x) }
  sum
end

$max_dist = 10000
$min_dist = $max_dist
$start_coord = [0, 0]

for i in $min_i..$max_i do
  for j in $min_j..$max_j do
    curr_dists = {}
    dist_sum = 0
    $coords.each do |c|
      curr_dist = dist(c, [i, j])
      curr_dists[c] = curr_dist
      dist_sum += curr_dist
    end
    if dist_sum < $min_dist
      $start_coord = [i, j]
      $min_dist = dist_sum
    end
    min_dist = curr_dists.min_by { |_, v| v }[1]
    relevant_dists = curr_dists.select { |_, v| v == min_dist }
    if relevant_dists.size == 1
      coord = relevant_dists.first[0]
      $areas[coord] = ($areas[coord] || 0) + 1
      $is_infinite[coord] = true if i == $min_i || i == $max_i || j == $min_j || j == $max_j
    end
  end
end

$largest_area = $areas.select { |k, _| !$is_infinite[k] }.max_by { |_, v| v }[1]
puts "Part 1: " + $largest_area.to_s

$region_size = 0

if $min_dist < $max_dist
  $region_size = 1
  center_dist = 1
  keep_going = true
  while keep_going do
    keep_going = false
    0.upto(center_dist).each do |d|
      if coord_dist_sum([$start_coord[0] + center_dist - d, $start_coord[1] + d]) < $max_dist
        keep_going = true
        $region_size += 1
      end
      if coord_dist_sum([$start_coord[0] - center_dist + d, $start_coord[1] - d]) < $max_dist
        keep_going = true
        $region_size += 1
      end
      if d > 0 && d < center_dist && coord_dist_sum([$start_coord[0] - center_dist + d, $start_coord[1] + d]) < $max_dist
        keep_going = true
        $region_size += 1
      end
      if d > 0 && d < center_dist && coord_dist_sum([$start_coord[0] + center_dist - d, $start_coord[1] - d]) < $max_dist
        keep_going = true
        $region_size += 1
      end
    end
    center_dist += 1
  end
end

puts "Part 2: " + $region_size.to_s
