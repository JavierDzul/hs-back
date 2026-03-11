{-# LANGUAGE OverloadedStrings #-}

module Routes.Products (productRoutes) where

import Control.Concurrent.STM (atomically, modifyTVar')
import qualified Data.Map.Strict as Map
import Network.HTTP.Types.Status (status400)
import Data.Text (Text)
import Web.Scotty

import Types.Product ( Product(discountPercent) )
import Types.Requests (DiscountRequest(..))
import Services.State
    ( readProducts, requireProduct, AppState(products) )

productRoutes :: AppState -> ScottyM ()
productRoutes appState = do
  get "/products" $ do
    prods <- readProducts appState
    json (Map.elems prods)

  post "/products/:pid/discount" $ do
    pid <- pathParam "pid"
    DiscountRequest discount <- jsonData
    requireValidDiscount discount
    liftIO $ atomically $ modifyTVar' (products appState) $
      Map.adjust (\p -> p { discountPercent = discount }) pid
    readProducts appState >>= \prods -> requireProduct prods pid >>= json

requireValidDiscount :: Int -> ActionM ()
requireValidDiscount value
  | value < 0 || value > 100 = status status400 >> json ("discountPercent must be between 0 and 100" :: Text) >> finish
  | otherwise                 = pure ()