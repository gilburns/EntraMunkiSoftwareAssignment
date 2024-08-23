#!/bin/sh

# Checks for existence of named preference file
# Something like this: /Library/Managed Preferences/com.companyname.software.title
# In the installable condition, you would then define it like this:
#    software.title == "Yes"
# Where 'title' is the name... firefox, bbedit, etc

# See this git repo for detailed instructions
# https://github.com/gilburns/EntraMunkiSoftwareAssignment
#

DEFAULTS=/usr/bin/defaults
SOFTWARE_CHECK="com.companyname.software"
MANAGED_PREFS="/Library/Managed Preferences"

#
# Detect Munki installation path
#
MUNKI_DIR=$("$DEFAULTS" read /Library/Preferences/ManagedInstalls ManagedInstallDir)
if [ -z "$MUNKI_DIR" ]; then
	echo "No Managed Installs directory..."
	exit 1
else
	COND_DOMAIN="$MUNKI_DIR/ConditionalItems"
fi

#
# Check for Entra assigned software titles
#
IFS="
"

for PLIST_FILE in $(ls "${MANAGED_PREFS}"/"${SOFTWARE_CHECK}"* ); do
	TITLE=$(basename "${PLIST_FILE}" | cut -d. -f4)
	"$DEFAULTS" write "$COND_DOMAIN" "software.${TITLE}" -string "Yes"
done
