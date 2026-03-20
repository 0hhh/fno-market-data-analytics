-- Query 3: Cross-exchange comparison of average settle price
-- Groups by exchange and instrument type to compare pricing across markets
-- Current dataset is all NSE — BSE rows will appear once that data is ingested

SELECT
    e.exchange_name,
    i.instrument_type ,
    ROUND( AVG(t.settle_pr)::NUMERIC, 2) AS avg_settle_price,
    COUNT(*)  AS total_records
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
JOIN exchanges e ON i.exchange_id   = e.exchange_id
WHERE t.settle_pr>0
GROUP BY e.exchange_name, i.instrument_type
ORDER BY e.exchange_name, i.instrument_type;
