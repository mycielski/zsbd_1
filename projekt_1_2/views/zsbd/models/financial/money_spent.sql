WITH sales AS (
  SELECT
    card_id,
    sum(cost) AS total
  FROM {{ source("eltrans", "sale") }}
  GROUP BY card_id
),

driver_spendings AS (
  SELECT
    c.owner_id AS driver_id,
    sum(s.total) AS total
  FROM card AS c
  INNER JOIN sales AS s ON c.id = s.card_id
  GROUP BY driver_id
),

named_spending AS (
  SELECT
    d.first_name,
    d.last_name,
    d.id AS driver_id,
    ds.total AS total_spending
  FROM {{ source("eltrans", "driver") }} AS d
  INNER JOIN driver_spendings AS ds ON d.id = ds.driver_id
)

SELECT * FROM named_spending
