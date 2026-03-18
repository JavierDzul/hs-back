module Services.Cart (buildCartView) where -- Exporta función principal

import qualified Data.Map.Strict as Map -- Mapas

import Types.Customer (CustomerId) -- ID cliente
import Types.Product
    ( Product(discountPercent, productId, productName, priceInCents),
      ProductId ) -- Producto e ID
import Types.Cart ( CartView(..), CartLine(..) ) -- Tipos del carrito

-- Construye la vista del carrito
buildCartView :: CustomerId -> Map.Map ProductId Product -> Map.Map ProductId Int -> CartView
buildCartView cid productMap cartMap =
  let 
      -- Genera líneas del carrito
      cartLines = [ toCartLine prod qty
                  | (pid, qty) <- Map.toList cartMap -- Recorre carrito
                  , qty > 0                         -- Solo cantidades > 0
                  , Just prod <- [Map.lookup pid productMap] -- Busca producto
                  ]

      subtotal  = sum (map lineSubtotalInCents cartLines) -- Suma subtotales
      discount  = sum (map lineDiscountInCents cartLines) -- Suma descuentos
      total     = sum (map lineTotalInCents cartLines)    -- Suma totales

  in CartView 
      { cartCustomerId = cid
      , cartItems = cartLines
      , cartSubtotalInCents = subtotal
      , cartDiscountInCents = discount
      , cartTotalInCents = total
      }

-- Convierte producto + cantidad en línea de carrito
toCartLine :: Product -> Int -> CartLine
toCartLine prod qty =
  let 
      subtotal = priceInCents prod * qty -- Precio total sin descuento
      discount = (subtotal * discountPercent prod) `div` 100 -- Descuento

  in CartLine
    { lineProductId       = productId prod
    , lineProductName     = productName prod
    , linePriceInCents    = priceInCents prod
    , lineDiscountPercent = discountPercent prod
    , lineQuantity        = qty
    , lineSubtotalInCents = subtotal
    , lineDiscountInCents = discount
    , lineTotalInCents    = subtotal - discount -- Total final
    }