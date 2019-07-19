# Pulse Secure Uninstaller

This is a script to completely remove Pulse Secure for macOS.

## Why don't we use the vendor uninstaller?

The vendor uninstaller is incomplete for a perfect removal.

## Usage

```sh
sudo ./uninstaller.sh
```

## Uninstall Policy

### Why does not this script use pkgutil --forget?

Using `pkgutil --forget xxxx` command will wipe out the installed trail. This script leaves it to each person's decision, as the ability to clear the trail is different for each use case.
