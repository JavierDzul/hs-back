module Services.Routes (allRoutes) where -- Exporta allRoutes

import Web.Scotty (ScottyM) -- Tipo de rutas

import Services.State (AppState) -- Estado global
import Routes.Customers (customerRoutes) -- Rutas clientes
import Routes.Products (productRoutes) -- Rutas productos
import Routes.Cart (cartRoutes) -- Rutas carrito
import Routes.Card (cardRoutes) -- Rutas tarjeta
import Routes.Payment (paymentRoutes) -- Rutas pagos

allRoutes :: AppState -> ScottyM () -- Registra rutas
allRoutes appState = do
  customerRoutes appState -- Clientes
  productRoutes appState  -- Productos
  cartRoutes appState     -- Carrito
  cardRoutes              -- Tarjeta
  paymentRoutes appState  -- Pagos