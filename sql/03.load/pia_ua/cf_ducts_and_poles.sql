insert into pia_ua.cf_ducts_and_poles
(
  "objectid"                    ,
  "orreferenceid"               ,
  "customer_name"               ,
  "CP_OBJ"                      ,
  "CP_OBJ_live"                 ,
  "CP_OBJ_can"                  ,
  "whereabouts_count"           ,
  "Count_leadin"                ,
  "NA_count"                    ,
  "MEASURED_LENGTH"             ,  -- supports values like 38.30697681
  "exchange_1141_code"          ,
  "type_name"                   ,
  "shape"                       ,           -- WKT: LINESTRING or POINT
  "bt_address_desc"             ,
  "customer_reference"          ,
  "start_dt"                    ,
  "finish_dt"                   ,
  "extension_count"             ,
  "cancellation_reason"         ,
  "noi_source"                  ,
  "noi_cp_created_by_email"     ,
  "noi_cp_created_by_last_name" ,
  "noi_cp_created_by_first_name" 
)
select
"objectid"                    ,
  "orreferenceid"               ,
  "customer_name"               ,
  "CP_OBJ"                      ,
  "CP_OBJ_live"                 ,
  "CP_OBJ_can"                  ,
  "whereabouts_count"           ,
  "Count_leadin"                ,
  "NA_count"                    ,
  "MEASURED_LENGTH"             ,  -- supports values like 38.30697681
  "exchange_1141_code"          ,
  "type_name"                   ,
  "shape"                       ,           -- WKT: LINESTRING or POINT
  "bt_address_desc"             ,
  "customer_reference"          ,
  "start_dt"                    ,
  "finish_dt"                   ,
  "extension_count"             ,
  "cancellation_reason"         ,
  "noi_source"                  ,
  "noi_cp_created_by_email"     ,
  "noi_cp_created_by_last_name" ,
  "noi_cp_created_by_first_name" 
from pia_raw.cf_ducts_and_poles ;

UPDATE pia_ua.cf_ducts_and_poles
SET geom = ST_SetSRID(ST_GeomFromText("shape"), 27700)
WHERE "shape" ~* '^(POINT|LINESTRING)\s*\(';

CREATE INDEX IF NOT EXISTS idx_cfdp_geom_gist     ON pia_ua.cf_ducts_and_poles USING GIST (geom);