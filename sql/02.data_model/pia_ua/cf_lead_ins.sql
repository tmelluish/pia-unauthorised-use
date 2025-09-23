DROP TABLE IF EXISTS pia_ua.cf_lead_ins ;
CREATE TABLE IF NOT EXISTS pia_ua.cf_lead_ins (
  "Reserved elseware Check"        INTEGER,
  "Concat"                         TEXT,
  "CP"                             TEXT,
  "LEADINATTACHMENTID"             TEXT,      -- keep TEXT (mix of ids and opaque strings)
  "PIANOI REF"                     TEXT,
  "UPRN"                           TEXT,      -- TEXT to avoid Excel sci-notation/leading-zero issues
  "OBJECTIDSTARTINGSTRUCTURE"      INTEGER,
  "UGOROH"                         TEXT,      -- e.g., 'UG'/'OH'
  "QUANTITY"                       INTEGER,
  "POLETBCINVOKED"                 TEXT,      -- 'Y'/'N' as provided
  "ROUTEID"                        INTEGER,
  "EFFECTIVE_DT"                   TIMESTAMP WITHOUT TIME ZONE,
  "SHAPE"                          TEXT,      -- WKT POINT
  "MODIFIED_DT"                    TIMESTAMP WITHOUT TIME ZONE,
  "ACTION"                         TEXT,      -- e.g., 'I'
  "CREATED_DT"                     DATE,
  "LAST_UPDATE_DT"                 TIMESTAMP WITHOUT TIME ZONE,
  "REQUESTSOURCE"                  TEXT,
  "Effcet till created Lag Time"   NUMERIC(14,4),
  "NOI Status"                     TEXT,

  -- Optional geometry column (British National Grid guessed)
  geom geometry(Point,27700)
);
