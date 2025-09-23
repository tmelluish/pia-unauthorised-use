DROP TABLE IF EXISTS pia_raw.cf_ducts_and_poles ;

CREATE TABLE IF NOT EXISTS pia_raw.cf_ducts_and_poles (
  "objectid"                    INTEGER PRIMARY KEY,
  "orreferenceid"               TEXT NOT NULL,
  "customer_name"               TEXT,
  "CP_OBJ"                      TEXT,
  "CP_OBJ_live"                 TEXT,
  "CP_OBJ_can"                  TEXT,
  "whereabouts_count"           INTEGER,
  "Count_leadin"                INTEGER,
  "NA_count"                    INTEGER,
  "MEASURED_LENGTH"             NUMERIC(18,8),  -- supports values like 38.30697681
  "exchange_1141_code"          TEXT,
  "type_name"                   TEXT,
  "shape"                       TEXT,           -- WKT: LINESTRING or POINT
  "bt_address_desc"             TEXT,
  "customer_reference"          TEXT,
  "start_dt"                    DATE,
  "finish_dt"                   DATE,
  "extension_count"             INTEGER,
  "cancellation_reason"         TEXT,
  "noi_source"                  TEXT,
  "noi_cp_created_by_email"     TEXT,
  "noi_cp_created_by_last_name" TEXT,
  "noi_cp_created_by_first_name" TEXT--,

  -- Optional generic geometry column to accommodate both Lines & Points (BNG guessed)
  --geom geometry(Geometry,27700)
);