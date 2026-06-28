---
layout: default
title: macOS Dock
date: 2026-05-27
---

This is how I manage my Dock with Jamf. Note, these computers are student classroom computers, so I want the Dock to always be the same.

I use [jctl](https://github.com/univ-of-utah-marriott-library-apple/python-jamf).

This is how I creating Dock items.

```
jctl dockitems --use-the-force-luke --andele-andele -c "App Store"
jctl dockitems --use-the-force-luke --andele-andele -n "App Store"  -u path="file://localhost/System/Applications/App Store.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "BBEdit"
jctl dockitems --use-the-force-luke --andele-andele -n "BBEdit"  -u path="file://localhost/Applications/BBEdit.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Calendar"
jctl dockitems --use-the-force-luke --andele-andele -n "Calendar"  -u path="file://localhost/System/Applications/Calendar.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Console"
jctl dockitems --use-the-force-luke --andele-andele -n "Console"  -u path="file://localhost/System/Applications/Utilities/Console.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Contacts"
jctl dockitems --use-the-force-luke --andele-andele -n "Contacts"  -u path="file://localhost/System/Applications/Contacts.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Directory Utility"
jctl dockitems --use-the-force-luke --andele-andele -n "Directory Utility" -u path="file://localhost/System/Library/CoreServices/Applications/Directory Utility.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Disk Utility"
jctl dockitems --use-the-force-luke --andele-andele -n "Disk Utility"  -u path="file://localhost/System/Applications/Utilities/Disk Utility.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "FaceTime"
jctl dockitems --use-the-force-luke --andele-andele -n "FaceTime"  -u path="file://localhost/System/Applications/FaceTime.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Firefox"
jctl dockitems --use-the-force-luke --andele-andele -n "Firefox"  -u path="file://localhost/Applications/Firefox.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Freeform"
jctl dockitems --use-the-force-luke --andele-andele -n "Freeform"  -u path="file://localhost/System/Applications/Freeform.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Google Chrome"
jctl dockitems --use-the-force-luke --andele-andele -n "Google Chrome"  -u path="file://localhost/Applications/Google Chrome.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Keychain Access"
jctl dockitems --use-the-force-luke --andele-andele -n "Keychain Access"  -u path="file://localhost/System/Library/CoreServices/Applications/Keychain Access.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "LaunchPad"
jctl dockitems --use-the-force-luke --andele-andele -n "LaunchPad"  -u path="file://localhost/System/Applications/LaunchPad.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Mail"
jctl dockitems --use-the-force-luke --andele-andele -n "Mail"  -u path="file://localhost/System/Applications/Mail.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Maps"
jctl dockitems --use-the-force-luke --andele-andele -n "Maps"  -u path="file://localhost/System/Applications/Maps.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Messages"
jctl dockitems --use-the-force-luke --andele-andele -n "Messages"  -u path="file://localhost/System/Applications/Messages.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Microsoft Excel"
jctl dockitems --use-the-force-luke --andele-andele -n "Microsoft Excel"  -u path="file://localhost/Applications/Microsoft Excel.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Microsoft OneNote"
jctl dockitems --use-the-force-luke --andele-andele -n "Microsoft OneNote" -u path="file://localhost/Applications/Microsoft OneNote.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Microsoft Word"
jctl dockitems --use-the-force-luke --andele-andele -n "Microsoft Word"  -u path="file://localhost/Applications/Microsoft Word.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Music"
jctl dockitems --use-the-force-luke --andele-andele -n "Music"  -u path="file://localhost/System/Applications/Music.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Network"
jctl dockitems --use-the-force-luke --andele-andele -n "Network"  -u path="file://localhost/System/Library/PreferencePanes/Network.prefPane" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "News"
jctl dockitems --use-the-force-luke --andele-andele -n "News"  -u path="file://localhost/System/Applications/News.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Notes"
jctl dockitems --use-the-force-luke --andele-andele -n "Notes"  -u path="file://localhost/System/Applications/Notes.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Photos"
jctl dockitems --use-the-force-luke --andele-andele -n "Photos"  -u path="file://localhost/System/Applications/Photos.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Reminders"
jctl dockitems --use-the-force-luke --andele-andele -n "Reminders"  -u path="file://localhost/System/Applications/Reminders.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Safari"
jctl dockitems --use-the-force-luke --andele-andele -n "Safari"  -u path="file://localhost/Applications/Safari.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "StartupDisk"
jctl dockitems --use-the-force-luke --andele-andele -n "StartupDisk"  -u path="file://localhost/System/Library/PreferencePanes/StartupDisk.prefPane" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "System Settings"
jctl dockitems --use-the-force-luke --andele-andele -n "System Settings"  -u path="file://localhost/System/Applications/System Settings.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Terminal"
jctl dockitems --use-the-force-luke --andele-andele -n "Terminal"  -u path="file://localhost/System/Applications/Utilities/Terminal.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "TV"
jctl dockitems --use-the-force-luke --andele-andele -n "TV"  -u path="file://localhost/System/Applications/TV.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Numbers"
jctl dockitems --use-the-force-luke --andele-andele -n "Numbers"  -u path="file://localhost/Applications/Numbers.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Pages"
jctl dockitems --use-the-force-luke --andele-andele -n "Pages"  -u path="file://localhost/Applications/Pages.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Keynote"
jctl dockitems --use-the-force-luke --andele-andele -n "Keynote"  -u path="file://localhost/Applications/Keynote.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Phone"
jctl dockitems --use-the-force-luke --andele-andele -n "Phone"  -u path="file://localhost/System/Applications/Phone.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "Games"
jctl dockitems --use-the-force-luke --andele-andele -n "Games"  -u path="file://localhost/System/Applications/Games.app" -u type="App"
jctl dockitems --use-the-force-luke --andele-andele -c "iPhone Mirroring"
jctl dockitems --use-the-force-luke --andele-andele -n "iPhone Mirroring"  -u path="file://localhost/System/Applications/iPhone Mirroring.app" -u type="App"
```

Then I remove the default macOS 26 Dock items (except Safari).

```
jctl -n "Remove Default macOS 26 Dock Items" -j -u "dock_items"='{"dock_item": [\
{"name": "App Store", "action": "Remove"},\
{"name": "Calendar", "action": "Remove"},\
{"name": "Contacts", "action": "Remove"},\
{"name": "FaceTime", "action": "Remove"},\
{"name": "Freeform", "action": "Remove"},\
{"name": "Games", "action": "Remove"},\
{"name": "iPhone Mirroring", "action": "Remove"},\
{"name": "Keynote", "action": "Remove"},\
{"name": "LaunchPad", "action": "Remove"},\
{"name": "Mail", "action": "Remove"},\
{"name": "Maps", "action": "Remove"},\
{"name": "Messages", "action": "Remove"},\
{"name": "Music", "action": "Remove"},\
{"name": "News", "action": "Remove"},\
{"name": "Notes", "action": "Remove"},\
{"name": "Numbers", "action": "Remove"},\
{"name": "Pages", "action": "Remove"},\
{"name": "Phone", "action": "Remove"},\
{"name": "Photos", "action": "Remove"},\
{"name": "Reminders", "action": "Remove"},\
{"name": "System Settings", "action": "Remove"},\
{"name": "TV", "action": "Remove"}\
]}'
```

Then I have a policy to add what I want (in reverse order).

```
jctl policies -n "Dock Room 106" -j -u "dock_items"='{"dock_item": [\
{"name": "Microsoft Word", "action": "Add To Beginning"},\
{"name": "Microsoft PowerPoint", "action": "Add To Beginning"},\
{"name": "Microsoft Excel", "action": "Add To Beginning"},\
{"name": "Google Chrome", "action": "Add To Beginning"},\
{"name": "Firefox", "action": "Add To Beginning"},\
{"name": "Safari", "action": "Add To Beginning"},\
]}'
```

## dockutil

This is an old script I used to use. It utilizes [dockutil](https://github.com/kcrawford/dockutil) and is extremely customizable. I quit using it because I was trying to simplify my setup (by relying more on Jamf).

[user_dock.pl](https://github.com/magnusviri/random-macadmin/blob/main/user_dock.pl)

