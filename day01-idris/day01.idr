module Main

import Data.String

data BST a = Leaf
           | Node (BST a) a (BST a)

insert : Ord a => a -> BST a -> BST a
insert x Leaf = Node Leaf x Leaf
insert x (Node l v r) =
  if (x < v)
  then Node (insert x l) v r
  else Node l v (insert x r)

exists : Ord a => a -> BST a -> Bool
exists x Leaf = False
exists x (Node l v r) =
  if (x == v)
  then True
  else if (x < v) then exists x l else exists x r

toIntList : List String -> List Integer
toIntList [] = []
toIntList (x :: xs) = maybe (toIntList xs) (\x => x :: (toIntList xs)) (parseInteger x)

firstRepeat : List Integer -> Integer
firstRepeat [] = 0
firstRepeat (x :: xs) = firstRepeatAux 0 infF (insert 0 Leaf) where
  infF : Stream Integer
  infF = cycle (x :: xs)

  firstRepeatAux : Integer -> Stream Integer -> BST Integer -> Integer
  firstRepeatAux freq (x :: xs) visited =
    let nextFreq = freq + x in
    if (exists nextFreq visited)
    then nextFreq
    else firstRepeatAux nextFreq xs (insert nextFreq visited)

readLine : File -> IO String
readLine f = do l <- fGetLine f
                pure (either (\_ => "") (\x => x) l)

readLines : File -> IO (List String)
readLines f = readLinesAcc [] where
  readLinesAcc : List String -> IO (List String)
  readLinesAcc acc = if (not !(fEOF f))
                     then readLinesAcc (!(readLine f) :: acc)
                     else pure (reverse acc)

main : IO ()
main = case !(openFile "01.input" Read) of
         Left error => putStrLn "Error opening file"
         Right f =>
           let frequencies = toIntList !(readLines f) in
           do putStrLn $ "Part 1: " ++ (show (foldr (+) 0 frequencies))
              putStrLn $ "Part 2: " ++ (show (firstRepeat frequencies))
