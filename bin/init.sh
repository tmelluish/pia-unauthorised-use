#!/usr/bin/env bash
#
# Initialises the databse, creating schemas, functions and data model
set -o errexit
set -o pipefail
set -o nounset

################################################################################
# Logging Setting
################################################################################
readonly LOGS=${LOGS:-$(pwd)}
exec 1> >(tee -a $LOGS/$(date +'%Y%m%d').log) 2>&1

################################################################################
# Debugging settings
################################################################################
readonly _DEBUG=${_DEBUG:-"on"}
readonly ENVTYPE=${ENVTYPE:-"prod"}
readonly RUNID=${RUNID:-$(date +%Y%m%d%H%M%S)}
readonly tmpFOLDER=${tmpFOLDER:-"/tmp/cfh003"}

PREPDB=false
FUNCS=false
ROADS=false
PREMISES=false
PUBLIC=false
STATE=false
################################################################################
# Load utility functions
################################################################################
source $PROJECTPATH/bin/utilities.sh

cores=`nproc`
#======================= SCRIPT LOGIC STARTS HERE ==============================
function prepareDB() {
    # Adds required extensions and creates necessary schemas if they don't exist
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
    # Arguments: None
    INFO "prepareDB Started"
    DEBUG set -o verbose;
    INFO "Adding required PostgreSQL extensions"
    pgsql --file=$PROJECTPATH/sql/01.database/extensions.sql
    INFO "Creating the necessary schemas if they don't already exist"
    pgsql --file=$PROJECTPATH/sql/01.database/schema.sql
    DEBUG set +o verbose;
    INFO "prepareDB Finished"
}

function addPsqlFunctions() {
    # Drop and Recreates user defined functions
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
    # Arguments: None
    INFO "addPsqlFunctions Started"
    DEBUG set -o verbose;
    
    pgsql --file=$PROJECTPATH/sql/01.database/function.sql
    DEBUG set +o verbose;
    INFO "addPsqlFunctions Finished"
}

function createPublicRoads() {
    # Creates the Data Model. Order is Extremly Important!
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
    # Arguments: None
    # Output: roads, roads_vertices_pgr
    INFO "createPublicRoads Started"
    DEBUG set -o verbose;
    pgsql --file=${PROJECTPATH}/sql/02.data_model/02.public/roads.sql
    DEBUG set +o verbose;
    INFO "createPublicRoads Finished"
}

function createPublicPremises() {
    pgsql --file=$PROJECTPATH/sql/02.data_model/02.public/premises.sql
}

function createPublicDM() {
    # Creates the Data Model. Order is Extremly Important!
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
    # Arguments: None
    # Output: cell_sites, exchanges, hubsites
    INFO "createPublicDM Started"
    DEBUG set -o verbose;
    DEBUG set +o verbose;
    INFO "createPublicDM Finished"
}

function main() {
    # Entry Point of the script. Orchestrates everything
    # Globals: PROJECTPATH, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
    # Arguments: None

    DEBUG set -o verbose;
    if $PREPDB; then prepareDB; fi
    if $FUNCS; then addPsqlFunctions; fi
    if $ROADS; then createPublicRoads; fi
    if $PREMISES; then createPublicPremises; fi
    if $PUBLIC; then createPublicDM; fi
    DEBUG set +o verbose;
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
################################################################################
while [ "$#" -gt 0 ]; do
  case "$1" in
    '--dbname='*)   PGDATABASE="${1#*=}"  	;;
    '--host='*)     PGHOST="${1#*=}"      	;;
    '--username='*) PGUSER="${1#*=}"      	;;
    '--password='*) PGPASSWORD="${1#*=}"  	;;
    '--port='*)     PGHOST="${1#*=}"      	;;
    '--prep')		    PREPDB=true			  	;;
    '--add-func')	  FUNCS=true			  	;;
    '--public')		  PUBLIC=true				;;
    '--help')       help                  	;;
    -h)             help                  	;;
    *)
      INFO "Invalid argument, run --help for valid arguments"
      exit 1
  esac
  shift
done

INFO "Init Started"
main
INFO "Init Finished"