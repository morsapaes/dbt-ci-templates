{{ config(materialized='view') }}

SELECT
  w2.seller,
  w2.item AS seller_item,
  w2.amount AS seller_amount,
  w1.item buyer_item,
  w1.amount buyer_amount
FROM {{ ref('dummy') }} w1
JOIN {{ ref('winning_bids') }} w2 ON w1.buyer = w2.seller
WHERE w2.amount > w1.amount