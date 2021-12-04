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
	if [ "$shell_" = "bash" ]
	then
		shell_="bash $(bash --version | head -1 | cut -d ' ' -f 4 | cut -d '(' -f 1)"
	fi
}

get_resolution () {
	screen_res="$(xdpyinfo | awk '/dimensions/{print $2}')"
}

get_de () {
	de_="${XDG_CURRENT_DESKTOP} ${DESKTOP_SESSION}"
	de_ver="$(plasmashell --version | awk '{print $2}')"
}

get_gpu () {
	cpu_="$(cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d':' -f 2 | xargs)"
}

get_cpu () {
	gpu_="$(lspci | grep VGA | cut -d '[' -f 3)"
	gpu_="$(lspci -vnn | grep VGA -A 12 | grep Subsystem | cut -f 2 | cut -d ']' -f 1 | cut -d ' ' -f2-)]"
}

get_memory () {
	used_memory="$(grep -i MemAvailable /proc/meminfo | awk '{print $2}')"
	total_memory=$(grep -i MemTotal /proc/meminfo | awk '{print $2}')
	total_memory="$((used_memory/1024)) / $((total_memory/1024)) MiB"
}


get_name
get_distro
get_kernel
get_uptime
get_packages
get_shell
get_resolution
get_de
get_gpu
get_cpu
get_memory


main () {
	if [[ $(hostname) == "debian" ]];
	then
printf \
"$red           ..          			$blue $name
$red       ##############    		$green ################
$red    ####           (###* 		$blue Operating System: $white$distro_
$red  *##                ##/(		$blue Kernel: $white$kernel_version
$red ##*       *(    .    ## 		$blue Uptime: $white${uptime_:3}
$red ##       #           ## 		$blue Packages: $white $pk_num
$red #        #       .   #. 		$blue Shell: $white$shell_
$red ##       .#,       ##   		$blue Resolution: $white$screen_res
$red (#          (,/(*       		$blue Desktop Environment: $white$de_ $de_ver
$red  ###                    		$blue CPU: $white$cpu_
$red    ##                   		$blue GPU: $white$gpu_
$red      ##                 		$blue Memory: $white$total_memory
$red         ,#*             
$white
		\n"
	fi
}

main
