{-# LANGUAGE DeriveGeneric #-} -- Permite usar Generic

module Types.Requests where -- Tipos de requests

import Data.Aeson (FromJSON) -- Desde JSON
import Data.Text (Text) -- Tipo Text
import GHC.Generics (Generic) -- Soporte Generic

import Types.Product (ProductId) -- ID producto

-- Request para descuento
newtype DiscountRequest = DiscountRequest
  { requestedDiscount :: Int -- % descuento
  } deriving (Show, Generic)

instance FromJSON DiscountRequest -- Desde JSON

-- Request para agregar al carrito
data AddToCartRequest = AddToCartRequest
  { addProductId :: ProductId -- ID producto
  , addQuantity  :: Int -- Cantidad
  } deriving (Show, Generic)

instance FromJSON AddToCartRequest -- Desde JSON

-- Request para eliminar del carrito
newtype RemoveFromCartRequest = RemoveFromCartRequest
  { removeProductId :: ProductId -- ID producto
  } deriving (Show, Generic)

instance FromJSON RemoveFromCartRequest -- Desde JSON

-- Request para validar tarjeta
newtype CardRequest = CardRequest
  { cardNumber :: Text -- Número tarjeta
  } deriving (Show, Generic)

instance FromJSON CardRequest -- Desde JSON