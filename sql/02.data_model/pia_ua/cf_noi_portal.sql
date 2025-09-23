DROP TABLE IF EXISTS pia_ua.cf_noi_portal ;

CREATE TABLE IF NOT EXISTS pia_ua.cf_noi_portal (
  --cf_noi_portal_id BIGSERIAL PRIMARY KEY,

  "Ref No"                             TEXT,
  "NOI ID"                             TEXT,
  "PIANOI Ref"                         TEXT,
  "City"                               TEXT,
  "FEx/PN"                             TEXT,
  "NOI Status"                         TEXT,
  "Last Automation Status Change"      TEXT,
  "NOI Start Date"                     TEXT,
  "NOI Expiry Date"                    TEXT,
  "NOI Automation Type"                TEXT,
  "NOI Automation Status"              TEXT,
  "CP Reference"                       TEXT,
  "Workflow"                           TEXT,
  "Region"                             TEXT,
  "Raised By"                          TEXT,
  "NOI Extension Count"                INTEGER,
  "Primary/Additional"                 TEXT,
  "DR Status"                          TEXT,
  "Build Complete Status"              TEXT,
  "Build Complete Submission Date"     TEXT,
  "Build Complete Raised By"           TEXT,
  "Build Complete Sabor Ref"           TEXT,
  "Build Complete Acceptance Date"     TEXT
);