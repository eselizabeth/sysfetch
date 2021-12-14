#!/bin/bash

green='\033[32m'
white='\033[37m'
blue='\033[34m'
red='\033[31m'
yellow='\033[33m'
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
	elif [ "$shell_" = "tcsh" ]
	then
		shell_="tcsh $(tcsh --version | cut -d ' ' -f 2)"
	elif [ "$shell_" = "zsh" ]
	then
		shell_="zsh $(zsh --version | cut -d ' ' -f 2)"
	elif [ "$shell_" = "ksh" ]
	then
		shell_="ksh $(strings /bin/ksh | grep Version | tail -2  | cut -d ' ' -f2-)"
	elif [ "$shell_" = "fish" ]
	then
		shell_="$(fish --version)"
	fi
}

get_resolution () {
	screen_res="$(xdpyinfo | awk '/dimensions/{print $2}')"
}

get_de () {
	de_="${XDG_CURRENT_DESKTOP} ${DESKTOP_SESSION}"
	de_ver="$(plasmashell --version | awk '{print $2}')"
}

get_cpu () {
	cpu_="$(cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d':' -f 2 | xargs)"
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
get_cpu
get_memory


main () {
		distro_="ubuntu"
        case $distro_ in
         ([Dd]ebian*)
printf \
"$red              ..          				$blue $name
$red          ##############    			$green ################
$red       ####           (###* 			$blue Operating System: $white$distro_
$red     *##                ##/(			$blue Kernel: $white$kernel_version
$red    ##*       *(    .    ## 			$blue Uptime: $white${uptime_:3}
$red    ##       #           ## 			$blue Packages: $white $pk_num
$red    #        #       .   #. 			$blue Shell: $white$shell_
$red    ##       .#,       ##   			$blue Resolution: $white$screen_res
$red    (#          (,/(*       			$blue Desktop Environment: $white$de_ $de_ver
$red     ###                    			$blue CPU: $white$cpu_
$red       ##                   			$blue Memory: $white$total_memory
$red         ##                 		
$red           ,#*             
$white
		\n"
;;
          ([Aa]rch*)
printf \
"$blue               Mdm					$red $name
$blue              MmssN					$green ################
$blue             MNssssN					$red Operating System: $white$distro_
$blue            MNsoooosN					$red Kernel: $white$kernel_version
$blue           MNdsooooosM					$red Uptime: $white${uptime_:3}
$blue          MNs+ssooooosM					$red Packages: $white $pk_num
$blue         MNo+++++++ooosM				$red Shell: $white$shell_
$blue        MNo++ooossssssosM				$red Resolution: $white$screen_res
$blue       MNsossssshyssssssyN				$red Desktop Environment: $white$de_ $de_ver
$blue      MNssssssd    hsssssyN				$red CPU: $white$cpu_
$blue     MNssssssy      ssssssyN				$red Memory: $white$total_memory
$blue    Mmsssssssh      yssssyhdM
$blue   Mmsssssyhdm      mdhyssssyN
$blue  Mdsshd                  dhssm
$blue mdN                         NdN
$white
		\n"
;;
		([Mm]int*)


printf \
"$green           ////////	
$green       ////////////////					$red $name
$green     ////////////////////				$green ################
$green    /-...-------------://///				$red Operating System: $white$distro_
$green   //.$white     .            $green:////				$red Kernel: $white$kernel_version
$green  ///:--$white  -/   ........  $green-////				$red Uptime: $white${uptime_:3}
$green  /////$white  -/  ::..::..::  $green/////				$red Packages: $white $pk_num
$green  ///// $white  -/  ::  ::  :/  $green/////				$red Shell: $white$shell_
$green   /////$white  -/  ::  ::  :/  $green/////				$red Resolution: $white$screen_res
$green   /////$white  -/         ::   $green/////				$red Desktop Environment: $white$de_ $de_ver
$green   /////-$white  -:--------::   $green////				$red CPU: $white$cpu_
$green    /////:$white   ''''''''    $green.//				$red Memory: $white$total_memory
$green      /////::------------:/
$green 	 ////////////////
$green  	     ////////
$white
		\n"
;;

		([Uu]buntu*)

printf \
"$yellow                          $white hsoosd 			$red $name
               $yellow  mmddhdmM$white yooooood 			$green ################
               $yellow soooooooM$white hoooooom 			$red Operating System: $white$distro_
          $yellow dsyMMNsoooooosm$white dyyyhm 			$red Kernel: $white$kernel_version
         $yellow msoooyNMNsooooooosyhhyssd 			$red Uptime: $white${uptime_:3}
        $yellow doooooosNMNddmmdysooooooooh 			$red Packages: $white $pk_num
        ooooooosm         msoooooood			$red Shell: $white$shell_
  $red hsssymmooooos$yellow            soooooos			$red Resolution: $white$screen_res
 $red yoooooomdooood$yellow              mmmmmmm			$red Desktop Environment: $white$de_ $de_ver
 $red yoooooommooood$yellow              mmmmmmm			$red CPU: $white$cpu_
  $red hsssymmsoooos$yellow            soooooos			$red Memory: $white$total_memory
        ooooooosm         msoooooood
        doooooosNMMdmmmdhsooooooooh 
         msooosNMNsooooooosyhhyssd 
           hsyMMNsoooooo$white dyyyhmM 
                $yellow sooooooo$white hoooooom 
                 $yellow mddhhhm$white yooooood 
                          $white hooosd 
		\n"
;;



esac
}
main
