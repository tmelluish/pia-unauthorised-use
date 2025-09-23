DROP TABLE IF EXISTS pia_raw.cf_ducts;
CREATE TABLE pia_raw.cf_ducts (
  "objectid"                   INTEGER PRIMARY KEY,
  "orreferenceid"              TEXT NOT NULL,
  "customer_name"              TEXT,
  "CP_OBJ"                     TEXT,
  "CP_OBJ_live"                TEXT,
  "CP_OBJ_can"                 TEXT,
  "whereabouts_count"          INTEGER,
  "Count_leadin"               INTEGER,
  "NA_count"                   INTEGER,
  "MEASURED_LENGTH"            NUMERIC(14,2),
  "exchange_1141_code"         TEXT,
  "type_name"                  TEXT,
  "shape"                      TEXT,             -- WKT LINESTRING as provided
  "customer_reference"         TEXT,
  "start_dt"                   TEXT,
  "finish_dt"                  TEXT,
  "extension_count"            INTEGER,
  "cancellation_reason"        TEXT,
  "noi_source"                 TEXT,
  "noi_cp_created_by_email"    TEXT,
  "noi_cp_created_by_last_name"   TEXT,
  "noi_cp_created_by_first_name"  TEXT

  -- Optional geometry column (British National Grid; EPSG:27700 guessed from your coords)
  -- If you don't have PostGIS, drop this column.
  --geom geometry(LineString,27700)
);