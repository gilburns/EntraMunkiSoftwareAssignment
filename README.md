# Entra Munki Software Assignment

## Overview

The Entra Munki Software Assignment system allows you to use Entra ID (formerly Azure AD) dynamic or static groups to directly scope software assignments in Munki using Munki-Conditions. This integration enables automated software deployment based on user attributes such as department, location, and assigned software packages.

## How It Works

The system operates by:

1. **Entra ID Configuration**: User attributes and group memberships are configured in Entra ID
2. **Intune/MDM Deployment**: Configuration profiles deploy managed preferences to macOS devices
3. **Munki Conditions**: Shell scripts read these preferences and create Munki conditional items
4. **Software Assignment**: Munki uses these conditions to determine which software to install

## Architecture

```
Entra ID Groups → Intune Configuration Profiles → Managed Preferences → Munki Conditions → Software Installation
```

## Components

### Condition Scripts

The system includes several condition scripts that monitor different aspects of user assignment:

#### Software Assignment (`software_assignment.sh`)
- **Purpose**: Detects assigned software titles for users
- **Reads**: `/Library/Managed Preferences/com.companyname.software.*`
- **Creates**: Conditions like `software.title == "Yes"`
- **Use Case**: Deploy specific software packages to assigned users

#### User Department (`user_department.sh`)
- **Purpose**: Identifies user's department affiliation
- **Reads**: `/Library/Managed Preferences/com.companyname.userdepartment.plist`
- **Creates**: Conditions like `user.department == "Finance"`
- **Use Case**: Deploy department-specific software and configurations

#### User Location - Country (`user_location_country.sh`)
- **Purpose**: Determines user's country location
- **Reads**: `/Library/Managed Preferences/com.companyname.usercountry.plist`
- **Creates**: Conditions like `user.country == "US"`
- **Use Case**: Deploy region-specific software or comply with local regulations

#### User Location - Office (`user_location_office.sh`)
- **Purpose**: Identifies user's office location
- **Reads**: `/Library/Managed Preferences/com.companyname.useroffice.plist`
- **Creates**: Conditions like `user.office == "Headquarters"`
- **Use Case**: Deploy location-specific resources or printers

### Configuration Templates

The `Configuration/Templates/Preference File/` directory contains XML templates for various scenarios:

#### Department Templates
- `com.companyname.userdepartment-Finance.xml`
- `com.companyname.userdepartment-Creative.xml`
- `com.companyname.userdepartment-Marketing.xml`
- `com.companyname.userdepartment-HumanResources.xml`

#### Country Templates
- `com.companyname.usercountry-USA.xml`
- `com.companyname.usercountry-GBR.xml`

#### Office Templates
- `com.companyname.office-Headquarters.xml`

#### Software Assignment Templates
- `com.companyname.software.snagit.xml`
- `com.companyname.software.telegram.xml`

## Installation

### Prerequisites
- Munki environment configured and operational
- Intune or other MDM solution capable of deploying configuration profiles
- Entra ID with appropriate user attributes configured

### Setup Steps

1. **Deploy Condition Scripts**
   ```bash
   # Copy condition scripts to Munki conditions directory
   sudo cp Conditions/*.sh /usr/local/munki/conditions/
   sudo chmod +x /usr/local/munki/conditions/*.sh
   ```

2. **Configure Munki to Run Conditions**
   - Add scripts to your Munki condition execution workflow
   - Ensure scripts run before Munki evaluates manifests

3. **Create Intune Configuration Profiles**
   - Use the XML templates in `Configuration/Templates/`
   - Create custom configuration profiles for each scenario

4. **Configure Entra ID Groups**
   - Create dynamic or static groups based on user attributes
   - Assign appropriate configuration profiles to groups

## Usage Examples

### Software Assignment Example

To assign software based on user assignment:

1. **Create Entra ID Group**: Users who should receive specific software
2. **Deploy Configuration Profile**: Contains `com.companyname.software.appname.xml`
3. **Munki Manifest Condition**:
   ```xml
   <key>installable_condition</key>
   <string>software.appname == "Yes"</string>
   ```

### Department-Based Assignment

To deploy software based on department:

1. **Set User Department**: In Entra ID user attributes
2. **Create Dynamic Group**: Based on department attribute
3. **Deploy Configuration Profile**: Contains department-specific preferences
4. **Munki Manifest Condition**:
   ```xml
   <key>installable_condition</key>
   <string>user.department == "Finance"</string>
   ```

### Location-Based Assignment

To deploy software based on user location:

1. **Configure Location Attributes**: Country/office in Entra ID
2. **Create Location Groups**: Dynamic groups for each location
3. **Deploy Location Profiles**: Appropriate configuration profiles
4. **Munki Manifest Conditions**:
   ```xml
   <key>installable_condition</key>
   <string>user.country == "US" AND user.office == "Headquarters"</string>
   ```

## Configuration

### Customizing Company Identifiers

Update the preference domain identifiers in all scripts:

```bash
# Change from default
SOFTWARE_CHECK="com.companyname.software"

# To your organization
SOFTWARE_CHECK="com.yourorg.software"
```

### Adding New Conditions

To create new condition types:

1. **Create New Script**: Based on existing script templates
2. **Define Preference Domain**: Choose appropriate identifier
3. **Create XML Templates**: For Intune configuration profiles
4. **Test Conditions**: Verify Munki recognizes new conditions

## Troubleshooting

### Common Issues

#### Conditions Not Appearing
- Verify scripts have execute permissions
- Check script paths in Munki configuration
- Ensure managed preferences are deployed correctly

#### Incorrect Condition Values
- Validate XML template syntax
- Confirm preference domain names match between scripts and profiles
- Check for typos in condition names

#### Software Not Installing
- Verify condition syntax in Munki manifests
- Check that condition values match exactly
- Review Munki logs for condition evaluation

### Debugging Commands

Check managed preferences:
```bash
sudo defaults read "/Library/Managed Preferences/com.companyname.software.appname"
```

Verify condition creation:
```bash
sudo defaults read "/path/to/munki/ConditionalItems"
```

Monitor Munki condition evaluation:
```bash
sudo /usr/local/munki/munki-python -c "import munki; print(munki.getConditions())"
```

## Best Practices

### Naming Conventions
- Use consistent preference domain naming
- Choose descriptive condition names
- Document all custom conditions

### Maintenance
- Regularly review and update condition scripts
- Test new configurations in development environment
- Keep documentation current with changes

## Related Resources

- [Munki Conditional Items Documentation](https://github.com/munki/munki/wiki/Conditional-Items#admin-provided-conditions)
- [Alternate Azure Automation Example](https://github.com/almenscorner/munki-manifest-generator)
- [Intune Configuration Profile Documentation](https://docs.microsoft.com/en-us/mem/intune/)

## Support

For issues and questions:
- Review troubleshooting section above
- Check Munki community resources
- Consult Intune documentation for MDM-related issues

---

*This documentation is for the Entra Munki Software Assignment project. For the latest updates and examples, visit the [project repository](https://github.com/gilburns/EntraMunkiSoftwareAssignment).*
