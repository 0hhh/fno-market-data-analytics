-- F&O NSE Market Data — Table Definitions
-- Database: fno_db (PostgreSQL 17)

DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS expiries;
DROP TABLE IF EXISTS instruments;
DROP TABLE IF EXISTS exchanges;


-- exchanges- lookup table for exchange identifiers
CREATE TABLE exchanges (
    exchange_id   SERIAL PRIMARY KEY,
    exchange_name VARCHAR(10) NOT NULL UNIQUE
);

-- raw data is all NSE; BSE and MCX added for multi-exchange support
INSERT INTO exchanges (exchange_name) VALUES ('NSE'), ('BSE'), ('MCX');


-- instruments
CREATE TABLE instruments (
    instrument_id   SERIAL PRIMARY KEY,
    exchange_id     INT         NOT NULL,
    symbol          VARCHAR(30) NOT NULL,
    instrument_type VARCHAR(10) NOT NULL,
    FOREIGN KEY (exchange_id) REFERENCES exchanges(exchange_id),
    UNIQUE (exchange_id, symbol, instrument_type)
);


-- expiries- expiry date + strike + option type combinations
CREATE TABLE expiries (
    expiry_id  SERIAL PRIMARY KEY,
    expiry_dt  DATE          NOT NULL,
    strike_pr  NUMERIC(12,2) NOT NULL DEFAULT 0,
    option_typ VARCHAR(5)    NOT NULL DEFAULT 'XX',
    UNIQUE (expiry_dt, strike_pr, option_typ)
);


-- trades (main fact table)
-- partitioned by trade_date for fast time-series queries
CREATE TABLE trades (
    trade_id      BIGSERIAL,
    instrument_id INT           NOT NULL,
    expiry_id     INT           NOT NULL,
    trade_date    DATE          NOT NULL,
    open          NUMERIC(12,2),
    high          NUMERIC(12,2),
    low           NUMERIC(12,2),
    close         NUMERIC(12,2),
    settle_pr     NUMERIC(12,2),
    contracts     INT,
    val_inlakh    NUMERIC(16,2),
    open_int      BIGINT,
    chg_in_oi     BIGINT,
    FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id),
    FOREIGN KEY (expiry_id)     REFERENCES expiries(expiry_id),
    PRIMARY KEY (trade_id, trade_date)
) PARTITION BY RANGE (trade_date);

-- quarterly partitions
CREATE TABLE trades_2019_q3 PARTITION OF trades
    FOR VALUES FROM ('2019-07-01') TO ('2019-10-01');

CREATE TABLE trades_2019_q4 PARTITION OF trades
    FOR VALUES FROM ('2019-10-01') TO ('2020-01-01');

-- catch-all for any rows outside the defined range
CREATE TABLE trades_default PARTITION OF trades DEFAULT;
