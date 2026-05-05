---
layout: default
title: Configuration Profiles
date: 2026-05-05
---

## Tools

- [Apple Configurator 2](https://apps.apple.com/us/app/apple-configurator-2/id1037126344?mt=12)
- [ProfileManifests](https://github.com/ProfileManifests/ProfileManifests)
- [ProfileCreator](https://github.com/ProfileCreator/ProfileCreator)
- [iMazing Profile Editor](https://imazing.com/profile-editor)

## Applications

### Get the Team Identifier (look for "TeamIdentifier") and BundleID (look for "Identifier")

NOTE: if you're adding an extension (see below), make sure you specify the extension and not the parent app.

```
codesign -dv --verbose=4 /path/to/application.app/Contents/Library/SystemExtensions/name.of.extension.systemextension
```

Example:

```
> codesign -dv --verbose=4 /Applications/GlobalProtect.app/Contents/Library/SystemExtensions/com.paloaltonetworks.GlobalProtect.client.extension.systemextension
Executable=/Applications/GlobalProtect.app/Contents/Library/SystemExtensions/com.paloaltonetworks.GlobalProtect.client.extension.systemextension/Contents/MacOS/com.paloaltonetworks.GlobalProtect.client.extension
Identifier=com.paloaltonetworks.GlobalProtect.client.extension
Format=bundle with Mach-O universal (x86_64 arm64)
CodeDirectory v=20500 size=21055 flags=0x10000(runtime) hashes=646+7 location=embedded
VersionPlatform=1
VersionMin=720896
VersionSDK=786688
Hash type=sha256 size=32
CandidateCDHash sha256=212290eba66678e26cdf340ce942255859f0e760
CandidateCDHashFull sha256=212290eba66678e26cdf340ce942255859f0e76035734fc4790fb470d39dca02
Hash choices=sha256
CMSDigest=212290eba66678e26cdf340ce942255859f0e76035734fc4790fb470d39dca02
CMSDigestType=2
Executable Segment base=0
Executable Segment limit=1818624
Executable Segment flags=0x1
Page size=4096
CDHash=212290eba66678e26cdf340ce942255859f0e760
Signature size=9077
Authority=Developer ID Application: Palo Alto Networks (PXPZ95SK77)
Authority=Developer ID Certification Authority
Authority=Apple Root CA
Timestamp=Jul 15, 2025 at 13:59:11
Info.plist entries=24
TeamIdentifier=PXPZ95SK77
Runtime Version=12.1.0
Sealed Resources version=2 rules=13 files=1
Internal requirements count=1 size=244
```

- Bundle ID: com.paloaltonetworks.GlobalProtect.client.extension
- Team Identifier: PXPZ95SK77

### Get the Code Requirement

```
codesign -dr - /path/to/application
```

Example.

```
> codesign -dr - /Applications/GlobalProtect.app/Contents/Library/SystemExtensions/com.paloaltonetworks.GlobalProtect.client.extension.systemextension
Executable=/Applications/GlobalProtect.app/Contents/Library/SystemExtensions/com.paloaltonetworks.GlobalProtect.client.extension.systemextension/Contents/MacOS/com.paloaltonetworks.GlobalProtect.client.extension
designated => anchor apple generic and identifier "com.paloaltonetworks.GlobalProtect.client.extension" and (certificate leaf[field.1.2.840.113635.100.6.1.9] /* exists */ or certificate 1[field.1.2.840.113635.100.6.2.6] /* exists */ and certificate leaf[field.1.2.840.113635.100.6.1.13] /* exists */ and certificate leaf[subject.OU] = PXPZ95SK77)
```

The Code Requirement is:

> anchor apple generic and identifier "com.paloaltonetworks.GlobalProtect.client.extension" and (certificate leaf[field.1.2.840.113635.100.6.1.9] /* exists */ or certificate 1[field.1.2.840.113635.100.6.2.6] /* exists */ and certificate leaf[field.1.2.840.113635.100.6.1.13] /* exists */ and certificate leaf[subject.OU] = PXPZ95SK77)
https://support.addigy.com/hc/en-us/articles/4403542583187-How-to-Get-the-Team-ID-Bundle-ID-and-Code-Requirement

## System Extensions

View applications that have System Extensions inside their bundle.

```
ls -l /Applications/*/Contents/Library/SystemExtensions
```

Example:

```
/Applications/GlobalProtect.app/Contents/Library/SystemExtensions:
total 0
drwxr-xr-x  3 root  wheel  96 Jul 15  2025 com.paloaltonetworks.GlobalProtect.client.extension.systemextension

/Applications/Microsoft Defender.app/Contents/Library/SystemExtensions:
total 0
drwxr-xr-x  3 root  wheel  96 Apr 14 13:08 com.microsoft.wdav.epsext.systemextension
drwxr-xr-x  3 root  wheel  96 Apr 14 14:18 com.microsoft.wdav.netext.systemextension

/Applications/OBS.app/Contents/Library/SystemExtensions:
total 0
drwxr-xr-x  3 root  wheel  96 Apr 21 13:44 com.obsproject.obs-studio.mac-camera-extension.systemextension
```

The Bundle ID of these extensions are (verify it with the `codesign -dv command`):

- com.paloaltonetworks.GlobalProtect.client.extension
- com.microsoft.wdav.epsext
- com.microsoft.wdav.netext.systemextension
- com.obsproject.obs-studio.mac-camera-extension

To view system extensions (note, some installed system extensions might not show up unless they try to run first). Go to 'System Settings > General > Login Items & Extensions > Network Extensions' to see these system extensions. Or run this.

```
systemextensionsctl list
```

[Apple's Docs](https://developer.apple.com/documentation/devicemanagement/systemextensions)

- AllowedSystemExtensionTypes
- AllowedSystemExtensions
- NonRemovableFromUISystemExtensions - can’t be disabled or uninstalled from System Settings or Finder.
- NonRemovableSystemExtensions - can’t be disabled or uninstalled when SIP is enabled.
- RemovableSystemExtensions - allowed to remove themselves from the machine.

NonRemovable and Removable are opposites, so having them both for the same thing is an error.

### Signing Configuration Profiles

- [Create a signing certificate using Jamf's built-in certificate authority](https://learn.jamf.com/r/en-US/technical-articles/Creating_a_Signing_Certificate_Using_Jamf_Pros_Built-in_CA_to_Use_for_Signing_Configuration_Profiles_and_Packages).

CertificateName is the name of the cert created above.

```
security cms -S -N "CertificateName" -i /path/to/unsigned/file.mobileconfig -o /path/to/new/signed/file.mobileconfig
```

Also, Apple Configurator 2 has an "Sign Profile..." option in the "File" menu.

### Unsigning Configuration Profile

```
security cms -D -i ~/Desktop/license.mobileconfig > ~/Desktop/license_unsigned.mobileconfig
```

Also, Apple Configurator 2 has an "Unsign Profile" option in the "File" menu