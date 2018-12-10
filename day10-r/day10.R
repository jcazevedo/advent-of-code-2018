readInput = function(filename) {
  f = file(filename, "r")
  lines = readLines(f)
  close(f)
  lights = data.frame(
    x = as.numeric(substr(lines, 11, 16)),
    y = as.numeric(substr(lines, 19, 24)),
    vx = as.numeric(substr(lines, 37, 38)),
    vy = as.numeric(substr(lines, 41, 42)))
  return(lights)
}

rotate = function(x) t(apply(x, 2, rev))

lights = readInput("10.input")

good = function(lights, seconds) {
  x = lights$x + lights$vx * seconds
  xl = max(x) - min(x)
  nx = lights$x + lights$vx * (seconds + 1)
  nxl = max(nx) - min(nx)
  return(nxl > xl)
}

l = 0
r = 1000000
while (l < r) {
  m = (l + r) %/% 2
  if (good(lights, m)) {
    r = m - 1
  } else {
    l = m + 1
  }
}

current = data.frame(
  x = lights$x + lights$vx * l,
  y = lights$y + lights$vy * l)
minX = min(current$x)
maxX = max(current$x)
minY = min(current$y)
maxY = max(current$y)
H = maxY - minY + 1
W = maxX - minX + 1
m = matrix(' ', nrow = H, ncol = W)
for (row in 1:nrow(current)) {
  x = current[row, "x"] - minX + 1
  y = current[row, "y"] - minY + 1
  m[y, x] = '#'
}
cat("Part 1:\n")
for (i in 1:H) {
  cat(paste(paste(m[i,], collapse=""), "\n", sep=""))
}
cat(paste("Part 2: ", l, "\n", sep=""))
