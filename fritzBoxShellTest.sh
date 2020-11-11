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

# Set Colors
reset=$(tput sgr0)
cyan=$(tput setaf 6)
red=$(tput setaf 1)
green=$(tput setaf 2)
tan=$(tput setaf 3)
blue=$(tput setaf 6)

e_success() {
	slen="$1"
	alen="$2"
	shift; shift
	printf "${green}\\xE2\\x9C\\x94 %-${slen}s %-${alen}s %s${reset}\\n" "$@"
}

e_error() {
	len="$1"
	alen="$2"
	shift; shift
  printf "${red}\\xE2\\x9C\\x96 %-${len}s %-${alen}s %s${reset}\\n" "$@"
}


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
	words=$(/bin/bash "$DIRECTORY/fritzBoxShell.sh" "$i" "${actions[$counter]}"|wc -w)
	if [[ "$words" -ge ${minwords[$counter]} ]]; then
		e_success "$maxservicelen" "$maxactionlen" "$i" "${actions[$counter]}" "is working"
	else
		e_error "$maxservicelen" "$maxactionlen" "$i" "${actions[$counter]}" "is not working"
	fi
	counter=$((counter+1))
done
/bin/bash "$DIRECTORY/fritzBoxShell.sh" DEVICEINFO 3 | grep NewModelName
/bin/bash "$DIRECTORY/fritzBoxShell.sh" DEVICEINFO 3 | grep NewSoftwareVersion
/bin/bash "$DIRECTORY/fritzBoxShell.sh" VERSION
