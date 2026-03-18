{-# LANGUAGE OverloadedStrings #-} -- Permite usar Text

module Routes.Products (productRoutes) where -- Exporta rutas productos

import Control.Concurrent.STM (atomically, modifyTVar') -- Modificar estado
import qualified Data.Map.Strict as Map -- Mapas
import Network.HTTP.Types.Status (status400) -- Error 400
import Data.Text (Text) -- Tipo Text
import Web.Scotty -- Framework web

import Types.Product ( Product(discountPercent) ) -- Campo descuento
import Types.Requests (DiscountRequest(..)) -- Request descuento
import Services.State
    ( readProducts, requireProduct, AppState(products) ) -- Estado

productRoutes :: AppState -> ScottyM ()
productRoutes appState = do

  -- Obtener productos
  get "/products" $ do
    prods <- readProducts appState -- Lee productos
    json (Map.elems prods) -- Devuelve lista

  -- Aplicar descuento
  post "/products/:pid/discount" $ do
    pid <- pathParam "pid" -- ID producto
    DiscountRequest discount <- jsonData -- Nuevo descuento
    requireValidDiscount discount -- Valida rango

    -- Actualiza descuento en memoria
    liftIO $ atomically $ modifyTVar' (products appState) $
      Map.adjust (\p -> p { discountPercent = discount }) pid

    -- Devuelve producto actualizado
    readProducts appState >>= \prods -> requireProduct prods pid >>= json

-- Valida descuento entre 0 y 100
requireValidDiscount :: Int -> ActionM ()
requireValidDiscount value
  | value < 0 || value > 100 = status status400 >> json ("discountPercent must be between 0 and 100" :: Text) >> finish -- Error
  | otherwise                 = pure () -- OK