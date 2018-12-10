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

seconds = 0
found = FALSE
keepGoing = TRUE
while (keepGoing) {
  current = data.frame(
    x = lights$x + lights$vx * seconds,
    y = lights$y + lights$vy * seconds)
  minX = min(current$x)
  maxX = max(current$x)
  minY = min(current$y)
  maxY = max(current$y)
  H = maxY - minY + 1
  W = maxX - minX + 1
  if (W <= nrow(current)) {
    found = TRUE
    m = matrix(0, nrow = H, ncol = W)
    for (row in 1:nrow(current)) {
      x = current[row, "x"] - minX + 1
      y = current[row, "y"] - minY + 1
      m[y, x] = 1
    }
    image(rotate(m), axes = FALSE)
    filename = paste(seconds, ".png", sep="")
    png(filename = filename)
  }
  if (found && W > nrow(current)) {
    keepGoing = FALSE
  }
  seconds = seconds + 1
}
