-- query 2- 7-day rolling volatility for NIFTY options
-- STDDEV over a 7-row window measures short-term price dispersion
-- Useful for spotting periods of high uncertainty around expiry

SELECT
    t.trade_date,
    ex.option_typ,
    t.close,
    ROUND(
        STDDEV(t.close) OVER (
            ORDER BY t.trade_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        )::NUMERIC, 2
    ) AS rolling_7days_volatility
FROM trades t
JOIN instruments i  ON t.instrument_id = i.instrument_id
JOIN expiries  ex ON t.expiry_id = ex.expiry_id
WHERE i.symbol  = 'NIFTY'
  AND i.instrument_type = 'OPTIDX'
  AND ex.option_typ  IN ('CE','PE')
ORDER BY t.trade_date;
