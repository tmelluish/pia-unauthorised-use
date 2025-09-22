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
source $PROJECTPATH/bin/utilities.sh


function loadRaw() {
    # Loads raw data from client into the raw schema
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD, DATAPATH
    # Arguments: None
    # Output: 
    # 	raw.oa_population_2011, raw.oa_to_bua, raw.scotland_settlement_population_2016, raw.ireland_settlement_population_2015

    INFO "loadRaw Started"
    DEBUG set -o verbose;


    # CF ducts
    pgsql --file=${PROJECTPATH}/sql/02.data_model/pia_raw/cf_ducts.sql
    pgsql --command="\copy pia_raw.cf_ducts from '${DATAPATH}/cf_ducts_from_excel.csv' WITH CSV HEADER"

    # CF poles

    # CF lead-ins

    # CF ducts poles combined

  
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
    
    # INFO "load postcode geometries"
    # ogr2ogr -f "PostgreSQL" PG:"host = ${PGHOST} dbname=${PGDATABASE} user=${PGUSER} port=${PGPORT} password=${PGPASSWORD}" "${DATAPATH}/postcode/f713157ef187437895133622db0fc3dd_0.geojson" -nln raw.postcode_centroid -append
    
    DEBUG set +o verbose;
    INFO "loadRaw Finished"
}



function loadPublic() {
    # mapping tables between counties and states
    INFO "Loading county and state mapping code"
    pgsql --command="\copy county_code FROM '$DATAPATH/code_mapping/county_code.csv' WITH header csv encoding 'windows-1251'"
    pgsql --command="UPDATE county_code SET tag = replace(tag, 'c', ''), county = replace(lower(county), ' ','')"
    
    pgsql --command="\copy state_code FROM '$DATAPATH/code_mapping/state_code.csv' WITH header csv encoding 'windows-1251'"
    pgsql --command="UPDATE state_code SET tag = replace(tag, 's', ''), state = replace(lower(state), ' ','')"
}

function loadStateSchema(){
    # we have a separate DB schema for each state
    # this function sets up their data models, and copies
    # the state-specific data from the public schema to the state schema

    stateList=$DATAPATH/state_list.csv
    row=`wc -l < $DATAPATH/state_list.csv`
    r=1
    while [ $r -le $row ];
    do
        j=1
        while [ $j -le $cores ];
        do
            if [ $r -le $row ]; then
                state=`awk "NR==$r" $stateList`
                pgsql --file=$PROJECTPATH/sql/04.analysis/01.popuplate_individual_state_data.sql --set schema=$state --set state_name="'$state'" &
            fi
            ((j++))
            ((r++))
        done
        # allow to execute up to $N jobs in parallel
        # echo $(jobs -r -p | wc -l)
        wait $!
    done
    wait $!
}

function update2020Census(){
    # update to 2020 census info from 2010 - not needed in a fresh execution

    stateList=$DATAPATH/state_list_full.csv
    row=`wc -l < $DATAPATH/state_list_full.csv`
    r=1
    while [ $r -le $row ];
    do
        j=1
        while [ $j -le $cores ];
        do
            if [ $r -le $row ]; then
                state=`awk "NR==$r" $stateList`
                pgsql --file=$PROJECTPATH/sql/05.adhoc/update_census_2020_per_state.sql --set schema=$state --set state_name="'$state'" &
            fi
            ((j++))
            ((r++))
        done
        # allow to execute up to $N jobs in parallel
        # echo $(jobs -r -p | wc -l)
        wait $!
    done
    wait $!
}

function loadStateCandidates(){
    # for each state, work out the set of things that need to be connected
    # in order to build the network
    # we aim to execute for multiple states in parallel
    stateList=$DATAPATH/state_list_full.csv
    row=`wc -l < $DATAPATH/state_list_full.csv`
    r=1
    while [ $r -le $row ];
    do
        j=1
        while [ $j -le $cores ];
        do
            if [ $r -le $row ]; then
                state=`awk "NR==$r" $stateList`
                # this inserts pairs of objects (e.g. each premises with its related Distribution Point)
                # into a table named either 'pgr_candidate_access' (for access network), or 'pgr_candidate_census'
                # for spine network
                pgsql --file=$PROJECTPATH/sql/04.analysis/02.populating_route_candidate.sql --set schema=$state &
            fi
            ((j++))
            ((r++))
        done
        # allow to execute up to $N jobs in parallel
        # echo $(jobs -r -p | wc -l)
        wait $!
    done
    wait $!
}

