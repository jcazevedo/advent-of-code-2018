module Main

import Data.String

readLine : File -> IO String
readLine f = do l <- fGetLine f
                pure (either (\_ => "") (\x => x) l)

readLines : File -> IO (List String)
readLines f = readLinesAcc [] where
  readLinesAcc : List String -> IO (List String)
  readLinesAcc acc = if (not !(fEOF f))
                     then readLinesAcc (!(readLine f) :: acc)
                     else pure (reverse acc)

sumLines : List String -> Int
sumLines l = (maybe 0 (foldr (+) 0) (sequence (map parseInteger l)))

main : IO ()
main = case !(openFile "01.input" Read) of
         Left error => putStrLn "Error opening file"
         Right f => putStrLn $ show (sumLines !(readLines f))
