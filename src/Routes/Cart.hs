{-# LANGUAGE OverloadedStrings #-}

module Routes.Cart (cartRoutes) where

import qualified Data.Map.Strict as Map
import Network.HTTP.Types.Status (status400)
import Data.Text (Text)
import Web.Scotty
import Types.Requests (AddToCartRequest(..), RemoveFromCartRequest(..))
import Services.State
    ( readCart,
      readProducts,
      requireCustomer,
      requireProduct,
      writeCart,
      AppState )
      
import Services.Cart (buildCartView)

cartRoutes :: AppState -> ScottyM ()
cartRoutes appState = do
  get "/customers/:cid/cart" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    prods <- readProducts appState
    cart  <- readCart appState cid
    json (buildCartView cid prods cart)

  post "/customers/:cid/cart/add" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    AddToCartRequest pid quantity <- jsonData
    requirePositiveQuantity quantity
    prods <- readProducts appState
    _     <- requireProduct prods pid
    cart  <- readCart appState cid
    let current = Map.findWithDefault 0 pid cart
        updated = Map.insert pid (current + quantity) cart
    writeCart appState cid updated
    json (buildCartView cid prods updated)

  post "/customers/:cid/cart/remove" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    RemoveFromCartRequest pid <- jsonData
    prods <- readProducts appState
    cart  <- readCart appState cid
    let updated = Map.delete pid cart
    writeCart appState cid updated
    json (buildCartView cid prods updated)

  post "/customers/:cid/cart/clear" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    prods <- readProducts appState
    writeCart appState cid Map.empty
    json (buildCartView cid prods Map.empty)

requirePositiveQuantity :: Int -> ActionM ()
requirePositiveQuantity value
  | value <= 0 = status status400 >> json ("quantity must be greater than 0" :: Text) >> finish
  | otherwise   = pure ()