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
from pia_raw.cf_ducts ;

UPDATE pia_ua.cf_ducts
SET geom = ST_SetSRID(ST_GeomFromText("shape"), 27700)
WHERE "shape" IS NOT NULL
  AND "shape" ILIKE 'LINESTRING%';