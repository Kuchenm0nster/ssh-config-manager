#!/bin/bash
#########################################
# Script by Thorben Rudeloff
# Contact at thorben.rudeloff@mni.thm.de
# Github https://github.com/

#================== Globals ==================================================
# Version
VERSION="0.1"

# Configuration
HOST_FILE="$HOME/.ssh/config"

#================== Functions ================================================

function exec_ping() {
  ping -c1 -w 2 $@
}

function test_host() {
	exec_ping $* &> /dev/null
	if [ $? != 0 ] ; then
		echo -n "["
		cecho -n -red "KO"
		echo -n "]  "
	else
		echo -n "["
		cecho -n -green "UP"
		echo -n "]  "
	fi
}

function separator() {
	echo "--------------------------------------------------------------------------------"
}

function cecho {
	while [ "$1" ]; do
		case "$1" in
			-normal)        color="\033[00m" ;;
      -black)         color="\033[30;01m" ;;
      -red)           color="\033[31;01m" ;;
      -green)         color="\033[32;01m" ;;
      -yellow)        color="\033[33;01m" ;;
      -blue)          color="\033[34;01m" ;;
      -magenta)       color="\033[35;01m" ;;
      -cyan)          color="\033[36;01m" ;;
      -white)         color="\033[37;01m" ;;
      -n)             one_line=1;   shift ; continue ;;
      *)              echo -n "$1"; shift ; continue ;;
    esac

    shift
    echo -en "$color"
    echo -en "$1"
    echo -en "\033[00m"
    shift
  done
  if [ ! $one_line ]; then
	  echo
  fi
}

function get_name (){
  for i in $(grep -i host $HOST_FILE|cut -d" " -f2); do echo $i;done
}

function get_addr (){
	grep -A 1 "$1" $HOST_FILE|grep -i HostName|cut -d" " -f4
}

function main (){
  i=0
  declare -a arr
  for a in $(get_name); do
    addr=$(get_addr $a)
    arr[$i]=$a
    test_host $addr
    printf "%15s\t(%2s)\t%s\n" $a $i $addr
    i=$((i+1))
  done

  while true; do
    read -p "Connect with:" num
    ssh -i $HOST_FILE ${arr[$num]}
    exit
  done

}

#=============================================================================
main
