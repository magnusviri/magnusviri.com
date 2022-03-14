---
layout:     default
title:      Removing Mac OS X ACLs and Extended Attributes, and deleting Time Machine backups
date:       2014-04-15
editdate:   2020-05-11
categories: MacAdmin
disqus_id:  removing-mac-os-x-acls-and-extended-attributes.html
---

[Update 2017-10-27: Added information about `chflags norestricted`

[Update 2017-10-07: Added a little more information about ACL's and Extended Attributes]

2014-04-15

This is just a collection of commands to get around Mac OS X's extra file stuff that keep getting in my way.

#### Recursively Removing ACLs

When you run `ls -al` and you see a "+" at the end of the permissions that means there are ACLs (Access Control List).

    drwx------+ 32530 root  wheel   1106020 Oct  6 12:25 .

You can see the ACL with `ls -ale`

    drwx------+ 32530 root  wheel   1106020 Oct  6 12:25 .
    &nbsp;0: group:everyone deny add_file,delete,add_subdirectory,delete_child,writeattr,writeextattr,chown

You can recursively remove these ACL's with this command.

    chmod -RN /path/to/directory

#### Recursively Removing Extended Attributes

When you run `ls -al` and you see a "@" at the end of the permissions that means there are extended attributes.

    drwx------@ 32530 root  wheel   1106020 Oct  6 12:25 .

You can see the extended attributes with `ls -ale`

    drwx------@ 32530 root  wheel   1106020 Oct  6 12:25 .
        com.apple.metadata:_kTimeMachineNewestSnapshot      50
        com.apple.metadata:_kTimeMachineOldestSnapshot      50

You can remove all extended attributes with this command.

    xattr -rc /path/to/directory

Or you can remove specific attributes with this command.

    xattr -rd com.apple.NAME /path/to/directory

I usually remove extended attributes (and ACLs) for files I copy from TimeMachine or from files I download from the internet.

Here are the types of files that depend on extended attributes.  So if you delete these extended attributes, you basically are deleting the contents of the file.

- .DS_Store
- Text clippings (any time you select text, click and hold on it, then drag it to the desktop)
- Web links (same as a text clipping but it's a url)
- Icon files (get info on an item, click it's icon in the Get Info panel, copy, then go to another Get Info panel and paste it)

#### Recursively Removing Files in Time Machine backups

You can delete files using the Time Machine app, but if you want to do more then that, there are ways to do it with the Terminal.  To delete *some* files in a Time Machine backup.

    tmutil delete /Volumes/[disk]/Backups.backupdb/HOST/DATE_FOLDER

To completely delete *all* backups use bypass.  Note, you should not use this to delete *some* files because using bypass + rm will delete files in other backups, so if you want to delete only some, use the tmutil option.

10.7

    sudo /System/Library/Extensions/TMSafetyNet.kext/Contents/MacOS/bypass rm -rfv /Volumes/[disk]/Backups.backupdb

10.8+

    sudo /System/Library/Extensions/TMSafetyNet.kext/Helpers/bypass rm -rfv /Volumes/[disk]/Backups.backupdb

#### Disabling SIPs (System Integrity Protection)

Starting in 10.11 Apple added a feature called [System Integrity Protection](https://en.wikipedia.org/wiki/System_Integrity_Protection) that prevents users from removing certain files, mainly system files.  Among the protected directories are: /System, /bin, /sbin, /usr (but not /usr/local) and others.

This is a fun one to get around.  To run this command you must *reboot* your computer. that's right, boot to the Recovery HD partition.  See [this document](https://support.apple.com/en-us/HT204904) if you don't know how.  Then open Terminal and run these commands.

Turn off SIPs for a specific file

    chflags norestricted /path

Turn off SIPs for a path

    chflags -R norestricted /path

Turn off SIPs completely (I do not recommend this)

    csrutil disable

There is far more information on [Stackexchange](https://apple.stackexchange.com/questions/208478/how-do-i-disable-system-integrity-protection-sip-aka-rootless-on-os-x-10-11#208481)
