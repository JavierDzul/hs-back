{-# LANGUAGE OverloadedStrings #-}

module Routes.Card (cardRoutes) where

import Web.Scotty

import Types.Requests (CardRequest(..))
import Services.Validation (validateCardNumber)

cardRoutes :: ScottyM ()
cardRoutes =
  post "/validate-card" $ do
    CardRequest number <- jsonData
    json (validateCardNumber number)