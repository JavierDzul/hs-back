module Main where

import Web.Scotty (scotty)
import Services.State (initState)
import Services.Routes (allRoutes)

main :: IO ()
main = do
  state <- initState
  scotty 3000 (allRoutes state)