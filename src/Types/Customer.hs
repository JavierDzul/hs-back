{-# LANGUAGE DeriveGeneric #-}

module Types.Customer where

import Data.Aeson (ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

type CustomerId = Int

data Customer = Customer
  { customerId   :: CustomerId
  , customerName :: Text
  } deriving (Show, Generic)

instance ToJSON Customer