module Main where

import Web.Scotty (scotty)        -- Framework web
import Services.State (initState) -- Inicializa el estado
import Services.Routes (allRoutes) -- Define las rutas

main :: IO ()
main = do
  state <- initState             -- Crea el estado de la app
  scotty 3000 (allRoutes state)  -- Inicia servidor en puerto 3000 con las rutas