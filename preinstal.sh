#!/bin/bash

gp="$(pgrep giteapanel)"

if [[ $gp -ne "" ]]; then
	echo "giteapanel find!"
	# killall giteapanel
fi

#mkdir -p /usr/share/giteapanel/locale

exit 0
