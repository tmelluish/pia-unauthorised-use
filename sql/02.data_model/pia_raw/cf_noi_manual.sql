-- Start fresh
DROP TABLE IF EXISTS pia_raw.cf_noi_manual;

-- Recreate table
CREATE TABLE pia_raw.cf_noi_manual (
  --cf_noi_manual_id BIGSERIAL PRIMARY KEY,

  "PN Number Full"                       TEXT,
  "Workflow"                              TEXT,
  "City"                                  TEXT,
  "FEX/FAC No."                           TEXT,  -- keep TEXT (may be blank / non-numeric in future)
  "PN No."                                TEXT,  -- keep TEXT for the same reason
  "Project Reference"                     TEXT,
  "CP Ref"                                TEXT,
  "Raised By"                             TEXT,
  "NOI Reference (PIANOI no.)"            TEXT,
  "Automated"                             TEXT,  -- e.g., 'TRUE'/'FALSE'
  -- Date/time-looking fields explicitly as TEXT (per request)
  "NOI Start Date"                        TEXT,
  "NOI Expiry Date"                       TEXT,
  "NOI Status"                            TEXT,
  "Primary/Additional"                    TEXT,
  "NOI Extension Count (0/1/2)"           INTEGER,
  "Build Complete Submitted Date"         TEXT,
  "Build Complete Raised By"              TEXT,
  "Build Complete Sabor Ref"              TEXT,
  "Build Complete Status"                 TEXT,
  "Date Build Complete Accepted by OR"    TEXT,
  "Comments"                               TEXT,
  "Attachments"                            TEXT,  -- contains HTML anchors
  "Modified By"                            TEXT,
  "Modified"                               TEXT,
  "Created"                                TEXT,
  "Created By"                             TEXT
);