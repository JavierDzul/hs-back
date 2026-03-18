{-# LANGUAGE OverloadedStrings #-} -- Permite usar Text

module Routes.Cart (cartRoutes) where -- Exporta rutas carrito

import qualified Data.Map.Strict as Map -- Mapas
import Network.HTTP.Types.Status (status400) -- Error 400
import Data.Text (Text) -- Tipo Text
import Web.Scotty -- Framework web
import Types.Requests (AddToCartRequest(..), RemoveFromCartRequest(..)) -- Requests
import Services.State
    ( readCart,
      readProducts,
      requireCustomer,
      requireProduct,
      writeCart,
      AppState ) -- Estado y helpers
      
import Services.Cart (buildCartView) -- Construye vista carrito

cartRoutes :: AppState -> ScottyM ()
cartRoutes appState = do

  -- Obtener carrito
  get "/customers/:cid/cart" $ do
    cid <- pathParam "cid" -- ID cliente
    requireCustomer appState cid -- Valida cliente
    prods <- readProducts appState -- Lee productos
    cart  <- readCart appState cid -- Lee carrito
    json (buildCartView cid prods cart) -- Respuesta

  -- Agregar producto
  post "/customers/:cid/cart/add" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    AddToCartRequest pid quantity <- jsonData -- Datos JSON
    requirePositiveQuantity quantity -- Valida cantidad
    prods <- readProducts appState
    _     <- requireProduct prods pid -- Valida producto
    cart  <- readCart appState cid
    let current = Map.findWithDefault 0 pid cart -- Cantidad actual
        updated = Map.insert pid (current + quantity) cart -- Suma
    writeCart appState cid updated -- Guarda
    json (buildCartView cid prods updated)

  -- Eliminar producto
  post "/customers/:cid/cart/remove" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    RemoveFromCartRequest pid <- jsonData -- ID producto
    prods <- readProducts appState
    cart  <- readCart appState cid
    let updated = Map.delete pid cart -- Elimina
    writeCart appState cid updated
    json (buildCartView cid prods updated)

  -- Vaciar carrito
  post "/customers/:cid/cart/clear" $ do
    cid <- pathParam "cid"
    requireCustomer appState cid
    prods <- readProducts appState
    writeCart appState cid Map.empty -- Vacía
    json (buildCartView cid prods Map.empty)

-- Valida cantidad > 0
requirePositiveQuantity :: Int -> ActionM ()
requirePositiveQuantity value
  | value <= 0 = status status400 >> json ("quantity must be greater than 0" :: Text) >> finish -- Error
  | otherwise   = pure () -- OK