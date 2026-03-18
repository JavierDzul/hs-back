{-# LANGUAGE DeriveGeneric #-} -- Permite usar Generic

module Types.Customer where -- Define tipo cliente

import Data.Aeson (ToJSON) -- Para JSON
import Data.Text (Text) -- Tipo Text
import GHC.Generics (Generic) -- Soporte Generic

type CustomerId = Int -- Alias para ID cliente

-- Estructura de cliente
data Customer = Customer
  { customerId   :: CustomerId -- ID
  , customerName :: Text -- Nombre
  } deriving (Show, Generic)

instance ToJSON Customer -- Convertible a JSON