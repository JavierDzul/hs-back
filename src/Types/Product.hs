{-# LANGUAGE DeriveGeneric #-}

module Types.Product where

import Data.Aeson (ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

type ProductId = Int

data Product = Product
  { productId       :: ProductId
  , productName     :: Text
  , priceInCents    :: Int
  , discountPercent :: Int
  } deriving (Show, Generic)

instance ToJSON Product