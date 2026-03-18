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

-- Estado global de la app
data AppState = AppState
  { customers :: Map.Map CustomerId Customer          -- Clientes
  , products  :: TVar (Map.Map ProductId Product)     -- Productos (mutable)
  , carts     :: TVar (Map.Map CustomerId (Map.Map ProductId Int)) -- Carritos
  }

-- Datos iniciales de clientes
seedCustomers :: Map.Map CustomerId Customer
seedCustomers = Map.fromList
  [ (1, Customer 1 "Ana")
  , (2, Customer 2 "Luis")
  ]

-- Datos iniciales de productos
seedProducts :: Map.Map ProductId Product
seedProducts = Map.fromList
  [ (101, Product 101 "Keyboard ⌨️" 2999 0)
  , (102, Product 102 "Mouse 🖱️" 1499 0)
  , (103, Product 103 "USB-C Cable 🔌" 799 0)
  , (104, Product 104 "Headphones 🎧" 4999 0)
  ]

-- Inicializa el estado con datos y TVars
initState :: IO AppState
initState = do
  productVar <- newTVarIO seedProducts
  cartVar    <- newTVarIO Map.empty
  pure AppState { customers = seedCustomers, products = productVar, carts = cartVar }

-- Verifica que el cliente exista (si no, error 404)
requireCustomer :: AppState -> CustomerId -> ActionM ()
requireCustomer appState cid =
  case Map.lookup cid (customers appState) of
    Nothing -> status status404 >> json ("customer not found" :: Text) >> finish
    Just _  -> pure ()

-- Verifica que el producto exista (si no, error 404)
requireProduct :: Map.Map ProductId Product -> ProductId -> ActionM Product
requireProduct productMap pid =
  case Map.lookup pid productMap of
    Nothing -> status status404 >> json ("product not found" :: Text) >> finish
    Just p  -> pure p

-- Lee todos los productos
readProducts :: AppState -> ActionM (Map.Map ProductId Product)
readProducts appState = liftIO (readTVarIO (products appState))

-- Lee el carrito de un cliente
readCart :: AppState -> CustomerId -> ActionM (Map.Map ProductId Int)
readCart appState cid = do
  allCarts <- liftIO (readTVarIO (carts appState))
  pure (Map.findWithDefault Map.empty cid allCarts)

-- Guarda/actualiza el carrito de un cliente
writeCart :: AppState -> CustomerId -> Map.Map ProductId Int -> ActionM ()
writeCart appState cid cart =
  liftIO $ atomically $ modifyTVar' (carts appState) (Map.insert cid cart)