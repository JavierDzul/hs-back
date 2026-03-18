{-# LANGUAGE DeriveGeneric #-} -- Permite usar Generic

module Types.Card
  ( CardValidationResult(..) -- Exporta el tipo
  ) where

import Data.Aeson (ToJSON) -- Para convertir a JSON
import Data.Text (Text) -- Tipo Text
import GHC.Generics (Generic) -- Soporte para Generic

-- Resultado de validación de tarjeta
data CardValidationResult = CardValidationResult
  { cardIsValid :: Bool -- Indica si es válida
  , cardReason  :: Text -- Mensaje de resultado
  } deriving (Show, Generic)

instance ToJSON CardValidationResult -- Permite devolverlo como JSON