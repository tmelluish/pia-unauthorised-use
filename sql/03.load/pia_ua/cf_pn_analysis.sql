insert into pia_ua.cf_pn_analysis
(
    "Region"                                   ,
  "Zone"                                     ,
  "Location"                                 ,
  "PN"                                       ,
  "SF DR"                                    ,
  "DepotNet Status"                          ,
  "FFN/BDUK"                                 ,
  "DR0 Year"                                 ,

  -- Money/flags kept as TEXT to preserve symbols/formatting
  "Actual Cost (Tableau CAPEX Report)"       ,
  "Additional CE's (Tableau CAPEX Report)"   ,
  "Total Spend (Tableau CAPEX Report)"       ,
  "Assumed BUILD Spend?"                     ,
  "DR10 Spend from SOR Code Report (Tableau)" ,
  "BUILD Spend from SOR Code Report (Tableau)" ,
  "Total Spend from SOR Code Report (Tableau)" ,
  "DR10 Spend on SOR Report?"                ,
  "Build Spend on SOR Report?"               ,
  "PIA Spend on SOR Report?"                 ,
  "Total PIA Spend to date (£)"              ,

  -- Dates now stored as TEXT
  "DR0 Date"                                 ,
  "As-Builts missing?"                       
)
select
"Region"                                   ,
  "Zone"                                     ,
  "Location"                                 ,
  "PN"                                       ,
  "SF DR"                                    ,
  "DepotNet Status"                          ,
  "FFN/BDUK"                                 ,
  "DR0 Year"                                 ,

  -- Money/flags kept as TEXT to preserve symbols/formatting
  "Actual Cost (Tableau CAPEX Report)"       ,
  "Additional CE's (Tableau CAPEX Report)"   ,
  "Total Spend (Tableau CAPEX Report)"       ,
  "Assumed BUILD Spend?"                     ,
  "DR10 Spend from SOR Code Report (Tableau)" ,
  "BUILD Spend from SOR Code Report (Tableau)" ,
  "Total Spend from SOR Code Report (Tableau)" ,
  "DR10 Spend on SOR Report?"                ,
  "Build Spend on SOR Report?"               ,
  "PIA Spend on SOR Report?"                 ,
  "Total PIA Spend to date (£)"              ,

  -- Dates now stored as TEXT
  "DR0 Date"                                 ,
  "As-Builts missing?"                       

from pia_raw.cf_pn_analysis ;
