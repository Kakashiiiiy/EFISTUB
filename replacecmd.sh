#! /bin/sh
#
#
echo "Do you want to use your /proc/cmdline[0] or speficy the line by yourself[1]"

read choose

if [[ $choose -eq 0 ]]; then
	CMDLINE=$(cat /proc/cmdline)
else
	echo "Use '/' instead of '\' for your path it will be replaced"
	read CMDLINE
fi

CMDLINE="${CMDLINE//'\'/'\\\\'}" #Replaced with 4 Cause sed trims
CMDLINE="${CMDLINE//'/'/'\\\\'}" #Replaced with 4 Cause sed trims

sed "s|PLACEHOLDERCMDLINE| $CMDLINE |g" efistub.c > main.c 