DROP TABLE IF EXISTS pia_ua.pn_analysis;

CREATE TABLE IF NOT EXISTS pia_ua.pn_analysis (

  "Region"                                   TEXT,
  "Zone"                                     TEXT,
  "Location"                                 TEXT,
  "PN"                                       TEXT,
  "SF DR"                                    TEXT,
  "DepotNet Status"                          TEXT,
  "FFN/BDUK"                                 TEXT,
  "DR0 Year"                                  INTEGER,

  -- Money/flags kept as TEXT to preserve symbols/formatting
  "Actual Cost (Tableau CAPEX Report)"       TEXT,
  "Additional CE's (Tableau CAPEX Report)"   TEXT,
  "Total Spend (Tableau CAPEX Report)"       TEXT,
  "Assumed BUILD Spend?"                     TEXT,
  "DR10 Spend from SOR Code Report (Tableau)" TEXT,
  "BUILD Spend from SOR Code Report (Tableau)" TEXT,
  "Total Spend from SOR Code Report (Tableau)" TEXT,
  "DR10 Spend on SOR Report?"                TEXT,
  "Build Spend on SOR Report?"               TEXT,
  "PIA Spend on SOR Report?"                 TEXT,
  "Total PIA Spend to date (£)"              TEXT,

  -- Dates now stored as TEXT
  "DR0 Date"                                  TEXT,
  "As-Builts missing?"                       TEXT
);
