---
layout:     default
title:      Erasing a Mac Disk
date:       2021-12-09
editdate:   2021-12-09
categories: MacAdmin
disqus_id:  erasing-a-mac-disk.html
---

I have done this enough times to be completely annoyed at the difficulty but not enough times to have committed it to memory. Therefore it belongs on my website so I can look it up one last time. Actually it's not quite done so this page will be changing over time.

## Disk Utility

First try this:

- Open Disk Utility, select View in top left and Show All Devices
- Select the parent device of the APFS volume
- Erase it

## Delete Sierra APFS partition

	diskutil list

Get the disk identifier of type "Apple_APFS" (e.g. disk2s3)

	diskutil apfs deleteContainer <identifier>

[Delete Sierra APFS partition](https://www.macobserver.com/tips/deep-dive/macos-sierra-delete-apfs-partition-right-way/)

## Booting to Recovery Mode

### ARM (M1/Apple Silicon)

Turn off Mac. Press and hold the power button until you see the startup options window.

### Intel

Restart Mac and hold one of these key combinations.

- Command-R: Built-in Recovery Mode
- Option-Command-R: Internet Recovery Mode. Boots the latest macOS that is compatible with your Mac.
- Shift-Option-Command-R: Boots the macOS that came with your Mac, or the closest version still available.

Exceptions

If you replaced the logic board, it might boot the latest macOS that is compatible.

If you just erased your entire startup disk, it might boot the macOS that came with your Mac, or the closest version still available. 

Sources

- [Mac startup key combinations](https://support.apple.com/en-us/HT201255)
- [About macOS Recovery on Intel-based Mac computers](https://support.apple.com/en-us/HT201314)
- [How to reinstall macOS](https://support.apple.com/en-us/HT204904)
- [Create a bootable installer](https://support.apple.com/en-us/HT201372)
- [How to get old versions of macOS](https://support.apple.com/en-us/HT211683)
