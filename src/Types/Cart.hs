{-# LANGUAGE DeriveGeneric #-}

module Types.Cart where

import Data.Aeson (ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

import Types.Customer (CustomerId)
import Types.Product (ProductId)

data CartLine = CartLine
  { lineProductId       :: ProductId
  , lineProductName     :: Text
  , linePriceInCents    :: Int
  , lineDiscountPercent :: Int
  , lineQuantity        :: Int
  , lineSubtotalInCents :: Int
  , lineDiscountInCents :: Int
  , lineTotalInCents    :: Int
  } deriving (Show, Generic)

instance ToJSON CartLine

data CartView = CartView
  { cartCustomerId       :: CustomerId
  , cartItems            :: [CartLine]
  , cartSubtotalInCents  :: Int
  , cartDiscountInCents  :: Int
  , cartTotalInCents     :: Int
  } deriving (Show, Generic)

instance ToJSON CartView