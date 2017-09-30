#!/usr/bin/env bash

# vars
cil="/tmp/calendar.png"
bg="/usr/scripts/popup/img/bg.png"

# convert the output to png
convert -background "rgba(0,0,0,0)" \
		-fill white \
		-font "kakwafont-12-n" \
		+antialias \
		-pointsize 12 \
		label:"$(date "+%d %B %Y\n" && cal | tail -n7)" \
		"$cil"

# display it
if [ "$1" == "d" ] ; then
	sleep ".1s"
	popup.sh "img" "$bg" "858" -p "954" &
	sleep ".05s"
	n30f -t "popup" -x "898" -y "110" -c "killall n30f" "$cil"
elif [ "$1" == "l" ] ; then
	sleep ".1s"
	popup.sh "img" "$bg" "581" -p "677" &
	sleep ".05s"
	n30f -t "popup" -x "622" -y "110" -c "killall n30f" "$cil"
else
	:
fi

# delete it
sleep ".2s"
rm "$cil"