{-# LANGUAGE DeriveGeneric #-} -- Permite usar Generic

module Types.Product where -- Tipos de producto

import Data.Aeson (ToJSON) -- Para JSON
import Data.Text (Text) -- Tipo Text
import GHC.Generics (Generic) -- Soporte Generic

type ProductId = Int -- Alias ID producto

-- Estructura de producto
data Product = Product
  { productId       :: ProductId -- ID
  , productName     :: Text -- Nombre
  , priceInCents    :: Int -- Precio
  , discountPercent :: Int -- % descuento
  } deriving (Show, Generic)

instance ToJSON Product -- Convertible a JSON