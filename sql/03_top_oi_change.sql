-- Query 1: Top 10 symbols by OI change across exchanges
-- Shows which symbols had the highest net position buildup
-- Joining exchanges to support multi-exchange filtering

SELECT
    e.exchange_name,
    i.symbol,
    i.instrument_type,
    SUM(t.chg_in_oi) AS total_oi_change
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
JOIN exchanges   e ON i.exchange_id   = e.exchange_id
GROUP BY e.exchange_name, i.symbol, i.instrument_type
ORDER BY total_oi_change DESC
LIMIT 10;
