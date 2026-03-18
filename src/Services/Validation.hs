{-# LANGUAGE OverloadedStrings #-}

module Services.Validation (validateCardNumber) where

import Data.Char (isDigit)
import Data.Text (Text)
import qualified Data.Text as Text

import Types.Card (CardValidationResult(..))

-- Valida un número de tarjeta
validateCardNumber :: Text -> CardValidationResult
validateCardNumber raw
  -- Si está vacío
  | Text.null cleaned = CardValidationResult { cardIsValid = False, cardReason = "cardNumber is empty" }
  
  -- Si contiene caracteres que no son números
  | not allDigits     = CardValidationResult { cardIsValid = False, cardReason = "cardNumber must contain only digits (spaces and dashes are allowed)" }
  
  -- Si la longitud no es válida (13 a 19 dígitos)
  | not validLength   = CardValidationResult { cardIsValid = False, cardReason = "cardNumber length must be between 13 and 19" }
  
  -- Si todo está correcto
  | otherwise         = CardValidationResult { cardIsValid = True, cardReason = "ok" }

  where
    -- Limpia espacios y guiones del número
    cleaned     = Text.filter (\character -> character /= ' ' && character /= '-') raw
    
    -- Verifica que todos sean dígitos
    allDigits   = Text.all isDigit cleaned
    
    -- Verifica longitud válida
    validLength = let len = Text.length cleaned in len >= 13 && len <= 19