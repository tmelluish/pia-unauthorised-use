DROP TABLE IF EXISTS pia_ua.cf_ducts;
CREATE TABLE pia_ua.cf_ducts (
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
  "start_dt"                   DATE,
  "finish_dt"                  DATE,
  "extension_count"            INTEGER,
  "cancellation_reason"        TEXT,
  "noi_source"                 TEXT,
  "noi_cp_created_by_email"    TEXT,
  "noi_cp_created_by_last_name"   TEXT,
  "noi_cp_created_by_first_name"  TEXT,

  -- Optional geometry column (British National Grid; EPSG:27700 guessed from your coords)
  -- If you don't have PostGIS, drop this column.
  geom geometry(LineString,27700)
);

insert into pia_ua.cf_ducts
(
  "objectid"                   ,
  "orreferenceid"              ,
  "customer_name"              ,
  "CP_OBJ"                     ,
  "CP_OBJ_live"                ,
  "CP_OBJ_can"                 ,
  "whereabouts_count"          ,
  "Count_leadin"               ,
  "NA_count"                   ,
  "MEASURED_LENGTH"            ,
  "exchange_1141_code"         ,
  "type_name"                  ,
  "shape"                      ,             -- WKT LINESTRING as provided
  "customer_reference"         ,
  "start_dt"                   ,
  "finish_dt"                  ,
  "extension_count"            ,
  "cancellation_reason"        ,
  "noi_source"                 ,
  "noi_cp_created_by_email"    ,
  "noi_cp_created_by_last_name",
  "noi_cp_created_by_first_name"     
)
select 
    "objectid"                   ,
  "orreferenceid"              ,
  "customer_name"              ,
  "CP_OBJ"                     ,
  "CP_OBJ_live"                ,
  "CP_OBJ_can"                 ,
  "whereabouts_count"          ,
  "Count_leadin"               ,
  "NA_count"                   ,
  "MEASURED_LENGTH"            ,
  "exchange_1141_code"         ,
  "type_name"                  ,
  "shape"                      ,             -- WKT LINESTRING as provided
  "customer_reference"         ,
  "start_dt"                   ,
  "finish_dt"                  ,
  "extension_count"            ,
  "cancellation_reason"        ,
  "noi_source"                 ,
  "noi_cp_created_by_email"    ,
  "noi_cp_created_by_last_name"   ,
  "noi_cp_created_by_first_name"
from raw_ua.cf_ducts ;

UPDATE public.noi_data
SET geom = ST_SetSRID(ST_GeomFromText("shape"), 27700)
WHERE "shape" IS NOT NULL
  AND "shape" ILIKE 'LINESTRING%';