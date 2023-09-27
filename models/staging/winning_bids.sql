{{ config(materialized='view', indexes=[{'columns': 'item'}, {'columns': 'buyer'}, {'columns': 'seller'}]) }}

SELECT DISTINCT ON
  (auctions.id) bids.*,
  auctions.item,
  auctions.seller
FROM {{ source('auction','auctions') }}
JOIN {{ source('auction','bids') }} ON auctions.id = bids.auction_id
WHERE bids.bid_time < auctions.end_time
  AND mz_now() >= auctions.end_time