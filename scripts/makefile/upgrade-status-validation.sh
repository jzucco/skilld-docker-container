#!/usr/bin/env sh

# Enable Upgrade Status module
drush en -y upgrade_status

# Search for no issues message
REPORT=$(drush us-a --all --ignore-contrib --ignore-uninstalled)
IS_INVALID=$(echo "$REPORT" | grep "FILE:")

# Exit 1 and alert if at least one file was reported.
if [ -z "$IS_INVALID" ]; then
	drush pmu upgrade_status -y
	echo -e "Status report is valid : No error listed"
	exit 0
else
	printf "There are \033[1missue(s)\033[0m in Upgrade Status report to fix : \n- Go to \033[1m/admin/reports/upgrade-status\033[0m for more details\n"
	echo -e "$REPORT"
	exit 1
fi
