#!/bin/bash
# shellcheck disable=SC1090
#************************************************************#
#** Autor: Jürgen Key https://elbosso.github.io/index.html **#
#** Autor: Johannes Hubig <johannes.hubig@gmail.com>       **#
#************************************************************#

# The following script is supposed to test what actions are
# supported by what device with what version of the firmware

dir=$(dirname "$0")

DIRECTORY=$(cd "$dir" && pwd)
source "$DIRECTORY/fritzBoxShellConfig.sh"
source "$DIRECTORY/helper.sh"

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --debug)
    export DEBUG="true"
    shift
    ;;
  esac
done

## declare an array variable
declare -a services=("WLAN_2G"   "WLAN_2G" "WLAN_5G"    "WLAN_2G" "WLAN"  "LAN"   "DSL"   "WAN"   "LINK"  "IGDWAN" "IGDDSL" "IGDIP" "TAM")
declare -a actions=("STATISTICS" "STATE"   "STATISTICS" "STATE"   "STATE" "STATE" "STATE" "STATE" "STATE" "STATE"  "STATE"  "STATE" "0 GetInfo")
declare -a minwords=(3           5         3            5         9       1       1       1       1       1        1        1       5      )

## loop through array to count word lengths
counter=0
maxservicelen=0
maxactionlen=0
for i in "${services[@]}"
do
	servicelen=${#i}
	actionlen=${#actions[$counter]}
	if [[ "$servicelen" -ge "$maxservicelen" ]]; then
		maxservicelen="$servicelen"
	fi
	if [[ "$actionlen" -ge "$maxactionlen" ]]; then
		maxactionlen="$actionlen"
	fi
	counter=$((counter+1))
done

## now loop through the above array
counter=0
for i in "${services[@]}"
do
  result=$(/bin/bash "$DIRECTORY/fritzBoxShell.sh" "$i" "${actions[$counter]}")
	printDebug "$result"
	words=$(echo "$result" | wc -w)
	if [[ "$words" -ge ${minwords[$counter]} ]]; then
		printTestResultSuccess "$maxservicelen" "$maxactionlen" "$i" "${actions[$counter]}" "is working"
	else
		printTestResultError "$maxservicelen" "$maxactionlen" "$i" "${actions[$counter]}" "is not working"
	fi
	counter=$((counter+1))
done
/bin/bash "$DIRECTORY/fritzBoxShell.sh" DEVICEINFO 3 | grep NewModelName
/bin/bash "$DIRECTORY/fritzBoxShell.sh" DEVICEINFO 3 | grep NewSoftwareVersion
/bin/bash "$DIRECTORY/fritzBoxShell.sh" VERSION
