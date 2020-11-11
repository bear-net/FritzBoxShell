# Set Colors
reset=$(tput sgr0)
cyan=$(tput setaf 6)
red=$(tput setaf 1)
green=$(tput setaf 2)
tan=$(tput setaf 3)
blue=$(tput setaf 6)

### ----------------------------------------------------------------------------------------------------- ###
### --------- FUNCTION printDebug is used to print a message to stdout ---------------------------------- ###
### ------------------ The caller will be mentioned as script:line_number ------------------------------- ###
### ----------------------------------------------------------------------------------------------------- ###
printDebug() {
  if [[ "true" == "$debug" ]]; then
    local varName=""
    if [[ "$#" -ge "2" ]]; then
      local varName="[var=$1]"
      shift
    fi

    printf "${tan}[DEBUG][%s]%s %s${reset}\\n" "$(caller | awk '{printf("%s:%s\n",$2,$1)}')" "$varName" "$*"
  fi
}


printTestResultSuccess() {
  local prefix="${green}\\xE2\\x9C\\x94"
  printTestResult "$prefix" "$@"
}

printTestResultError() {
  local prefix="${red}\\xE2\\x9C\\x96"
  printTestResult "$prefix" "$@"
}

printTestResult() {
  if [[ "$#" -ge "6" ]]; then
    local prefix="$1"
    local servicelength="$2"
    local actionlength="$3"
    local service="$4"
    local action="$5"
    shift; shift; shift; shift; shift
  else
    echo "Usage: printTestResult prefix service-length actions-length service-name action-name result"
  fi

  printf "$prefix %-${servicelength}s %-${actionlength}s %s${reset}\\n" "$service" "$action" "$*"
}
