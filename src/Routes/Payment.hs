{-# LANGUAGE OverloadedStrings #-} -- Permite usar Text

module Routes.Payment (paymentRoutes) where -- Exporta rutas pago

import qualified Data.Map.Strict as Map -- Mapas
import Web.Scotty -- Framework web

import Types.Payment
    ( PaymentResult(PaymentResult, paymentTotalInCents, paymentSuccess,
                    paymentMessage),
      PaymentRequest(PaymentRequest) ) -- Tipos de pago
import Types.Card (CardValidationResult(..)) -- Resultado tarjeta
import Types.Cart (CartView(..)) -- Vista carrito
import Services.State
    ( AppState, requireCustomer, readProducts, readCart, writeCart ) -- Estado
import Services.Cart (buildCartView) -- Construye carrito
import Services.Validation (validateCardNumber) -- Valida tarjeta

paymentRoutes :: AppState -> ScottyM ()
paymentRoutes appState =
  post "/payment" $ do -- Endpoint POST /payment
    PaymentRequest cid cardNum <- jsonData -- Lee request
    requireCustomer appState cid -- Valida cliente

    let cardResult = validateCardNumber cardNum -- Valida tarjeta

    if not (cardIsValid cardResult)
      then json (PaymentResult 
        { paymentSuccess = False
        , paymentMessage = cardReason cardResult
        , paymentTotalInCents = 0 }) -- Error tarjeta

      else do
        prods <- readProducts appState -- Lee productos
        cart  <- readCart appState cid -- Lee carrito

        if Map.null cart
          then json (PaymentResult 
            { paymentSuccess = False
            , paymentMessage = "cart is empty"
            , paymentTotalInCents = 0 }) -- Carrito vacío

          else do
            let view = buildCartView cid prods cart -- Calcula totales
            writeCart appState cid Map.empty -- Vacía carrito
            json (PaymentResult 
              { paymentSuccess = True
              , paymentMessage = "payment accepted"
              , paymentTotalInCents = cartTotalInCents view }) -- Pago exitoso