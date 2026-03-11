{-# LANGUAGE DeriveGeneric #-}

module Types.Requests where

import Data.Aeson (FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

import Types.Product (ProductId)

newtype DiscountRequest = DiscountRequest
  { requestedDiscount :: Int
  } deriving (Show, Generic)

instance FromJSON DiscountRequest

data AddToCartRequest = AddToCartRequest
  { addProductId :: ProductId
  , addQuantity  :: Int
  } deriving (Show, Generic)

instance FromJSON AddToCartRequest

newtype RemoveFromCartRequest = RemoveFromCartRequest
  { removeProductId :: ProductId
  } deriving (Show, Generic)

instance FromJSON RemoveFromCartRequest

newtype CardRequest = CardRequest
  { cardNumber :: Text
  } deriving (Show, Generic)

instance FromJSON CardRequest