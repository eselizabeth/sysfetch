#!/bin/bash

green='\033[32m'
white='\033[37m'
blue='\033[34m'
red='\033[31m'
orange='\033[33m'
purple='\033[35m'
yellow='\033[93m' 


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
        pk_num=""
        # Apt 
	if [ -x "$(command -v apt-get)" ];
	then
	    pk_num+="$(dpkg-query -f '${binary:Package}\n' -W | wc -l) (dpkg)"
        fi
        # Snap 
        if [ -x "$(command -v snap)" ];
        then 
            pk_num+=", $(snap list | wc -l) (snap)"
        fi
        # Pacman 
        if [ -x "$(command -v pacman)" ];
        then
          pk_num+=" $(pacman -Q | wc -l)"
        fi 
        # Dnf  
        if [ -x ""$(command -v dnf)"" ];
        then
          pk_num+=" $(dnf list installed | wc -l)"
        fi
        # Rpm
        if [ -x ""$(command -v rpm)"" ];
        then
          pk_num+=" $(rpm -qa --last | wc -l)"
        fi
        # Yum
        if [ -x ""$(command -v yum)"" ];
        then
          pk_num+=" $(yum list installed | wc -l)"
        fi 
        # Zypper
        if [ -x "$(command -v zypper)" ];
        then 
          pk_num+=" $(zypper se | wc -l)"
        fi 
        # Portage
        if [ -x "$(command -v emerge)" ];
        then 
          pk_num+=" $(equery depends | wc -l)"
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
    	# distro_="gentoo"
        case $distro_ in
         ([Dd]ebian*)
printf \
"$red              ..          			$blue $name
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
"$orange                          $white hsoosd 			$red $name
               $orange  mmddhdmM$white yooooood 			$green ################
               $orange soooooooM$white hoooooom 			$red Operating System: $white$distro_
          $orange dsyMMNsoooooosm$white dyyyhm 			$red Kernel: $white$kernel_version
         $orange msoooyNMNsooooooosyhhyssd 			$red Uptime: $white${uptime_:3}
        $orange doooooosNMNddmmdysooooooooh 			$red Packages: $white $pk_num
        ooooooosm         msoooooood			$red Shell: $white$shell_
  $red hsssymmooooos$orange            soooooos			$red Resolution: $white$screen_res
 $red yoooooomdooood$orange              mmmmmmm			$red Desktop Environment: $white$de_ $de_ver
 $red yoooooommooood$orange              mmmmmmm			$red CPU: $white$cpu_
  $red hsssymmsoooos$orange            soooooos			$red Memory: $white$total_memory
        ooooooosm         msoooooood
        doooooosNMMdmmmdhsooooooooh 
         msooosNMNsooooooosyhhyssd 
           hsyMMNsoooooo$white dyyyhmM 
                $orange sooooooo$white hoooooom 
                 $orange mddhhhm$white yooooood 
                          $white hooosd 
		\n"
;;
	([Mm]anjaro*)
printf \
"
$green  ===================. .========		$red $name
$green  ===================. .========		$green ################
$green  ===================. .========		$red Operating System: $white$distro_
$green  ===================. .========		$red Kernel: $white$kernel_version
$green  ========:            .========		$red Uptime: $white${uptime_:3}
$green  ========.  ::::::::  .========		$red Packages: $white $pk_num
$green  ========.  ========. .========		$red Shell: $white$shell_
$green  ========.  ========. .========		$red Resolution: $white$screen_res
$green  ========.  ========. .========		$red Desktop Environment: $white$de_ $de_ver
$green  ========.  ========. .========		$red CPU: $white$cpu_
$green  ========.  ========. .========		$red Memory: $white$total_memory
$green  ========.  ========. .========
$green  ========.  ========. .========
$green  ========.  ========. .========
$white
		\n"
;;

	([Ff]edora*)
