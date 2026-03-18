{-# LANGUAGE OverloadedStrings #-} -- Permite usar Text

module Routes.Customers (customerRoutes) where -- Exporta rutas clientes

import qualified Data.Map.Strict as Map -- Mapas
import Web.Scotty ( get, json, ScottyM ) -- Funciones web

import Services.State ( AppState(customers) ) -- Acceso a clientes

customerRoutes :: AppState -> ScottyM ()
customerRoutes appState =
  get "/customers" $ -- Endpoint GET /customers
    json (Map.elems (customers appState)) -- Devuelve lista de clientes