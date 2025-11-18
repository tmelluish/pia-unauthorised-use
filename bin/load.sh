#!/usr/bin/env bash
#
################################################################################
#        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!              #
################################################################################
#
#  This is the main worker script - it loads the data, works out what needs
#  to be connected in order to build the model, and then finds the shortest
#  paths along the road network in order to connect them
#
#  it's typically executed with calls like:
#  ./bin.sh --roads
#
#  the full set of options can be seen under the 'check arguments' comment
#  at the bottom of the file
#
################################################################################

set -o errexit
set -o pipefail
set -o nounset

################################################################################
# Logging Setting
################################################################################
readonly LOGS=${LOGS:-$(pwd)}
exec 1> >(tee -a $LOGS/$(date +'%Y%m%d').log) 2>&1

################################################################################
# Debugging settings and Setting up Variables
################################################################################
readonly _DEBUG=${_DEBUG:-"on"}
readonly ENVTYPE=${ENVTYPE:-"prod"}
readonly RUNID=${RUNID:-$(date +%Y%m%d%H%M%S)}
readonly tmpFOLDER=${tmpFOLDER:-"/tmp/pia-unauthorised-access"}

mkdir -p $tmpFOLDER

ALL=false
PUBLIC=false
RAW=false
################################################################################
# Load utility functions
################################################################################
source $PIA_PROJECTPATH/bin/utilities.sh


function loadRaw() {
    # Loads raw data from client into the raw schema
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD, DATAPATH
    # Arguments: None
    # Output: 
    # 	raw.oa_population_2011, raw.oa_to_bua, raw.scotland_settlement_population_2016, raw.ireland_settlement_population_2015

    INFO "loadRaw Started"
    DEBUG set -o verbose;


    # CF ducts
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_ducts.sql
    pgsql --command="\copy pia_raw.cf_ducts from '${PIA_DATAPATH}/cf_ducts_from_excel.csv' WITH CSV HEADER"

    # CF poles
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_poles.sql
    pgsql --command="\copy pia_raw.cf_poles from '${PIA_DATAPATH}/cf_poles_from_excel.csv' WITH CSV HEADER"

    # CF lead-ins
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_lead_ins.sql
    pgsql --command="\copy pia_raw.cf_lead_ins from '${PIA_DATAPATH}/cf_lead_ins_from_excel.csv' WITH CSV HEADER"

    # CF ducts poles combined
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_ducts_and_poles.sql
    pgsql --command="\copy pia_raw.cf_ducts_and_poles from '${PIA_DATAPATH}/cf_ducts_poles_combined_from_excel.csv' WITH CSV HEADER"

    # CF NOI requests submitted via portal
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_noi_portal.sql
    pgsql --command="\copy pia_raw.cf_noi_portal from '${PIA_DATAPATH}/NOI_CityFibre_Portal_Sunderland.csv' WITH CSV HEADER"

     # CF NOI requests submitted manually
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_noi_manual.sql
    pgsql --command="\copy pia_raw.cf_noi_manual from '${PIA_DATAPATH}/SUN_NOIs_Old_Tracker.csv' WITH CSV HEADER"

    # CF PN analysis
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/cf_pn_analysis.sql
    pgsql --command="\copy pia_raw.cf_pn_analysis from '${PIA_DATAPATH}/PN_analysis.csv' WITH CSV HEADER"
  
    # CF PN analysis
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_raw/or_invoice.sql
    pgsql --command="\copy pia_raw.or_invoice from '${PIA_DATAPATH}/cut_down_Openreach_Invoice_20250401.csv' WITH CSV HEADER"

    # INFO "Loading BDUK and Ofcom Markets"
    # pgsql --file=${PROJECTPATH}/sql/data_model/raw/bduk_f20_bins.sql
    # pgsql --command="\copy raw.bduk_f20_bins from '${DATAPATH}/bduk_f20_data.csv' WITH CSV HEADER"

    # pgsql --file=${PROJECTPATH}/sql/data_model/raw/btex_iec_market.sql
    # pgsql --command="\copy raw.btex_iec_market from '${DATAPATH}/btex_iec_market.csv' WITH CSV HEADER"
    
    # INFO "Loading BT Echange Postcodes"
    # pgsql --file=${PROJECTPATH}/sql/data_model/raw/bt_exchange_postcode.sql
    # pgsql --command="\copy raw.bt_exchange_postcode from '${DATAPATH}/bt_exchange_postcode_samknows.csv' WITH CSV HEADER"

    # INFO "parliamentary constituencies boundaries"
    # shp2pgsql -s 27700 -diI "${DATAPATH}/client_info/parliamentary_constituencies/Westminster_Parliamentary_Constituencies__December_2017__Boundaries_UK.shp" raw.constituencies | psql > /dev/null
    
    
    DEBUG set +o verbose;
    INFO "loadRaw Finished"
}



