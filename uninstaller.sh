#!/bin/bash

UnloadAgentForAllUsers() {
  plistFilePath="$1"
  localAccountNameList=$(/usr/bin/dscl . list /Users UniqueID | /usr/bin/awk '$2 > 500 && $2 < 999 {print $1}')
  # Unload as each user
  for localAccountName in $localAccountNameList;do
    /usr/bin/sudo -u "$localAccountName" /bin/launchctl unload "/Users/${localAccountName%%/}$plistFilePath" &> /dev/null
  done
  # Unload as root
  /bin/launchctl unload "$plistFilePath" &> /dev/null
}

RemoveFilesForAllUsers() {
  plistFilePath="$1"
  localAccountNameList=$(/usr/bin/dscl . list /Users UniqueID | /usr/bin/awk '$2 > 500 && $2 < 999 {print $1}')
  # Remove as each user
  for localAccountName in $localAccountNameList;do
    /bin/rm -rf "/Users/${localAccountName%%/}$plistFilePath"
  done
  # Remove as root
  /bin/rm -rf "$plistFilePath"
}

# Run vendor uninstaller
vendorUninstallerPathList=(
  "/Library/Application Support/Juniper Networks/Junos Pulse/Uninstall.app/Contents/Resources/uninstall.sh"
  "/Library/Application Support/Pulse Secure/Pulse/Uninstall.app/Contents/Resources/uninstall.sh"
)
for vendorUninstallerPath in "${vendorUninstallerPathList[@]}"; do
  if [ -e "$vendorUninstallerPath" ];then
    /bin/sh "$vendorUninstallerPath"
  fi
done

# Remove and unload agents
UnloadAgentForAllUsers "/Library/LaunchAgents/net.pulsesecure.SetupClient.plist"
RemoveFilesForAllUsers "/Library/LaunchAgents/net.pulsesecure.SetupClient.plist"

UnloadAgentForAllUsers "/Library/LaunchAgents/net.pulsesecure.pulsetray.plist"
RemoveFilesForAllUsers "/Library/LaunchAgents/net.pulsesecure.pulsetray.plist"

UnloadAgentForAllUsers "/Library/LaunchDaemons/net.pulsesecure.AccessService.plist"
RemoveFilesForAllUsers "/Library/LaunchDaemons/net.pulsesecure.AccessService.plist"

UnloadAgentForAllUsers "/Library/LaunchDaemons/net.pulsesecure.UninstallPulse.plist"
RemoveFilesForAllUsers "/Library/LaunchDaemons/net.pulsesecure.UninstallPulse.plist"


# Kill processes
/usr/bin/killall "Junos Pulse"
/usr/bin/killall "Pulse Secure"

# Remove application supports
RemoveFilesForAllUsers "/Library/Application Support/Pulse Secure"
RemoveFilesForAllUsers "/Library/Application Support/Juniper Networks/Junos Pulse"

# Remove caches
RemoveFilesForAllUsers "/Library/Caches/net.pulsesecure.Pulse-Secure"

# Remove logs
RemoveFilesForAllUsers "/Library/Logs/Pulse Secure"

# Remove app
/bin/rm -rf "/Applications/Pulse Secure.app"
/bin/rm -rf "/Applications/Junos Pulse.app"

exit 0
