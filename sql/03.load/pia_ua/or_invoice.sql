
insert into pia_ua.or_invoice (
  
  "Charge type" ,
  "Product details",
  "Column1"        ,
  "NOI"            ,
  "Type"           ,
  "number"         ,
  -- Keep as TEXT to preserve YYYYMMDD as-is
  "Column25"       ,
  "Column26"       ,
  "Column2"        ,
  "Column3"        ,
  "OR ref"         ,
  "CF ref"         ,
  "Column4"        ,
  -- numeric-like fields (nullable)
  "Quantity"       ,
  "Meterage"       ,
  "price per unit (p)",
  "cost (p)"          ,
  "Column5"           ,
  "Column6"           ,
  "OPIA ref"          ,
  "Column21"          ,
  "Column22"          ,
  "Column23"          ,
  "Column24"          
)
select

  "Charge type" ,
  "Product details",
  "Column1"        ,
  "NOI"            ,
  "Type"           ,
  "number"         ,
  -- Keep as TEXT to preserve YYYYMMDD as-is
  "Column25"       ,
  "Column26"       ,
  "Column2"        ,
  "Column3"        ,
  "OR ref"         ,
  "CF ref"         ,
  "Column4"        ,
  -- numeric-like fields (nullable)
  "Quantity"       ,
  "Meterage"       ,
  "price per unit (p)",
  "cost (p)"          ,
  "Column5"           ,
  "Column6"           ,
  "OPIA ref"          ,
  "Column21"          ,
  "Column22"          ,
  "Column23"          ,
  "Column24"
from pia_raw.or_invoice ;

create INDEX IF NOT EXISTS idx_or_invoice_noi ON pia_ua.or_invoice ("NOI");