function routes(){
    # do the routing for a specific state
    # we do two calls each for access and census (spine)
    # the first one finds the road distance between the candidate pairs
    # the second one attempts to optimise the routing, by:
    # 1. routing again, with the pair with the shortest road distance first
    # 2. adjusting the road cost after each candidate pair, reducing costs of roads that have already
    # been used - this is done using a counter table which records how often each road is used

    python3 -u $PROJECTPATH/sql/04.analysis/04.routes.py --schema=$@ --type=access -c 
    python3 -u $PROJECTPATH/sql/04.analysis/04.routes.py --schema=$@ --type=access -o 
    python3 -u $PROJECTPATH/sql/04.analysis/04.routes.py --schema=$@ --type=census -c 
    python3 -u $PROJECTPATH/sql/04.analysis/04.routes.py --schema=$@ --type=census -o 
}

function loadRoutes(){
    # loop round all the states one by one, calling the 'routes' function on each in turn
    # to do the routing
    stateList=$DATAPATH/state_list_full.csv
    row=`wc -l < $DATAPATH/state_list_full.csv`
    r=1
    while [ $r -le $row ];
    do  
        state=`awk "NR==$r" $stateList`
        INFO "Routing $state"
	    routes $state

        # drop the counter tables that are used to reduce the cost of going down a road twice
        pgsql --command="SELECT drop_tables('pgr_counter%', '$state')"
        ((r++))
    done
    wait $!
}

function updateRoadTractCode(){
    # in the state road tables, we note a census tract id for each road
    stateList=$DATAPATH/state_list_full.csv
    row=`wc -l < $DATAPATH/state_list_full.csv`
    r=1
    while [ $r -le $row ];
    do  
        state=`awk "NR==$r" $stateList`
        INFO "Updating census tract mappings for roads in $state"
	#routes $state
        pgsql --file=$PROJECTPATH/sql/05.adhoc/update_road_track_code.sql --set schema=$state &t
        ((r++))
    done
    wait $!
}

function main() {
    # calls the appropriate function based on the command line parameters
    # in principle, 'ALL' should do everything we need in the correct order
    INFO "Main"
    if $ALL; then
        loadRoads
        loadBlock
        loadTrack
        loadUSBuilding
        loadParameters
        loadPublic
        loadStateSchema
        loadStateCandidates
        loadRoutes
    fi
    if $ROADS; then loadRoads; fi
    if $BLOCK; then loadBlock; fi
    if $BLOCK2022; then loadBlock2022; fi    
    if $TRACK; then loadTrack; fi
    if $TRACK2022; then loadTrack2022; fi    
    if $PREMISES; then loadUSBuilding; fi	
    if $PARAMETERS; then loadParameters; fi
    if $PUBLIC; then loadPublic; fi
    if $STATE; then loadStateSchema; fi
    if $UPDATE2020; then update2020Census; fi
    if $CANDIDATE; then loadStateCandidates; fi
    if $ROUTE; then loadRoutes; fi    
    if $UPDATEROADTRACT; then updateRoadTractCode; fi
    if $BUSINESS; then loadUSBusinesses; fi
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
    '--roads')				ROADS=true				;;
    '--prems')              PREMISES=true           ;;
    '--public')				PUBLIC=true				;;
    '--block')              BLOCK=true              ;;
    '--block2022')          BLOCK2022=true          ;;    
    '--track')              TRACK=true              ;;
    '--track2022')          TRACK2022=true          ;;    
    '--state')              STATE=true              ;;
    '--cand')              CANDIDATE=true              ;;
    '--route')              ROUTE=true              ;;
    '--update2020')         UPDATE2020=true         ;;
    '--updateRoadTract')    UPDATEROADTRACT=true    ;;
    '--parameters')         PARAMETERS=true         ;;
    '--business')           BUSINESS=true           ;;
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

