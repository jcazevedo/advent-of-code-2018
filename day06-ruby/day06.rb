coords = []
min_i = 1000000
max_i = -1000000
min_j = 1000000
max_j = -1000000

File.open("06.input").each do |line|
  cc = line.split(", ").each { |s| s.strip! }
  i = cc[0].to_i
  j = cc[1].to_i
  min_i = [min_i, i].min
  max_i = [max_i, i].max
  min_j = [min_j, j].min
  max_j = [max_j, j].max
  coords.push([i, j])
end

areas = {}
is_infinite = {}

def dist(c1, c2)
  (c1[0] - c2[0]).abs + (c1[1] - c2[1]).abs
end

for i in min_i..max_i do
  for j in min_j..max_j do
    curr_dists = {}
    for c in coords do
      curr_dists[c] = dist(c, [i, j])
    end
    min_dist = curr_dists.min_by { |_, v| v }[1]
    relevant_dists = curr_dists.select { |_, v| v == min_dist }
    if relevant_dists.size == 1
      coord = relevant_dists.first[0]
      areas[coord] = (areas[coord] || 0) + 1
      if i == min_i || i == max_i || j == min_j || j == max_j
        is_infinite[coord] = true
      end
    end
  end
end

largest_area = areas.select { |k, _| !is_infinite[k] }.max_by { |_, v| v }[1]
puts "Part 1: " + largest_area.to_s
