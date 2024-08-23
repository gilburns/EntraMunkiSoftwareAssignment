#!/bin/sh

# Checks for existence of named preference file key
# Something like this: /Library/Managed Preferences/com.companyname.usercountry
# Then looking in the plist for the value of the key 'code2'
# In the installable condition, you would then define it like this:
#    user.country == "US"

# See this git repo for detailed instructions
# https://github.com/gilburns/EntraMunkiSoftwareAssignment
#

DEFAULTS=/usr/bin/defaults
COUNTRY_CHECK="com.companyname.usercountry"
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
# Check for user country location
#
USER_COUNTRY=$("${DEFAULTS}" read "${MANAGED_PREFS}/${COUNTRY_CHECK}.plist" code2 2>/dev/null)

if [ ! -z "${USER_COUNTRY}" ]; then
	"$DEFAULTS" write "$COND_DOMAIN" "user.country" -string "${USER_COUNTRY}"
fi

