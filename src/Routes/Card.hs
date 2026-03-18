{-# LANGUAGE OverloadedStrings #-} -- Strings como Text

module Routes.Card (cardRoutes) where -- Exporta rutas

import Web.Scotty -- Scotty
import Types.Requests (CardRequest(..)) -- Request de tarjeta
import Services.Validation (validateCardNumber) -- Validador

cardRoutes :: ScottyM () -- Define rutas
cardRoutes =
  post "/validate-card" $ do -- Endpoint POST /validate-card
    CardRequest number <- jsonData -- Lee número desde JSON
    json (validateCardNumber number) -- Responde validación  y da resultado