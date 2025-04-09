module Main (main) where

import Assistant (run)

main :: IO ()
main = do
  putStrLn "Hello, Assistant!"
  run
