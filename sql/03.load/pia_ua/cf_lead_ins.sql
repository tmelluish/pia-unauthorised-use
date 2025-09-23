insert into pia_ua.cf_lead_ins
(
  "Reserved elseware Check"        ,
  "Concat"                         ,
  "CP"                             ,
  "LEADINATTACHMENTID"             ,      -- keep TEXT (mix of ids and opaque strings)
  "PIANOI REF"                     ,
  "UPRN"                           ,      -- TEXT to avoid Excel sci-notation/leading-zero issues
  "OBJECTIDSTARTINGSTRUCTURE"      ,
  "UGOROH"                         ,      -- e.g., 'UG'/'OH'
  "QUANTITY"                       ,
  "POLETBCINVOKED"                 ,      -- 'Y'/'N' as provided
  "ROUTEID"                        ,
  "EFFECTIVE_DT"                   ,
  "SHAPE"                          ,      -- WKT POINT
  "MODIFIED_DT"                    ,
  "ACTION"                         ,      -- e.g., 'I'
  "CREATED_DT"                     ,
  "LAST_UPDATE_DT"                 ,
  "REQUESTSOURCE"                  ,
  "Effcet till created Lag Time"   ,
  "NOI Status"                     
)
select
  "Reserved elseware Check"        ,
  "Concat"                         ,
  "CP"                             ,
  "LEADINATTACHMENTID"             ,      -- keep TEXT (mix of ids and opaque strings)
  "PIANOI REF"                     ,
  "UPRN"                           ,      -- TEXT to avoid Excel sci-notation/leading-zero issues
  "OBJECTIDSTARTINGSTRUCTURE"      ,
  "UGOROH"                         ,      -- e.g., 'UG'/'OH'
  "QUANTITY"                       ,
  "POLETBCINVOKED"                 ,      -- 'Y'/'N' as provided
  "ROUTEID"                        ,
  "EFFECTIVE_DT"                   ,
  "SHAPE"                          ,      -- WKT POINT
  "MODIFIED_DT"                    ,
  "ACTION"                         ,      -- e.g., 'I'
  "CREATED_DT"                     ,
  "LAST_UPDATE_DT"                 ,
  "REQUESTSOURCE"                  ,
  "Effcet till created Lag Time"   ,
  "NOI Status"
from pia_raw.cf_lead_ins ;

-- populate geometry
UPDATE pia_ua.cf_lead_ins
SET geom = ST_SetSRID(ST_GeomFromText("SHAPE"), 27700)
WHERE "SHAPE" IS NOT NULL
  AND "SHAPE" ILIKE 'POINT%';

CREATE INDEX IF NOT EXISTS idx_pia_ua_cf_leadin_geom_gist ON pia_ua.cf_lead_ins USING GIST (geom);