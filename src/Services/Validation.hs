{-# LANGUAGE OverloadedStrings #-}

module Services.Validation (validateCardNumber) where

import Data.Char (isDigit)
import Data.Text (Text)
import qualified Data.Text as Text

import Types.Card (CardValidationResult(..))

validateCardNumber :: Text -> CardValidationResult
validateCardNumber raw
  | Text.null cleaned = CardValidationResult { cardIsValid = False, cardReason = "cardNumber is empty" }
  | not allDigits     = CardValidationResult { cardIsValid = False, cardReason = "cardNumber must contain only digits (spaces and dashes are allowed)" }
  | not validLength   = CardValidationResult { cardIsValid = False, cardReason = "cardNumber length must be between 13 and 19" }
  | otherwise         = CardValidationResult { cardIsValid = True, cardReason = "ok" }
  where
    cleaned     = Text.filter (\character -> character /= ' ' && character /= '-') raw
    allDigits   = Text.all isDigit cleaned
    validLength = let len = Text.length cleaned in len >= 13 && len <= 19