insert into pia_ua.cf_noi_manual
(
  "PN Number Full"                       ,
  "Workflow"                             ,
  "City"                                 ,
  "FEX/FAC No."                           ,  -- keep TEXT (may be blank / non-numeric in future)
  "PN No."                                ,  -- keep TEXT for the same reason
  "Project Reference"                     ,
  "CP Ref"                                ,
  "Raised By"                             ,
  "NOI Reference (PIANOI no.)"            ,
  "Automated"                             ,  -- e.g., 'TRUE'/'FALSE'
  -- Date/time-looking fields explicitly as TEXT (per request)
  "NOI Start Date"                        ,
  "NOI Expiry Date"                       ,
  "NOI Status"                            ,
  "Primary/Additional"                    ,
  "NOI Extension Count (0/1/2)"           ,
  "Build Complete Submitted Date"         ,
  "Build Complete Raised By"              ,
  "Build Complete Sabor Ref"              ,
  "Build Complete Status"                 ,
  "Date Build Complete Accepted by OR"    ,
  "Comments"                              ,
  "Attachments"                           ,  -- contains HTML anchors
  "Modified By"                           ,
  "Modified"                              ,
  "Created"                               ,
  "Created By"                            
)
select
  "PN Number Full"                       ,
  "Workflow"                             ,
  "City"                                 ,
  "FEX/FAC No."                           ,  -- keep TEXT (may be blank / non-numeric in future)
  "PN No."                                ,  -- keep TEXT for the same reason
  "Project Reference"                     ,
  "CP Ref"                                ,
  "Raised By"                             ,
  "NOI Reference (PIANOI no.)"            ,
  "Automated"                             ,  -- e.g., 'TRUE'/'FALSE'
  -- Date/time-looking fields explicitly as TEXT (per request)
  "NOI Start Date"                        ,
  "NOI Expiry Date"                       ,
  "NOI Status"                            ,
  "Primary/Additional"                    ,
  "NOI Extension Count (0/1/2)"           ,
  "Build Complete Submitted Date"         ,
  "Build Complete Raised By"              ,
  "Build Complete Sabor Ref"              ,
  "Build Complete Status"                 ,
  "Date Build Complete Accepted by OR"    ,
  "Comments"                              ,
  "Attachments"                           ,  -- contains HTML anchors
  "Modified By"                           ,
  "Modified"                              ,
  "Created"                               
from pia_raw.cf_noi_manual ;