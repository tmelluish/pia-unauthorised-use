#!/usr/bin/env bash
#
# Utility functions to facilitate the orchestration

################################################################################
# Execute commands only if _DEBUG is on
# Globals: _DEBUG
# Arguments: String (Commands to execute)
# Returns: None
################################################################################
function DEBUG(){
  if [[ "${_DEBUG}" = "on" ]]; then
    $@
  fi
}

################################################################################
# Prints formatted text for logging purposes
# Globals: RUNID, BASH_SOURCE, PPID, $$
# Arguments: String (Message)
# Returns: String (Formated Message)
################################################################################
function INFO(){
  printf "%s: %s.%.2s [%s:%s(%s)] INFO: %s\n" \
  "${RUNID}" "$(date '+%Y-%m-%d %H:%M:%S')" $(date +%N) \
  "${BASH_SOURCE[-1]##*/}" "$PPID" "$$" "$@"
}

################################################################################
# Execute psql with default options if DEBUG is on
# Globals: _DEBUG
# Arguments: String (Command to execute with psql)
# Returns: None
################################################################################
function pgsql() {
    if [[ "$_DEBUG" = "on" ]]; then
        psql --no-psqlrc --echo-errors --set=ON_ERROR_STOP=on --echo-queries "$@"
    else
        psql "$@"
    fi
}
