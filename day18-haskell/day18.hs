import Data.Maybe
import Data.List
import Debug.Trace

directions = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]

getch i j grid =
  if i < 0 || i >= length grid || j < 0 || j >= length (grid !! i)
  then Nothing
  else Just $ grid !! i !! j

count c = length . filter (== c)

countGrid c grid =
  sum $ map (count c) grid

nextch '.' n = if count '|' n >= 3 then '|' else '.'
nextch '|' n = if count '#' n >= 3 then '#' else '|'
nextch '#' n = if count '#' n >= 1 && count '|' n >= 1 then '#' else '.'
nextch c _   = c

acreNeighbors i j grid =
  catMaybes $ map (\(di, dj) -> getch (i + di) (j + dj) grid) directions

next grid =
  let gridI = zip grid [0..] in
    map nextLine gridI
  where nextLine (line, i) =
          let gridJ = zip line [0..] in
            map (\(ch, j) -> nextch ch $ acreNeighbors i j grid) gridJ

main =
  do
    file <- readFile "18.input"
    let grid = lines file
    let states = iterate next grid
    let p1 = head $ drop 10 states
    putStrLn $ "Part 1: " ++ show ((countGrid '|' p1) * (countGrid '#' p1))
