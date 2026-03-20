-- Query 4- Option chain summary grouped by expiry and strike
-- Shows CE and PE volume side by side per expiry and strike

SELECT
    ex.expiry_dt,
    ex.strike_pr,
    SUM(CASE WHEN ex.option_typ = 'CE' THEN t.contracts ELSE 0 END) AS ce_volume,
    SUM(CASE WHEN ex.option_typ = 'PE' THEN t.contracts ELSE 0 END) AS pe_volume,
    SUM(t.contracts)  AS total_volume,
    SUM(t.open_int)  AS total_open_interest
FROM trades t
JOIN expiries ex ON t.expiry_id = ex.expiry_id
WHERE ex.option_typ IN ('CE', 'PE')
GROUP BY ex.expiry_dt, ex.strike_pr
ORDER BY ex.expiry_dt, ex.strike_pr;
