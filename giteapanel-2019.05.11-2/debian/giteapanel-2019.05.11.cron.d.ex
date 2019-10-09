#
# Regular cron jobs for the giteapanel-2019.05.11 package
#
0 4	* * *	root	[ -x /usr/bin/giteapanel-2019.05.11_maintenance ] && /usr/bin/giteapanel-2019.05.11_maintenance
