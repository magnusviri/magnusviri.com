---
layout:     default
title:      Radmind and "Applefiles"
date:       2012-03-13
editdate:   2020-05-11
categories: Graveyard
disqus_id:  radmind-and-applefiles.html
---

When using radmind on OS X radmind has to deal with some filesystem quirks that are unique to OS X.  A file is not just a file.  Besides the contents of the file, each file has metadata, information about the file.  The most basic metadata is the file name.  Other metadata includes permissions, creation date, last modification date, size, etc.,.  OS X also has metadata called extended file attributes.  Files can have an arbitrary number of extended attributes and the attributes have a name and data.

Radmind stores typical metadata like owner, permissions, and modification dates in transcripts.  Extended attributes need to be saved somehow or else some files could actually be destroyed.  Folders on OS X also have metadata beyond the typical and that data is stored in 2 places, as an extended attribute named com.apple.FinderInfo and in .DS_Store files that are in the folder.

Although some extended attributes (like the com.apple.ResourceFork) are absolutely required or else the file is destroyed, most is completely irrelevant and we do not ever want to upload it to the radmind server.  The radmind tool fsdiff is the tool that senses if a file has extended attributes or not and it does not have any way of deciding if extended attributes should be saved or not, so it saves it all.  So if you want to avoid uploading files with extended attributes to the server, you need to remove the extended attributes before you run fsdiff.

The different attributes are stored in different forks.  Forks are just different ways of linking data with the same file.  In the pre-OS X days of Mac OS, the "resource" forks stored images and other data like GUI information, and the "data" fork stored the normal data stored in files.

Extended attributes and radmind
---------------------

This is what fsdiff prints when it scans a file and folder with extended attributes.

    d ../Help/Contents    0755   0    0 AAAAAAAAAAABAAABAAAAAAAAAAAAAAAAAIAAAAAAAAA=
    a ../Help/Contents/Info.plist    0755   0    0 1217351645     836 4sKSZzoaSYAHSoI/wY+lXImdGQY=

The capital letters after the permissions on the directory is base64 encoded com.apple.FinderInfo extended attributes.  The "a" that starts the file line is the flag that the extended attributes for the file has been combined with with the file data, which is what radmind calls an "applefile."

Note, the term "applefile" is used exclusively by the radmind community, so be aware that non-radmind users wont know what an applefile is.  However, the applefile is really an AppleSingle, which is a format defined by Apple.

If you open an applefile in BBEdit you will see something like this:

    > ^ : %o ,TEXT 2 2
    ??30 2MWBB
    O^^<?xml version="1.0" encoding="UTF-8"?>
    ...

The first part is binary data that is the meta information (it looks weird because the binary data is being show as if it were ascii characters, many of which are unprintable so there are spaces for those spots).  The `"<?xml"` begins the actual file.

If you ever plan on editing files on the radmind server, you do NOT want to edit the file if it is an applefile.  If you really must, you need to remove all applefile data and then change the transcript from "a" to "f".

The applefile manpage
---------------------

Here is the "applefile" manpage (this man page comes with radmind).  Yes, I'm just going to quote the whole thing.  Skip it if you want, but it is kind of required reading.

    To  provide  support for Mac OS X, radmind is aware of the Mac OS meta-
    data used on HFS+-formatted drives. When lcreate uploads a file denoted
    in  the  transcript as an applefile (type 'a'), it encodes the file and
    the file's metadata to the server as an AppleSingle file. The AppleSin-
    gle  file  is an archive containing a file's relevant metadata and data
    in a single file stream. The radmind AppleSingle file has the following
    format:

    1)  The AppleSingle header, consisting of a 4-byte magic number, 4-byte
    version number, 16-byte filler, 2-byte number denoting  the  number  of
    entries in the archive, and 3 header entries, each describing the items
    in the archive and containing a 4-byte entry  id,  4-byte  offset,  and
    4-byte length;

    2)  The  file's  Finder information (32 bytes), which stores the file's
    Type and Creator codes, as well its position in the Finder window;

    3) The file's Resource Fork, which contains things like images, sounds,
    and other data not easily or appropriately stored in the Data Fork;

    4)  The  file's Data Fork, the portion visible from the Finder, and the
    only part which is considered valid by flat file systems.

    The radmind tool lapply similarly decodes the applefile from the server
    and  restores it to the client Mac OS X machine running on an HFS+-for-
    matted drive.

