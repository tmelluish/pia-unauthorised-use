-- Create table
DROP TABLE IF EXISTS pia_ua.or_invoice ;

CREATE TABLE IF NOT EXISTS pia_ua.or_invoice (
  or_invoice_id BIGSERIAL PRIMARY KEY,

  "Charge type"           TEXT,
  "Product details"       TEXT,
  "Column1"               TEXT,
  "NOI"                   TEXT,
  "Type"                  TEXT,
  "number"                INTEGER,
  -- Keep as TEXT to preserve YYYYMMDD as-is
  "Column25"              TEXT,
  "Column26"              TEXT,
  "Column2"               TEXT,
  "Column3"               TEXT,
  "OR ref"                TEXT,
  "CF ref"                TEXT,
  "Column4"               TEXT,
  -- numeric-like fields (nullable)
  "Quantity"              NUMERIC,
  "Meterage"              NUMERIC,
  "price per unit (p)"    NUMERIC,
  "cost (p)"              NUMERIC,
  "Column5"               TEXT,
  "Column6"               TEXT,
  "OPIA ref"              TEXT,
  "Column21"              TEXT,
  "Column22"              TEXT,
  "Column23"              TEXT,
  "Column24"              TEXT
);