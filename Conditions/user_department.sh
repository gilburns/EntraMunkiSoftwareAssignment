#!/bin/sh

# Checks for existence of named preference file key
# Something like this: /Library/Managed Preferences/com.companyname.userdepartment
# Then looking in the plist for the value of the key 'department'
# In the installable condition, you would then define it like this:
#    user.department == "Finance"

# See this git repo for detailed instructions
# https://github.com/gilburns/EntraMunkiSoftwareAssignment
#

DEFAULTS=/usr/bin/defaults
DEPARTMENT_CHECK="com.companyname.userdepartment"
MANAGED_PREFS="/Library/Managed Preferences"

#
# Detect Munki installation path
#
MUNKI_DIR=$("$DEFAULTS" read "/Library/Managed Preferences/ManagedInstalls.plist" ManagedInstallDir 2>/dev/null)
if [ -z "$MUNKI_DIR" ]; then
	echo "No Managed Installs directory..."
	exit 1
else
	COND_DOMAIN="$MUNKI_DIR/ConditionalItems"
fi

#
# Check for user department
#
USER_DEPARTMENT=$("${DEFAULTS}" read "${MANAGED_PREFS}/${DEPARTMENT_CHECK}.plist" department 2>/dev/null)

if [ ! -z "${USER_DEPARTMENT}" ]; then
	"$DEFAULTS" write "$COND_DOMAIN" "user.department" -string "${USER_DEPARTMENT}"
fi