printf \
"
$blue            .-:://///::-.           
$blue         :/+++++++++++++++/:.      		$red $name
$blue      -/+++++++++++++++++++++/-			$green ################
$blue    ./++++++++++++++/:::/+++++++.   		$red Operating System: $white$distro_
$blue   -+++++++++++++/.$white######$blue:++++++-  		$red Kernel: $white$kernel_version 
$blue  -+++++++++++++/$white###$blue/++/.$white##$blue:++++++- 		$red Uptime: $white${uptime_:3}
$blue  ++++++++++++++:$white##$blue-++++/$white##$blue-+++++++ 		$red Packages: $white $pk_num
$blue -++++++++++++++:$white##$blue-+++$white##$blue//++++++++-		$red Shell: $white$shell_
$blue :++++++++:-...::$white#####$blue/+++++++++++:		$red Resolution: $white$screen_res
$blue :++++++.$white###..::$white###$blue.../+++++++++++:			$red Desktop Environment: $white$de_ $de_ver
$blue :+++++$white##$blue:+++++:$white##$blue-+++++++++++++++		$red CPU: $white$cpu_
$blue :++++/$white##$blue.++++++:$white##$blue-++++++++++++++: 		$red Memory: $white$total_memory
$blue :+++++.$white##$blue-++++:$white###$blue/+++++++++++++:  
$blue :++++++-$white########$blue./+++++++++++++.   
$blue :++++++++/:---:++++++++++++++-     
$blue  -+++++++++++++++++++++++++:.       
$blue     :/+++++++++++++++++/:.
$blue    	 .-:://////::-.  
$blue        
$white
		\n"
;;
	([Gg]entoo*)
printf \
"

$purple          *......-----*              
$purple      .--*        **.:::.           		$red $name
$purple	.-*           ***..-::-.       		$green ################
$purple   *:.            *.-....--:::.*    		$red Operating System: $white$distro_
$purple   :.           *:///+o-.---:::-.*  		$red Kernel: $white$kernel_version
$purple  ./-*         -//::/oy+.---::::-..  		$red Uptime: $white${uptime_:3}
$purple   :/:-.*       *-////-..--:::::/:*.*		$red Packages: $white $pk_num
$purple    -//::-**       ***..---::::///. -		$red Shell: $white$shell_
$purple      *.://-*     ***...---::::/:. ./		$red Resolution: $white$screen_res
$purple         **      ***...---:::::. *:/.		$red Desktop Environment: $white$de_ $de_ver
$purple       *        ***...----::-. *:+:* 		$red CPU: $white$cpu_
$purple     *         ***...-----.* ./+:*   		$red Memory: $white$total_memory
$purple   **        ****...---.* *:++:*     
$purple  -       *****....-.* *:+o/-        
$purple  /  *******.....***./os+:*          
$purple  /: ***********-/+ss+:*             
$purple  */o/----://ossso/-*                
$purple    ./+ssssso/:.*                     
$white
  		\n"
;;
	(*)
printf \
"

$yellow              a8888b.
$yellow              d888888b.			$red $name
$yellow              8P'YPY'88			$green ################
$yellow              8|o||o|88			$red Operating System: $white$distro_
$yellow              8'    .88			$red Kernel: $white$kernel_version
$yellow              8*._.' Y8.		$red Uptime: $white${uptime_:3}
$yellow             d/      *8b.		$red Packages: $white $pk_num
$yellow            dP   .    Y8b.		$red Shell: $white$shell_
$yellow           d8:'  '  *::88b		$red Resolution: $white$screen_res
$yellow          d8'         'Y88b		$red Desktop Environment: $white$de_ $de_ver
$yellow        :8P    '      :888		$red CPU: $white$cpu_
$yellow          8a.   :     _a88P		$red Memory: $white$total_memory
$yellow        ._/'Yaa_:   .| 88P|
$yellow   jgs  \    YP'    *| 8P  *.
$yellow   a:f  /     \.___.d|    .'
$yellow        *--..__)8888P*._.'  
$white                 
  		\n"
;;
esac
    }

main
