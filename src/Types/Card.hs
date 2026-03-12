{-# LANGUAGE DeriveGeneric #-}

module Types.Card
  ( CardValidationResult(..)
  ) where

import Data.Aeson (ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

data CardValidationResult = CardValidationResult
  { cardIsValid :: Bool
  , cardReason  :: Text
  } deriving (Show, Generic)

instance ToJSON CardValidationResult