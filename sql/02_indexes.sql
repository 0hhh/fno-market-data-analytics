-- F&O Market Data — Indexes
-- Database: fno_db
-- Run after 01_create_tables.sql

-- trade_date: most queries filter by date range
-- BRIN on trade_date:  data is naturally datetime-ordered so BRIN is effective
CREATE INDEX idx_trade_date ON trades USING BRIN (trade_date);

-- symbol lookups — used in every query
CREATE INDEX idx_symbol ON instruments (symbol);

-- exchange filtering — used in joins of many queries
CREATE INDEX idx_exchange ON instruments (exchange_id);

-- expiry_dt — used in option chain and volatility queries
CREATE INDEX idx_expiry ON expiries (expiry_dt);

-- composite index covers the most common pattern — filter by instrument n date
CREATE INDEX idx_trades_instrument_date ON trades (instrument_id, trade_date);
