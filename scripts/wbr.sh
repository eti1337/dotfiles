#!/usr/bin/env bash
# vars
colors="/usr/scripts/colors.sh"
refresh=".15"
padding="    "
height="35"
font="-*-euphon-*"
font2="-*-ijis-*"
font3="-*-vanilla-*"
font4="-efont-biwidth-*"
battery="BAT0"


# colors
source "$colors"


# functions
desktop() {
	cur=$(xdotool get_desktop)
	first="ראשון"
	second="השני"
	third="שלישית"
	fourth="רביעי"
	fifth="חמישי"
	case "$cur" in
		0)
			echo "${a2}${a1}${padding}${first}${padding}${a2}${padding}${second}${padding}${padding}${third}${padding}${padding}${fourth}${padding}${padding}${fifth}${padding}"
			;;
		1)
			echo "${a2}${padding}${first}${padding}${a1}${padding}${second}${padding}${a2}${padding}${third}${padding}${padding}${fourth}${padding}${padding}${fifth}${padding}"
			;;
		2)
			echo "${a2}${padding}${first}${padding}${padding}${second}${padding}${a1}${padding}${third}${padding}${a2}${padding}${fourth}${padding}${padding}${fifth}${padding}"
			;;
		3)
			echo "${a2}${padding}${first}${padding}${padding}${second}${padding}${padding}${third}${padding}${a1}${padding}${fourth}${padding}${a2}${padding}${fifth}${padding}"
			;;
		4)
			echo "${a2}${padding}${first}${padding}${padding}${second}${padding}${padding}${third}${padding}${padding}${fourth}${padding}${a1}${padding}${fifth}${padding}${a2}"
	esac
}

window() {
	cur="$(xdotool getwindowname $(xdotool getactivewindow) | head -c 150)"
	if [[ "$cur" ]] ; then
		echo "$padding$cur$padding"
	else
		:
	fi
}

mpd() {
	artist="$(mpc -f '%artist%' | head -1 | sed 's/\;/ + /')"
	song="$(mpc -f '%title%' | head -1 | sed 's/(feat\./( +/')"
	progress="$(mpc | sed 's/.*(//;s/)//;2q;d')"
	if [ "$(mpc current)" ] ; then
		echo "$a2$padding$artist : $song : $progress$padding$bg"
	else
		:
	fi
}

spotify() {
	current="$(sps 'current' | sed 's/ \- / \: /')"
	if [ "$current" == "No media player is currently running" ] ; then
		:
	else
		echo "$a2$padding$current$padding$bg"
	fi
}

weather() {
	file="/tmp/weather"
	cat "$file"
}

clock() {
	date "+%R"
}

battery() {
	percent="$(cat '/sys/class/power_supply/'$battery'/capacity')"
	status="$(cat '/sys/class/power_supply/'$battery'/status')"
	if [[ $status == "Unknown" || $status == "Charging" || $status == "Full" ]] ; then
		if [[ $percent -gt 95 ]] ; then
			echo "$a3$padding⮏$padding$a3"
		else
			echo "$a3$padding$percent%$padding$bg"
		fi
	else
		echo "$a2$padding$percent%$padding$bg"
	fi
}

irc() {
	pgrep -f "urxvt -name irc" > /dev/null 2>&1
	if [ "$?" -ne "1" ] ; then
		echo "$a3$padding :: $padding$bg"
	else
		:
	fi
}


# loops
desktop_loop() {
	while :; do
		echo "%{l}\
		$(desktop)$bg\
		%{A2:cover &:}%{A:mpc 'toggle' &:}%{A3:urxvt -e 'ncmpcpp' &:}$(mpd)%{A}%{A}%{A:sps 'play' &:}$(spotify)$padding%{A}%{A}$bg\
		%{r}\
		$a2%{A:calendar &:}$padding$(clock)$padding%{A}$bg\
		%{A:toggle-tch &:}$(irc)%{A}$bg"
		sleep "$refresh"
	done |\

	lemonbar \
		-f "$font" \
		-f "$font2" \
		-f "$font3" \
		-f "$font4" \
		-g "x$height" \
		-F "$text" \
		-B "$background" \
		-b \
	| bash
}

laptop_loop() {
	while :; do
		echo "%{l}\
		$a3$(window)$bg\
		%{A2:cover &:}%{A:mpc 'toggle' &:}%{A3:urxvt -e 'ncmpcpp' &:}$(mpd)%{A}%{A}%{A:sps 'play' &:}$(spotify)$padding%{A}%{A}$bg\
		%{r}\
		$a2%{A:calendar &:}$padding$(clock)$padding%{A}$bg\
		%{A:batstat &:}$(battery)%{A}$bg\
		%{A:toggle-tch &:}$(irc)%{A}$bg"
		sleep "$refresh"
	done |\

	lemonbar \
		-f "$font" \
		-f "$font2" \
		-f "$font3" \
		-f "$font4" \
		-g "x$height" \
		-F "$text" \
		-B "$background" \
		-b \
	| bash
}


# exec
if [ -f "/sys/class/power_supply/$battery/status" ] ; then
	laptop_loop
else
	desktop_loop
fi