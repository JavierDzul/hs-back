module Services.Cart (buildCartView) where

import qualified Data.Map.Strict as Map

import Types.Customer (CustomerId)
import Types.Product
    ( Product(discountPercent, productId, productName, priceInCents),
      ProductId )
import Types.Cart ( CartView(..), CartLine(..) )

buildCartView :: CustomerId -> Map.Map ProductId Product -> Map.Map ProductId Int -> CartView
buildCartView cid productMap cartMap =
  let cartLines = [ toCartLine prod qty
                  | (pid, qty) <- Map.toList cartMap
                  , qty > 0
                  , Just prod <- [Map.lookup pid productMap]
                  ]
      subtotal  = sum (map lineSubtotalInCents cartLines)
      discount  = sum (map lineDiscountInCents cartLines)
      total     = sum (map lineTotalInCents cartLines)
  in CartView { cartCustomerId = cid, cartItems = cartLines, cartSubtotalInCents = subtotal, cartDiscountInCents = discount, cartTotalInCents = total }

toCartLine :: Product -> Int -> CartLine
toCartLine prod qty =
  let subtotal = priceInCents prod * qty
      discount = (subtotal * discountPercent prod) `div` 100
  in CartLine
    { lineProductId       = productId prod
    , lineProductName     = productName prod
    , linePriceInCents    = priceInCents prod
    , lineDiscountPercent = discountPercent prod
    , lineQuantity        = qty
    , lineSubtotalInCents = subtotal
    , lineDiscountInCents = discount
    , lineTotalInCents    = subtotal - discount
    }