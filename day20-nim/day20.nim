import queues
import sets
import strformat
import strutils
import tables

var directions = readFile("20.input").strip().multiReplace(("^", ""), ("$", ""))
var graph = initTable[(int, int), HashSet[(int, int)]]()
var dirs = {'N': (-1, 0), 'E': (0, 1), 'S': (1, 0), 'W': (0, -1)}.toTable

proc addConnection(n1: (int, int), n2: (int, int)) =
  if not(graph.hasKey(n1)):
    graph[n1] = initSet[(int, int)]()
  graph[n1].incl(n2)

var s = initSet[(int, int)]()
var tp = initSet[(int, int)]()
tp.incl((0, 0))
var p = initSet[(int, int)]()
p.incl((0, 0))
var stack: seq[(HashSet[(int, int)], HashSet[(int, int)])] = @[]

for ch in directions:
  if ch == '|':
    tp = tp + p
    p = s
  elif ch == '(':
    stack.add((s, tp))
    s = p
    tp = initSet[(int, int)]()
  elif ch == ')':
    p = p + tp
    (s, tp) = stack.pop()
  else:
    var diff = dirs[ch]
    var np = initSet[(int, int)]()
    for curr in p:
      var next = (curr[0] + diff[0], curr[1] + diff[1])
      addConnection(curr, next)
      addConnection(next, curr)
      np.incl(next)
    p = np

var queue = initQueue[(int, int)]()
var bestDist = 0
var farRooms = 0
var dists = initTable[(int, int), int]()
queue.add((0, 0))
dists[(0, 0)] = 0

while queue.len > 0:
  var curr = queue.pop
  if dists[curr] > bestDist:
    bestDist = dists[curr]
  if dists[curr] >= 1000:
    farRooms += 1
  for neigh in graph[curr]:
    if not(dists.contains(neigh)) or dists[neigh] > dists[curr] + 1:
      dists[neigh] = dists[curr] + 1
      queue.add(neigh)

echo fmt"Part 1: {bestDist}"
echo fmt"Part 2: {farRooms}"