function loadPublic() {

    # ducts
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_ducts.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_ducts.sql

    # poles
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_poles.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_poles.sql

    # lead ins
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_lead_ins.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_lead_ins.sql

    # ducts and poles combined
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_ducts_and_poles.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_ducts_and_poles.sql

    # NOI requests submitted via portal
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_noi_portal.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_noi_portal.sql

    # NOI requests submitted manually
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_noi_manual.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_noi_manual.sql

    # PN analysis
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/cf_pn_analysis.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/cf_pn_analysis.sql

    # PN analysis
    pgsql --file=${PIA_PROJECTPATH}/sql/02.data_model/pia_ua/or_invoice.sql
    pgsql --file=${PIA_PROJECTPATH}/sql/03.load/pia_ua/or_invoice.sql


    # clear out CF GIS tables before re-loading
    pgsql --command="drop table if exists table pia_ua.boundary" ;
    pgsql --command="drop table if exists table pia_ua.city_boundary" ;
    pgsql --command="drop table if exists table thirdparty.openreach_duct" ;
    pgsql --command="drop table if exists table thirdparty.openreach_structure" ;
    pgsql --command="drop table if exists table pia_ua.chamber" ;
    pgsql --command="drop table if exists table pia_ua.trench" ;
    pgsql --command="drop table if exists table pia_ua.pole" ;

    INFO "load CF GIS geopackage"
    # ogr2ogr -f "PostgreSQL" PG:"active_schema=pia_ua  host = ${PGHOST} dbname=${PGDATABASE} user=${PGUSER} port=${PGPORT} password=${PGPASSWORD}" "${PIA_DATAPATH}/SUN_trial_GIS_export.gpkg" 
    ogr2ogr -f "PostgreSQL" PG:"active_schema=pia_ua  host = ${PGHOST} dbname=${PGDATABASE} user=${PGUSER} port=${PGPORT} password=${PGPASSWORD}" "${PIA_DATAPATH}/GIS_export_v2.gpkg" 
    #-nln raw.postcode_centroid -append
    pgsql --command="CREATE INDEX IF NOT EXISTS idx_thirdparty_or_structure_objectid ON thirdparty.openreach_structure (objectid);"
    pgsql --command="CREATE INDEX IF NOT EXISTS idx_thirdparty_or_duct_objectid ON thirdparty.openreach_duct (objectid);"
    pgsql --command="update pia_ua.pole set bt_objectid = trim(bt_objectid);"
    pgsql --command="create index if not exists idx_pia_ua_pole_bt_objectid on pia_ua.pole (bt_objectid) ;"
    pgsql --command="update pia_ua.trench set bt_objectid = trim(bt_objectid);"
    pgsql --command="create index if not exists idx_pia_ua_trench_bt_objectid on pia_ua.trench (bt_objectid) ;"
    

#     # mapping tables between counties and states
#     INFO "Loading county and state mapping code"
#     pgsql --command="\copy county_code FROM '$DATAPATH/code_mapping/county_code.csv' WITH header csv encoding 'windows-1251'"
#     pgsql --command="UPDATE county_code SET tag = replace(tag, 'c', ''), county = replace(lower(county), ' ','')"
    
#     pgsql --command="\copy state_code FROM '$DATAPATH/code_mapping/state_code.csv' WITH header csv encoding 'windows-1251'"
#     pgsql --command="UPDATE state_code SET tag = replace(tag, 's', ''), state = replace(lower(state), ' ','')"
}





function main() {
    # calls the appropriate function based on the command line parameters
    # in principle, 'ALL' should do everything we need in the correct order
    INFO "Main"
    if $ALL; then
        loadRaw
    fi
    if $RAW; then loadRaw; fi
    if $PUBLIC; then loadPublic; fi
}

#======================== SCRIPT LOGIC ENDS HERE ===============================

function help() {
    # Prints Help and Exits
    # Globals: None
    # Returns: text
      printf "helpfile not writen yet\n" 
    exit 1
}

function cleanup (){
    # Removes temporary folder before exiting
    # Globals: tmpFOLDER
    # Returns: None
  if [[ -d $tmpFOLDER ]]; then rm -fr $tmpFOLDER; fi
}
trap cleanup EXIT

################################################################################
# Check arguments
#
# interprets all the valid command line arguments
################################################################################
while [ "$#" -gt 0 ]; do
  case "$1" in
    '--dbname='*)   		PGDATABASE="${1#*=}" 	;;
    '--host='*)     		PGHOST="${1#*=}"     	;;
    '--username='*) 		PGUSER="${1#*=}"     	;;
    '--password='*) 		PGPASSWORD="${1#*=}" 	;;
    '--port='*)     		PGHOST="${1#*=}"     	;;
    '--all')     		    ALL=true     	        ;;
    '--raw')				RAW=true			 	;;
    '--public')				PUBLIC=true				;;
    '--help')       		help                 	;;
    -h)             		help                 	;;
    *)
      INFO "Invalid argument, run --help for valid arguments"
      exit 1
  esac
  shift
done

INFO "Loading Into Data Model Started"
main
INFO "Loading Into Data Model Finished"

