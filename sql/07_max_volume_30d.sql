-- Query 5: Max contracts per symbol in the last 30 days
-- RANK() window function picks the highest volume day per symbol

WITH recent_trades AS (
    SELECT
        t.trade_date,
        i.symbol,
        t.contracts,
        RANK() OVER (
            PARTITION BY i.symbol
            ORDER BY t.contracts DESC
        ) AS volume_rank
    FROM trades t
    JOIN instruments i ON t.instrument_id = i.instrument_id
    WHERE t.trade_date >= (SELECT MAX(trade_date) FROM trades) - INTERVAL '30 days'
)

SELECT
    symbol,
    trade_date,
    contracts AS max_contracts
FROM recent_trades
WHERE volume_rank = 1
ORDER BY max_contracts DESC;
