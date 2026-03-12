{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Types.Payment where

import Data.Aeson (ToJSON, FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

import Types.Customer (CustomerId)

data PaymentRequest = PaymentRequest
  { paymentCustomerId :: CustomerId
  , paymentCardNumber :: Text
  } deriving (Show, Generic)

instance FromJSON PaymentRequest

data PaymentResult = PaymentResult
  { paymentSuccess :: Bool
  , paymentMessage :: Text
  , paymentTotalInCents :: Int
  } deriving (Show, Generic)

instance ToJSON PaymentResult