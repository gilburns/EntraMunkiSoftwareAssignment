#!/bin/sh

# Checks for existence of named preference file key
# Something like this: /Library/Managed Preferences/com.companyname.useroffice
# Then looking in the plist for the value of the key 'office'
# In the installable condition, you would then define it like this:
#    user.office == "Headquarters"

# See this git repo for detailed instructions
# https://github.com/gilburns/EntraMunkiSoftwareAssignment
#

DEFAULTS=/usr/bin/defaults
OFFICE_CHECK="com.companyname.useroffice"
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
# Check for user office location
#
USER_OFFICE=$("${DEFAULTS}" read "${MANAGED_PREFS}/${OFFICE_CHECK}.plist" office 2>/dev/null)

if [ ! -z "${USER_OFFICE}" ]; then
	"$DEFAULTS" write "$COND_DOMAIN" "user.office" -string "${USER_OFFICE}"
fi

