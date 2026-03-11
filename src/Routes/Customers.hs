{-# LANGUAGE OverloadedStrings #-}

module Routes.Customers (customerRoutes) where

import qualified Data.Map.Strict as Map
import Web.Scotty ( get, json, ScottyM )

import Services.State ( AppState(customers) )

customerRoutes :: AppState -> ScottyM ()
customerRoutes appState =
  get "/customers" $
    json (Map.elems (customers appState))