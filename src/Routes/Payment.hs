{-# LANGUAGE OverloadedStrings #-}

module Routes.Payment (paymentRoutes) where

import qualified Data.Map.Strict as Map
import Web.Scotty

import Types.Payment
    ( PaymentResult(PaymentResult, paymentTotalInCents, paymentSuccess,
                    paymentMessage),
      PaymentRequest(PaymentRequest) )
import Types.Card (CardValidationResult(..))
import Types.Cart (CartView(..))
import Services.State
    ( AppState, requireCustomer, readProducts, readCart, writeCart )
import Services.Cart (buildCartView)
import Services.Validation (validateCardNumber)

paymentRoutes :: AppState -> ScottyM ()
paymentRoutes appState =
  post "/payment" $ do
    PaymentRequest cid cardNum <- jsonData
    requireCustomer appState cid

    let cardResult = validateCardNumber cardNum
    if not (cardIsValid cardResult)
      then json (PaymentResult { paymentSuccess = False, paymentMessage = cardReason cardResult, paymentTotalInCents = 0 })
      else do
        prods <- readProducts appState
        cart  <- readCart appState cid

        if Map.null cart
          then json (PaymentResult { paymentSuccess = False, paymentMessage = "cart is empty", paymentTotalInCents = 0 })
          else do
            let view = buildCartView cid prods cart
            writeCart appState cid Map.empty
            json (PaymentResult { paymentSuccess = True, paymentMessage = "payment accepted", paymentTotalInCents = cartTotalInCents view })