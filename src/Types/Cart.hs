{-# LANGUAGE DeriveGeneric #-} -- Permite usar Generic

module Types.Cart where -- Define tipos del carrito

import Data.Aeson (ToJSON) -- Para JSON
import Data.Text (Text) -- Tipo Text
import GHC.Generics (Generic) -- Soporte Generic

import Types.Customer (CustomerId) -- ID cliente
import Types.Product (ProductId) -- ID producto

-- Línea individual del carrito
data CartLine = CartLine
  { lineProductId       :: ProductId -- ID producto
  , lineProductName     :: Text -- Nombre
  , linePriceInCents    :: Int -- Precio unitario
  , lineDiscountPercent :: Int -- % descuento
  , lineQuantity        :: Int -- Cantidad
  , lineSubtotalInCents :: Int -- Subtotal
  , lineDiscountInCents :: Int -- Descuento
  , lineTotalInCents    :: Int -- Total final
  } deriving (Show, Generic)

instance ToJSON CartLine -- Convertible a JSON

-- Vista completa del carrito
data CartView = CartView
  { cartCustomerId       :: CustomerId -- ID cliente
  , cartItems            :: [CartLine] -- Lista de productos
  , cartSubtotalInCents  :: Int -- Subtotal
  , cartDiscountInCents  :: Int -- Descuento total
  , cartTotalInCents     :: Int -- Total final
  } deriving (Show, Generic)

instance ToJSON CartView -- Convertible a JSON