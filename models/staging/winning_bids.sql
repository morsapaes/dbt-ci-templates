{{ config(materialized='view', indexes=[{'columns': 'buyer'}, {'columns': 'seller'}]) }}

SELECT DISTINCT ON
  (auctions.id) bids.*,
  auctions.item,
  auctions.seller
FROM {{ source('auction','auctions') }} auctions
JOIN {{ source('auction','bids') }} bids ON auctions.id = bids.auction_id
WHERE bids.bid_time < auctions.end_time
  AND mz_now() >= auctions.end_time