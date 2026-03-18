{-# LANGUAGE OverloadedStrings #-}

module Services.State
  ( AppState(..)
  , initState
  , requireCustomer
  , requireProduct
  , readProducts
  , readCart
  , writeCart
  ) where

import Control.Concurrent.STM
import Control.Monad.IO.Class (liftIO)
import qualified Data.Map.Strict as Map
import Network.HTTP.Types.Status (status404)
import Data.Text (Text)
import Web.Scotty (ActionM, json, status, finish)

import Types.Customer
import Types.Product

data AppState = AppState
  { customers :: Map.Map CustomerId Customer
  , products  :: TVar (Map.Map ProductId Product)
  , carts     :: TVar (Map.Map CustomerId (Map.Map ProductId Int))
  }

seedCustomers :: Map.Map CustomerId Customer
seedCustomers = Map.fromList
  [ (1, Customer { customerId = 1, customerName = "Ana" })
  , (2, Customer { customerId = 2, customerName = "Luis" })
  ]

seedProducts :: Map.Map ProductId Product
seedProducts = Map.fromList
  [ (101, Product { productId = 101, productName = "Keyboard ⌨️", priceInCents = 2999, discountPercent = 0 })
  , (102, Product { productId = 102, productName = "Mouse 🖱️", priceInCents = 1499, discountPercent = 0 })
  , (103, Product { productId = 103, productName = "USB-C Cable 🔌", priceInCents = 799, discountPercent = 0 })
  , (104, Product { productId = 104, productName = "Headphones 🎧", priceInCents = 4999, discountPercent = 0 })
  ]

initState :: IO AppState
initState = do
  productVar <- newTVarIO seedProducts
  cartVar    <- newTVarIO Map.empty
  pure AppState
    { customers = seedCustomers
    , products  = productVar
    , carts     = cartVar
    }

requireCustomer :: AppState -> CustomerId -> ActionM ()
requireCustomer appState cid =
  case Map.lookup cid (customers appState) of
    Nothing -> status status404 >> json ("customer not found" :: Text) >> finish
    Just _  -> pure ()

requireProduct :: Map.Map ProductId Product -> ProductId -> ActionM Product
requireProduct productMap pid =
  case Map.lookup pid productMap of
    Nothing -> status status404 >> json ("product not found" :: Text) >> finish
    Just p  -> pure p

readProducts :: AppState -> ActionM (Map.Map ProductId Product)
readProducts appState = liftIO (readTVarIO (products appState))

readCart :: AppState -> CustomerId -> ActionM (Map.Map ProductId Int)
readCart appState cid = do
  allCarts <- liftIO (readTVarIO (carts appState))
  pure (Map.findWithDefault Map.empty cid allCarts)

writeCart :: AppState -> CustomerId -> Map.Map ProductId Int -> ActionM ()
writeCart appState cid cart =
  liftIO $ atomically $ modifyTVar' (carts appState) (Map.insert cid cart)