Desirable extended attributes
---------------------

So do you know what extended attributes are needed and which are not needed?  Right now I only know of a few reasons for distributing extended attributes with radmind.

Hidden folders (notice the 1 B?  That tells the Finder the folder is hidden):

    d ./Users/template    0770     502     80   AAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

Icon files for folders (File name is "Icon\r":

    a ./Applications/Microsoft\bOffice\bX/Icon\r    0755   0    0 1003474800   58422 PS1n4dm97H+In25geiIvxuScc04=

Icon files for files.  There is no way to see this within a transcript.  It will just look like any "a" line.

Alias files.  There is no way to see this within a transcript.  It will just look like any "a" line.

File that end with ".webloc" or ".textClipping" files (they are really the same thing, just different extension):

    a ./Users/template/Desktop/Report\ba\bproblem.webloc    0644 606    20 1322003670  271022 jmTWIrG7PDgPnsqck1xXsSPVyUI=

If you are dealing with a file or folder that doesn't have either of those, that means it is probably useless information.  Although it isn't mandatory that you remove it, it makes things cleaner.

As a side note, .DS_Store files also store metadata for folders, and besides icon positions on the Desktop, we haven't found a single reason to distribute a .DS_Store file.

Useless extended attributes
---------------------

What types of extended attributes can you get rid of?  Probably everything except the few mentioned above.  But honestly, you never really know what is required without looking.  But one thing you can do is get rid of the common attributes that you will see when you've installed something for the first time.  Do that with these 2 commands.

    xattr -dr com.apple.FinderInfo /
    xattr -dr com.apple.quarantine /

After you get rid of these attributes, you will want to see if there are any others remaining.  You can do that with this command.

    ls -lR@ | grep "    "

That grep is looking for the tab character (between the quotes).  You can't type that command in the shell because the tab key is used for tab completion.  There is probably a way to do it but I don't know how.  So to run that command, I saved it to a file and ran the file.  I saved it to ~/print_xattrs and I ran it with `sh ~/print_xattrs`.  There is probably a better way to do this, but I don't exactly know what to look for to find it.

What other type of extended attributes are out there?  I scanned my hard drive and this is my list.  I don't really want to figure out how much of this would really be needed.  Most of it is com.apple.FinderInfo and not needed.  Most of this is also created by the OS, not by installers.

    app_description
    AppCrashCount
    AppDuration
    bug_type
    com.apple.AddressBook.ImageTransform.ABClipRect_1
    com.apple.AddressBook.ImageTransform.ABClipRect_1_hash
    com.apple.backup.SnapshotNumber
    com.apple.backup.SnapshotVersion
    com.apple.backupd.BackupMachineAddress
    com.apple.backupd.HostUUID
    com.apple.backupd.ModelID
    com.apple.backupd.SnapshotCompletionDate
    com.apple.backupd.SnapshotContainer
    com.apple.backupd.SnapshotStartDate
    com.apple.backupd.SnapshotState
    com.apple.backupd.SnapshotType
    com.apple.backupd.SnapshotVolumeFSEventStoreUUID
    com.apple.backupd.SnapshotVolumeLastFSEventID
    com.apple.backupd.SnapshotVolumeUUID
    com.apple.backupd.VolumeBytesUsed
    com.apple.backupd.VolumeIsCaseSensitive
    com.apple.diskimages.fsck
    com.apple.diskimages.recentcksum
    com.apple.DTDeviceKit.screenshot.device_id
    com.apple.FinderInfo
    com.apple.metadata:_kTimeMachineNewestSnapshot
    com.apple.metadata:_kTimeMachineOldestSnapshot
    com.apple.metadata:com_apple_backup_excludeItem
    com.apple.metadata:FileSyncAgentExcludeItem
    com.apple.metadata:kMDItemAttributeChangeDate
    com.apple.metadata:kMDItemDownloadedDate
    com.apple.metadata:kMDItemFinderComment
    com.apple.metadata:kMDItemIsScreenCapture
    com.apple.metadata:kMDItemLastUsedDate
    com.apple.metadata:kMDItemScreenCaptureType
    com.apple.metadata:kMDItemSupportFileType
    com.apple.metadata:kMDItemWhereFroms
    com.apple.metadata:kMDLabel_zya2exypzrhulknkk5enqbj33y
    com.apple.Preview.UIstate.v1
    com.apple.quarantine
    com.apple.ResourceFork
    com.apple.TextEncoding
    com.apple.xcode.PlistType
    com.apple.XcodeGenerated
    com.dropbox.attributes
    com.macromates.caret
    com.vmware.backupReenabled
    displayName
    LAST_UPLOADED
    name
    NSImageMetadata
    os_version
    ReopenPath
    SampleWeight
    SubmissionSkipped
    SystemCrashCount
    UserDuration
    UserMissingLibrary
    version

Digging into extended attributes
---------------------

If you want to learn how to figure it out what to keep and what not to, here are a few commands to show you how to identify extended attributes from Terminal.

Whenever you use `ls -l`, it will list an @ when the file has extended attributes.

    ls -al /Users/template/Desktop/
    ...
    -rw-rw-r--@  1 template  staff  134 Nov 22 16:14 Report a problem.webloc

To view the names of the extended attribute, just add "@" (for attribute) to ls.

    ls -al@ /Users/template/Desktop/
    ...
    -rw-rw-r--@  1 template  staff  134 Nov 22 16:14 Report a problem.webloc
        com.apple.FinderInfo     32
        com.apple.ResourceFork    270794

To actually view the extended attribute, use the xattr command with -p (for print).

    xattr -p com.apple.FinderInfo /Users/template/Desktop/Report\ a\ problem.webloc
    00 00 00 00 00 00 00 00 04 50 00 00 00 00 00 00
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

To delete extended attributes, use xattr again with -d (for delete).  If you forget the flags, just type "man xattr".

    xattr -d com.apple.FinderInfo Report\ a\ problem.webloc
    ls -al@ /Users/template/Desktop/
    ...
    -rw-rw-r--@  1 template  staff  134 Nov 22 16:14 Report a problem.webloc
        com.apple.ResourceFork    270794

If you want to see what com.apple.FinderInfo is then use a tool that comes with the developer tools, /Developer/Tools/GetFileInfo. This is for a hidden directory.

    /Developer/Tools/GetFileInfo /Volumes
    directory: "/Volumes"
    attributes: aVbstclinmedz
    created: 02/03/2012 17:32:10
    modified: 03/08/2012 17:36:27

This is for a file.

    /Developer/Tools/GetFileInfo /Users/template/Desktop/Report\ a\ problem.webloc
    file: "/Users/template/Desktop/Report a problem.webloc"
    type: "\0\0\0\0"
    creator: "\0\0\0\0"
    attributes: avbstclinmedz
    created: 11/22/2011 16:14:30
    modified: 11/22/2011 16:14:30

This is the meaning of the letters (this comes from the man page on GetFileInfo).  Lowercase is off, uppercase is on.

    a        Alias file
    b        Has bundle
    c        Custom icon (allowed on folders)
    d        Located on the desktop (allowed on folders)
    e        Extension is hidden (allowed on folders)
    i        Inited - Finder is aware of this file and has given it a location in a window. (allowed on folders)
    l        Locked
    m        Shared (can run multiple times)
    n        File has no INIT resource
    s        System file (name locked)
    t        "Stationery Pad" file
    v        Invisible (allowed on folders)
    z        Busy (allowed on folders)

More info
---------------------

Here are some links to discussions extended attributes.

- [http://en.wikipedia.org/wiki/Resource_fork](http://en.wikipedia.org/wiki/Resource_fork)
- [http://en.wikipedia.org/wiki/Extended_file_attributes](http://en.wikipedia.org/wiki/Extended_file_attributes)
- [http://support.apple.com/kb/TA20578?viewlocale=en_US&locale=en_US](http://support.apple.com/kb/TA20578?viewlocale=en_US&locale=en_US)
