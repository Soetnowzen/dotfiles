#!/bin/bash

function tail_color()
{
	local file RED GREEN YELLOW MAGENTA WHITE RESET
	file="${1}"
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	MAGENTA="$(tput setaf 5)"
	CYAN="$(tput setaf 6)"
	WHITE="$(tput setaf 7)"
	RESET="$(tput sgr0)"
	tail "$file" | sed "s/\(\<fail\w\+\|\<err\w\+\)/$RED\1$RESET/gI;
	s/\(\<warn\w\+\)/$YELLOW\1$RESET/gI;
	s/\(\<info\w\+\)/$WHITE\1$RESET/gI;
	s/\(\<ok\w\+\|\<done\>\|\<pass\w\+\)/$GREEN\1$RESET/gI;
	s/\(\<makemake\>\|\<mkmk\>\)/$MAGENTA\1$RESET/gI;
	s/\(\<true\>\|\<false\>\)/$CYAN\1$RESET/gI;
	s/\(\<\w\+.\w\+\>:[[:digit:]]\+\)/$BLUE\1$RESET/gI"
}

function tailf_color()
{
	local file RED GREEN YELLOW MAGENTA WHITE RESET
	file="${1}"
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	MAGENTA="$(tput setaf 5)"
	CYAN="$(tput setaf 6)"
	WHITE="$(tput setaf 7)"
	RESET="$(tput sgr0)"
	tail -f "$file" | sed "s/\(\<fail\w\+\|\<err\w\+\)/$RED\1$RESET/gI;
	s/\(\<warn\w\+\)/$YELLOW\1$RESET/gI;
	s/\(\<info\w\+\)/$WHITE\1$RESET/gI;
	s/\(\<ok\w\+\|\<done\>\|\<pass\w\+\)/$GREEN\1$RESET/gI;
	s/\(\<makemake\>\|\<mkmk\>\)/$MAGENTA\1$RESET/gI;
	s/\(\<true\>\|\<false\>\)/$CYAN\1$RESET/gI;
	s/\(\<\w\+.\w\+\>:[[:digit:]]\+\)/$BLUE\1$RESET/gI"
}

function colors_and_formatting()
{
	for clbg in {40..47} {100..107} 49 ; do
		for clfg in {30..37} {90..97} 39 ; do
			for attr in 0 1 2 4 5 7 ; do
				echo -en "\\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \\e[0m"
			done
			echo
		done
	done
}

function 256-colors()
{
	for fgbg in 38 48 ; do
		for color in {0..255} ; do
			printf "\\e[${fgbg};5;%sm  %3s  \\e[0m" $color $color
			if [ $(((color + 1) % 6)) == 4 ] ; then
				echo
			fi
		done
		echo
	done
}