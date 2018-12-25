#!/usr/bin/env bash
# Terraform CLI

# Usage
usage(){
  echo '---------------------------------------------'
  echo "USAGE: ${BASH_SOURCE[0]} [COMMAND] [OPTIONS]"
  echo '---------------------------------------------'
  echo '----------------------------------------------'
  echo 'For more information please consult the README'
  echo '----------------------------------------------'
  exit 1
}

# Bash strict mode
set -euo pipefail
IFS=$'\n\t'

# DEBUG
[ -z "${DEBUG:-}" ] || set -x

# System VARs
NOW="$(date +"%Y%m%d_%H%M%S")"
TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmp')
APPDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
VERSION=$(git --git-dir="${APPDIR}/.git" --work-tree="${APPDIR}" describe --always --tags)
export NOW TMPDIR APPDIR VERSION

# Output
e_ok()    { printf "  ✔  %s\\n" "$@" ;}
e_info()  { printf "  ➜  %s\\n" "$@" ;}
e_error() { printf "  ✖  %s\\n" "$@" ;}
e_warn()  { printf "    %s\\n" "$@" ;}
e_abort() { e_error "$1"; return "${2:-1}" ;}

# Clean-up
clean_up() {
  if [[ "${CI:-false}" == 'true' ]]; then
    if [[ -s "${APPDIR}/.env" ]]; then
      e_info 'Removing .env'
      shred -fu "${APPDIR:?}/.env"
    fi
  fi
}

# Process CLI
process_cli(){
  trap 'clean_up' EXIT HUP INT QUIT TERM
  if [[ -z $1 ]]; then usage; fi

  local cmd var
  cmd="${1:-}"
  var="-var 'version=${VERSION}'"

  case "$cmd" in
    apply|import|plan|push|refresh|validate)
      eval terraform "${@:-}" "$var"
      ;;
    *)
      eval terraform "${@:-}"
      ;;
  esac
}

process_cli "${@:-}"
