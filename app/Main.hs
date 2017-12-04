module Main where

import Numeric.Matrix (toList, fromList, rank)
import Text.Printf

main :: IO ()
main = do
  str <- readFile "in.txt"
  let matList = map (map read . words) $ lines str :: [[Double]]
      a = fromList matList
      r = round $ rank a :: Int
  printf "Matrix rank is %v\n" r
  let outStr = unlines . map (unwords . map show) $ toList a
  writeFile "out.txt" outStr
