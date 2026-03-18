{-# LANGUAGE DeriveGeneric #-} -- Permite usar Generic
{-# LANGUAGE OverloadedStrings #-} -- Permite usar Text

module Types.Payment where -- Tipos de pago

import Data.Aeson (ToJSON, FromJSON) -- JSON
import Data.Text (Text) -- Tipo Text
import GHC.Generics (Generic) -- Soporte Generic

import Types.Customer (CustomerId) -- ID cliente

-- Request de pago
data PaymentRequest = PaymentRequest
  { paymentCustomerId :: CustomerId -- ID cliente
  , paymentCardNumber :: Text -- Número tarjeta
  } deriving (Show, Generic)

instance FromJSON PaymentRequest -- Desde JSON

-- Resultado de pago
data PaymentResult = PaymentResult
  { paymentSuccess :: Bool -- Éxito
  , paymentMessage :: Text -- Mensaje
  , paymentTotalInCents :: Int -- Total pagado
  } deriving (Show, Generic)

instance ToJSON PaymentResult -- A JSON