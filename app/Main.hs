module Main where

import Data.List ((!!))
import Numeric.Matrix (toList, fromList, numRows, numCols, Matrix, rank, at)
import Data.Array.MArray (newListArray, readArray, writeArray, getAssocs, MArray, getElems)
import Data.Array.IO (IOArray)
import Data.IORef (newIORef, readIORef, writeIORef)

main :: IO ()
main = do
  str <- readFile "d3.dat"
  let matList = map (map read . words) $ lines str :: [[Double]]
      a = fromList matList
      m = numRows a
      n = numCols a
      r = round $ rank a
  print matList
  print m
  print $ matList !! 0
  print n
  print r
  y <- sequence $ newIORef <$> [1..m]
  mapM readIORef y >>= print
  x <- sequence $ newIORef . negate <$> [1..n]
  mapM readIORef x >>= print
  arr <- newListArray (0, n * m - 1) $ concat matList :: IO (IOArray Int Double)
  let loopK k = do
        print (k, k, matList !! k !! k)
        yk <- readIORef $ y !! k
        xk <- readIORef $ x !! k
        let el = matList !! k !! k
            (ir, jr, kr) =
                if yk > 0 && xk < 0 && el /= 0
                then (k, k, el)
                else (0, 0, 0)
        print (ir, jr, kr)
        calc1 (ir, jr, kr)
      calc1 :: (Int, Int, Double) -> IO ()
      calc1 (ir, jr, kr) = do
        sequence [do
          aij <- readArray arr $ i * n + j
          a1 <- readArray arr $ ir * n + j
          a2 <- readArray arr $ i * n + jr
          writeArray arr (i * n + j) $ if i /= ir && j/= jr 
                                       then aij - a1*a2/kr
                                       else 1/kr
          | i <- [0..m-1], j <- [0..n-1]]
        getElems arr >>= print
        aij <- readArray arr $ ir * n + jr
        let calcEl :: (Int, Double) -> IO ()
            calcEl (index, el) = if i == ir && j /= jr ||
                                    i /= ir && j == jr
                                 then writeArray arr (i * n + j) $ el * aij
                                 else return ()
              where (i, j) = index `divMod` n
        ass <- getAssocs arr
        sequence . (map calcEl) $ ass
        getElems arr >>= print
        yi <- readIORef $ y !! ir
        readIORef (x !! jr) >>= writeIORef (y !! ir)
        writeIORef (x !! jr) yi
        mapM readIORef y >>= print
        mapM readIORef x >>= print

  sequence $ map loopK [0..r-1]
  getElems arr >>= print
  return ()


