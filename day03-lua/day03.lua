function split(s, delimiter)
  result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

local rectangles = {}

for line in io.lines("03.input") do
  local s = split(line, " ")
  local ij = split(s[3]:gsub(":", ""), ",")
  local wh = split(s[4], "x")
  rectangles[#rectangles + 1] = {i = tonumber(ij[1]), j = tonumber(ij[2]), w = tonumber(wh[1]), h = tonumber(wh[2]), id = s[1]}
end

local iin = {}
local iout = {}
local iit = {}
for i = 1, #rectangles do
  if iin[rectangles[i].i] == nil then
    iin[rectangles[i].i] = {}
  end

  if iout[rectangles[i].i + rectangles[i].w] == nil then
    iout[rectangles[i].i + rectangles[i].w] = {}
  end

  table.insert(iin[rectangles[i].i], rectangles[i])
  table.insert(iout[rectangles[i].i + rectangles[i].w], rectangles[i])

  iit[rectangles[i].i] = true
  iit[rectangles[i].i + rectangles[i].w] = true
end

local ii = {}
for k, _ in pairs(iit) do table.insert(ii, k) end
table.sort(ii)

local a = 0
local prev_x = 0
local jin = {}
local jout = {}
local jjt = {}
for _, k in pairs(ii) do
  local jj = {}
  for l, _ in pairs(jjt) do table.insert(jj, l) end
  table.sort(jj)
  local prev_y = 0
  local curr = 0
  for _, v in pairs(jj) do
    if curr > 1 then
      a = a + (v - prev_y) * (k - prev_x)
    end
    if jin[v] ~= nil then
      curr = curr + #jin[v]
    end
    if jout[v] ~= nil then
      curr = curr - #jout[v]
    end
    prev_y = v
  end

  if iin[k] ~= nil then
    for i = 1, #iin[k] do
      if jin[iin[k][i].j] == nil then
        jin[iin[k][i].j] = {}
      end

      if jout[iin[k][i].j + iin[k][i].h] == nil then
        jout[iin[k][i].j + iin[k][i].h] = {}
      end

      table.insert(jin[iin[k][i].j], iin[k][i])
      table.insert(jout[iin[k][i].j + iin[k][i].h], iin[k][i])

      jjt[iin[k][i].j] = (jjt[iin[k][i].j] or 0) + 1
      jjt[iin[k][i].j + iin[k][i].h] = (jjt[iin[k][i].j + iin[k][i].h] or 0) + 1
    end
  end

  if iout[k] ~= nil then
    for i = 1, #iout[k] do
      local to_remove = iout[k][i]
      for kk, v in pairs(jin[iout[k][i].j]) do
        if v.id == to_remove.id then
          table.remove(jin[iout[k][i].j], kk)
          break
        end
      end

      for kk, v in pairs(jout[iout[k][i].j + iout[k][i].h]) do
        if v.id == to_remove.id then
          table.remove(jout[iout[k][i].j + iout[k][i].h], kk)
          break
        end
      end

      jjt[iout[k][i].j] = jjt[iout[k][i].j] - 1
      if jjt[iout[k][i].j] == 0 then
        jjt[iout[k][i].j] = nil
      end

      jjt[iout[k][i].j + iout[k][i].h] = jjt[iout[k][i].j + iout[k][i].h] - 1
      if jjt[iout[k][i].j + iout[k][i].h] == 0 then
        jjt[iout[k][i].j + iout[k][i].h] = nil
      end
    end
  end

  prev_x = k
end

print("Part 1: " .. a)
