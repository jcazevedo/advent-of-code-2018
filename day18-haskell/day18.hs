import Data.Maybe
import Data.List

directions = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]

count c = length . filter (== c)

countGrid c grid =
  sum $ map (count c) grid

nextch '.' n = if count '|' n >= 3 then '|' else '.'
nextch '|' n = if count '#' n >= 3 then '#' else '|'
nextch '#' n = if count '#' n >= 1 && count '|' n >= 1 then '#' else '.'
nextch c _   = c

acreNeighbors i j grid =
  catMaybes $ map (\(di, dj) -> getch (i + di) (j + dj)) directions
  where getch i j =
          if i < 0 || i >= length grid || j < 0 || j >= length (grid !! i)
          then Nothing
          else Just $ grid !! i !! j

next grid =
  let gridI = zip grid [0..] in
    map nextLine gridI
  where nextLine (line, i) =
          let gridJ = zip line [0..] in
            map (\(ch, j) -> nextch ch $ acreNeighbors i j grid) gridJ

states grid =
  let grids = iterate next grid
      gridsI = zip grids [0..]
      repetitions = map (reps gridsI) gridsI
      (ls, le) = head $ dropWhile (\(v, _) -> v == -1) repetitions
      loop = cycle $ take (le - ls) (drop ls grids) in
    take ls grids ++ loop
  where reps gridsI (v, i) =
          let firstFind = find (\(x, _) -> v == x) gridsI in
            prev firstFind
          where prev (Just (_, j)) = (if (i == j) then -1 else j, i)
                prev Nothing = (-1, i)

resourceValue grid = (countGrid '|' grid) * (countGrid '#' grid)

main =
  do
    file <- readFile "18.input"
    let grid = lines file
    let st = states grid
    let p1 = head $ drop 10 st
    let p2 = head $ drop 1000000000 st
    putStrLn $ "Part 1: " ++ show (resourceValue p1)
    putStrLn $ "Part 2: " ++ show (resourceValue p2)
