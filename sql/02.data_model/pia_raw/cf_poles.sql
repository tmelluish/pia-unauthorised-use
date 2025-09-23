-- Create table (quotes preserve your exact header names)
CREATE TABLE IF NOT EXISTS pia_raw.cf_poles (
  "objectid"                        INTEGER,
  "orreferenceid"                   TEXT NOT NULL,
  "customer_name"                   TEXT,
  "CP_OBJ"                          TEXT,
  "CP_OBJ_live"                     TEXT,
  "CP_OBJ_can"                      TEXT,
  "whereabouts_count"               INTEGER,
  "Count_leadin"                    INTEGER,
  "NA_count"                        INTEGER,
  "exchange_1141_code"              TEXT,
  "type_name"                       TEXT,
  "shape"                           TEXT,            -- WKT POINT
  "bt_address_desc"                 TEXT,
  "customer_reference"              TEXT,
  "start_dt"                        TEXT,
  "finish_dt"                       TEXT,
  "extension_count"                 INTEGER,
  "cancellation_reason"             TEXT,
  "noi_source"                      TEXT,
  "noi_cp_created_by_email"         TEXT,
  "noi_cp_created_by_last_name"     TEXT,
  "noi_cp_created_by_first_name"    TEXT

  -- Optional geometry column (coords look like British National Grid: EPSG:27700)
  --geom geometry(Point,27700)
);
