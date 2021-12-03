#!/bin/bash

green='\033[32m'
white='\033[37m'
blue='\033[34m'
red='\033[31m'

get_name () {
	name="$(whoami)@$(hostname)"
}

get_distro () {
	source /etc/*release
	distro_="$PRETTY_NAME" 
}

get_kernel () {
	kernel_version="$(uname -mr)"
}
get_uptime () {
	uptime_="$(uptime -p)"
}

get_packages () {
	if [ -x "$(command -v apt-get)" ]
	then
		pk_num="$(dpkg-query -f '${binary:Package}\n' -W | wc -l) (dpkg)"
	fi
}

get_shell () {
	shell_="$(basename $SHELL)"
	shell_ver="${BASH_VERSION}"
}

get_resolution () {
	screen_res="$(xdpyinfo | awk '/dimensions/{print $2}')"
}

get_de () {
	de_="${XDG_CURRENT_DESKTOP} ${DESKTOP_SESSION}"
	de_ver="$(plasmashell --version | awk '{print $2}')"
}



get_name
get_distro
get_kernel
get_uptime
get_packages
get_shell
get_resolution
get_de



main () {
	if [[ $(hostname) == "debian" ]];
	then
printf \
"$red           ..          			$blue $name
$red       ##############    		$green ##############
$red    ####           (###* 		$blue Operating System: $white$distro_
$red  *##                ##/(		$blue Kernel: $white$kernel_version
$red ##*       *(    .    ## 		$blue Uptime: $white${uptime_:3}
$red ##       #           ## 		$blue Packages: $white $pk_num
$red #        #       .   #. 		$blue Shell: $white$shell_ $shell_ver
$red ##       .#,       ##   		$blue Resolution: $white$screen_res
$red (#          (,/(*       		$blue Desktop Environment: $white$de_ $de_ver
$red  ###                    		
$red    ##                   
$red      ##                 
$red         ,#*             
$white
		\n"
	fi
}

main
