module Main

import Data.SortedSet
import Data.String

toIntList : List String -> List Integer
toIntList [] = []
toIntList (x :: xs) = maybe (toIntList xs) (\x => x :: (toIntList xs)) (parseInteger x)

firstRepeat : List Integer -> Integer
firstRepeat [] = 0
firstRepeat (x :: xs) = firstRepeatAux 0 infF (insert 0 empty) where
  infF : Stream Integer
  infF = cycle (x :: xs)

  firstRepeatAux : Integer -> Stream Integer -> SortedSet Integer -> Integer
  firstRepeatAux freq (x :: xs) visited =
    let nextFreq = freq + x in
    if (contains nextFreq visited)
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
