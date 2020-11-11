### ----------------------------------------------------------------------------------------------------- ###
### --------- FUNCTION printDebug is used to print a message to stdout ---------------------------------- ###
### ------------------ The caller will be mentioned as script:line_number ------------------------------- ###
### ----------------------------------------------------------------------------------------------------- ###
printDebug() {
  if [[ "true" == "$debug" ]]; then
    varName=""
    if [[ "$#" -ge "2" ]]; then
      varName="[var=$1]"
      shift
    fi

    printf "\e[93m[DEBUG][%s]%s %s\e[39m\\n" "$(caller | awk '{printf("%s:%s\n",$2,$1)}')" "$varName" "$*"
  fi
}
