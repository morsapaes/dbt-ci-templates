{{ config(materialized='view') }}

SELECT
  id,
  SUM(credits) as credits,
  SUM(debits) as debits
FROM (
  SELECT seller as id, amount as credits, 0 as debits
  FROM {{ ref('winning_bids') }}
  UNION ALL
  SELECT buyer as id, 0 as credits, amount as debits
  FROM {{ ref('winning_bids') }}
)
GROUP BY id