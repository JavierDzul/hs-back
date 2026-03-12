module Services.Routes (allRoutes) where

import Web.Scotty (ScottyM)

import Services.State (AppState)
import Routes.Customers (customerRoutes)
import Routes.Products (productRoutes)
import Routes.Cart (cartRoutes)
import Routes.Card (cardRoutes)
import Routes.Payment (paymentRoutes)


allRoutes :: AppState -> ScottyM ()
allRoutes appState = do
  customerRoutes appState
  productRoutes appState
  cartRoutes appState
  cardRoutes
  paymentRoutes appState