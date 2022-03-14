---
layout:     default
title:      macOS system log
date:       2021-12-06
editdate:   2021-12-06
categories: MacAdmin Networking
disqus_id:  macos-system-logs.html
---

These are my macOS system log notes.

## /var/log

Before macOS 10.12 the /var/log was useful.

Starting in macOS 10.12 Apple switched to what they call "unified logging". Logs are now stored in tracev3 formatted files located in /var/db/diagnostics. What's left is daily.out, monthly.out, wifi.log, install.log, cups, and a few other things. /var/log/system.log still exists and some things still use it but it's all useless information now.

In fact, since the change to unified logging, no matter how much I study it I've never been able to find any useful log information. But, I'm going to give it one more chance. And this time I'm going to document everything so I don't have to learn it all over again.

## sysdiagnose

Still works.

	sudo sysdiagnose –f ~/Desktop/

Or press these all at once: Shift + Control + Option + Command + Period .

Screen will flash. Wait 15 seconds - 5 minutes. A Finder window will open at /private/var/tmp. In there is a file named something like "sysdiagnose_<datetime>_macOS_<model>_<os-build>.tar". I just tried it and my file was 390 MB compressed (750 MB uncompressed). It contains a lot of information, including information that might be private. Here's a list of some of the things it contains.

- System profiler report
- Logs
- Spin and crash reports
- Several seconds of fs_usage ouput
- Several seconds of top output
- Status of loaded kernel extensions
- Memory usage and processes details
- Disk usage information (e.g. diskutil)
- I/O Kit registry information
- Network status
- Info regarding efi, nvram, launchctl, lsregister, csrutil, smc, thermal, etc

If running from the command line you can specify a specific process and get memory information on the process as well.

## Applications

/Applications/Utilities/Console.app is the Apple GUI to view logs (requires an admin password).

There's also /usr/bin/log.

And there's [Howard Oakley's applications](https://eclecticlight.co/downloads/).

- [T2M2, Ulbow, Consolation, Woodpile, Blowhole, etc](https://eclecticlight.co/consolation-t2m2-and-log-utilities/)
- [Mints](https://eclecticlight.co/mints-a-multifunction-utility/)

## Log Levels

- `default`
- `info`
- `debug`
- `fault`
- `error`

This changes the logging level for the com.krypted subdomain (aka Charles Edge).

	log config --mode "level:debug" --subsystem com.krypted

## log stream

You have to be an admin user.

To watch the logs as they come in

	log stream

You should limit the information with a "predicate" (a search/filter expression).

	log stream --predicate 'eventMessage contains "Twitter"'

See below for information about predicates.

## log show

To search saved log files

	log show

Add `--info` and/or `--debug` to get those log levels.

Add `--last <time>` to display the last specified time (mhd).

Add `--style` to change how it's displayed.

Examples

	log show --predicate 'eventMessage contains "Hello Logs"' --last 3m
	log show --style syslog --predicate 'eventMessage contains " "' --info --last 24h
	log show --style syslog --predicate 'eventMessage contains "Failed to authenticate user"' --info --last 1d

## Predicates

- `category`
- `eventMessage`
- `eventType` - type of events that created the entry
- `messageType` – type or level of a log entry
- `processImagePath` - process that logged the event
- `senderImagePath` - process, library, executable, etc that logged the event
- `subsystem` - Look in /System/Library/Preferences/Logging/Subsystems/ (On macOS 11.6 there are 247 files in there)

Operators (see [this page for more info](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-SW1))

- `&&` or `AND`
- `||` or `OR`
- `!` or `NOT`
- `=`
- `!=`
- `>`
- `<`
- `=>`
- `=<`
- `CONTAINS`
- `BEGINSWITH`
- `ENDSWITH`
- `LIKE` - Uses ? and * for wildcards (like the shell)
- `MATCHES` - [ICU v3 regex](https://unicode-org.github.io/icu/userguide/strings/regexp.html)
- `ANY`, `SOME` - e.g. `ANY children.age < 18` ¯\\_(ツ)_/¯
- `NONE`, `ALL`, `FALSE`, `NO`, `BETWEEN`, `FIRST`, `LAST`, etc
- `IN` - Equivalent to an SQL IN, e.g. `name IN { 'Ben', 'Melissa', 'Nick' }`
- `NULL` - a NULL response, e.g. "with error (NULL)"

Add `[c]` to any of these to make them case insensitive, e.g. `CONTAINS[c]`.

Add `[d]` to make it diacritic insensitive, e.g., `CONTAINS[cd] schon` will match "Schön", "Bitte schön", and "schönen" but afaik not "schoen".

## Find preferences using logs

I haven't tried this yet but I want to. Sounds cool.

- [Config Profile and manage ALL the things...just about](https://boberito.medium.com/config-profile-and-manage-all-the-things-just-about-cafea8627d4b)

## Links

- [Apple](https://developer.apple.com/documentation/os/logging)
- [Apple predicate guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html)
- [The Eclectic Light Company](https://eclecticlight.co/2018/03/19/macos-unified-log-1-why-what-and-how/)
- [Krypted](https://krypted.com/mac-os-x/logs-logging-logger-oh/)
