---
layout:     default
title:      Mounting VirtualBox HFS+ VDI files on OS X
date:       2015-09-08
editdate:   2020-05-11
categories: MacAdmin
disqus_id:  virtualbox-vdi-mount.html
---

Originally this post was much shorter.  I added more than 3 times the information and added a whole new page discussing the UEFI interactive shell.  I wrote this back in Sept 2015 but am just posting it in Apr 2016.  I never posted this because after using VM's I created this way for a few days they quit booting.  So, THIS DIDN'T WORK FOR ME.  DO NOT DO THIS.  IT DOESN'T WORK.

The reason I am posting it is because it's a lot of interesting info.  Maybe someone else will figure out how to do this.  Here's the post.

---

My motivation
---------

I wanted to be able to create OS X VirtualBox images quickly and easily without having to run an OS X installer every time.  I tried cloning existing images and resizing them but when I booted the enlarged images Disk Utility would never let me expand the size of the volume.

I also wanted to be able to mount the guest filesystem on the host.

Read on if you want to know how to mount the filesystem and how to make that filesystem bootable.

I tested this all running VirtualBox 5.0.2, Mac OS X 10.9 as the host, and Mac OS X 10.6 as the guest.  I'll try to update this if I find new information as I use this.  All of these things are done on the host unless otherwise stated.

Mounting fixed size disks only (no Dynamic disks)
---------

You cannot mount dynamic disks, they must be fixed.  Use this command to convert a dynamic file into a new fixed file.

    VBoxManage clonemedium disk old.vdi new.vdi --variant Fixed

When you've created a new fixed format disk image you need to go into the settings for each VM that uses the dynamic disk and replace it with the newly created fixed disk.

Unformatted disks can not be mounted
---------

If you create a new disk be aware it is unformatted and cannot be mounted.  You need to boot a VM and format the new disk within a guest.  I don't know of any way to format the disk from the host.

Note, when you format a drive I believe it is missing some HFS volume header information that makes it bootable.  The OS X Installer "DVD" (the thing you create to install OS'es) fixes this and makes a disk bootable.  But the `bless` command or Startup Disk in System Preferences does not make a disk bootable.

I've also found that if you use Carbon Copy Cloner to block copy a bootable disk to a newly formatted disk that the newly formatted disk will be bootable, even if the source disk, which was once bootable, has had all the files deleted.  I'll describe this later on.

There are probably other ways to make a newly formatted disk bootable, such as using Disk Utility and ASR.

Mounting the main partition
---------

You mount disks with the `hdid` command and must use the section flag.  The `hdid` command will not mount files ending with ".vdi".  The easiest workaround is to use a symlink that ends with ".img".

    cd /path/to/folder/containing/vdi
    ln -s disk.vdi disk.img

Use section 0x1000 to mount all HFS disks (I found this by trying 1-2000).

    hdid -section 0x1000 disk.img

This disk will have permissions disabled.  You want to enable permissions using the Finder.

You can unmount the disk using the Finder or one of these commands.

    diskutil unmount /Volumes/EFI

or

    umount /Volumes/<Name-of-disk>

Mounting the EFI and Recovery partitions
---------

OS X creates more than one partition when you format it.  Your disk will have an EFI partition and it might have a Recovery partition.  You can mount those on the host as well.

First, run `hdid -section 0x1000 disk.img` if you haven't already.

Then find out what disk it is by typing `diskutil list` in Terminal.

    > diskutil list
    ...
    /dev/disk8
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      GUID_partition_scheme                        *33.0 GB    disk8
       1:                        EFI EFI                     209.7 MB   disk8s1
       2:                  Apple_HFS 10.11                   32.1 GB    disk8s2
       3:                 Apple_Boot Recovery HD             650.0 MB   disk8s3

Use `diskutil` to mount them.  The disks will have permissions disabled.

    diskutil mount /dev/disk8s1
    diskutil mount /dev/disk8s3

Or you can use the `mount` command.  If you use `mount` the disks will have permissions enabled.

    mkdir /Volumes/EFI
    mount_msdos /dev/disk8s1 /Volumes/efi

    mkdir /Volumes/EFI
    mount_hfs /dev/disk8s1 /Volumes/efi

If you want to forbid writing, you can modify the `diskutil` or `mount` commands like this.

    diskutil mount readOnly /dev/disk8s1

or

    mkdir /Volumes/EFI
    mount_msdos -o ro /dev/disk8s1 /Volumes/efi

You can use the Finder or one of these commands to unmount.

    diskutil unmount /Volumes/EFI

or

    umount /Volumes/EFI

If you want to play around with Disk Utility to see the hidden partitions you can use this command to show the Debug menu.

    defaults write com.apple.DiskUtility DUDebugMenuEnabled 1

Then you can select "Debug" -> "Show every partition".

I didn't try formatting these disks with Disk Utility from the host.  Who knows what will happen.

Empty EFI system partition (ESP).
---------

The EFI partition is also know as the [EFI system partition](https://en.wikipedia.org/wiki/EFI_System_partition) (ESP).  Apple plainly says that they do ["not currently use it for anything" and that they create in case they "ever need to use ESP-based drivers."](https://developer.apple.com/library/mac/technotes/tn2166/_index.html#//apple_ref/doc/uid/DTS10003927-CH1-SUBSECTION6)

Apple does use it [to perform firmware updates](https://en.wikipedia.org/wiki/EFI_System_partition#Usage).  In my ESP I have these files.  I don't remember running a firmware update but I probably have.

d /Volumes/EFI/EFI
d /Volumes/EFI/EFI/APPLE
d /Volumes/EFI/EFI/APPLE/EXTENSIONS
f /Volumes/EFI/EFI/APPLE/EXTENSIONS/Firmware.scap

The UEFI Interactive Shell
---------

Earlier I mentioned that newly formatted disks are not bootable.  What that really means is if you try to boot a disk that hasn't been made bootable some way, it will display the UEFI Interactive Shell instead of the normal boot.  I am guessing this is VirtualBox's Interactive Shell since OS X doesn't include one.

Another problem I had is that the VM wouldn't let go of the mouse or keyboard.  I got around it by pressing command-option-esc.  It would open the Force Quit window and then I could use my mouse.

I was so intrigued by this that I had to create another page discussing [UEFI's Interactive Shell](/virtualbox-uefi.html).

I think the reason it went to the shell was because the ["OS loader is usually located through a file ID pointer in the HFS+ volume header."](http://wiki.osx86project.org/wiki/index.php/Apple's_EFI_implementation)  If that's right, the volume header was missing some info that can't be copied by copying the files, it has to be some sort of block copy.  Another comment seems to indicate that updating the volume header from userspace ["is impractical since the kernel will write back the original values on unmount"](http://www.gossamer-threads.com/lists/linux/kernel/1486617?page=last).  I have no idea if that is what is happening here but it could be.

Running the OS installer over my installed image fixed it (which defeated the whole goal).

But I also figured out that Carbon Copy Cloner fixed it too.  I'm guessing that Disk Image and perhaps ASR might also fix this, but I haven't tried it yet.

The Carbon Copy Cloner solution
---------

To solve this with Carbon Copy Cloner you have to start with a bootable image that was created by the OS X installer "DVD".  I cloned one that I had and then I deleted all the files on it.  Yup, all of them.

Attach that disk to a bootable VM that also has the newly formatted disk (so it will have 3 disks).  Then boot that VM and run CCC from within the guest and clone the previously bootable disk to the newly formatted disk.  Make sure you erase the destination.  It only took a few seconds because the source disk was empty.

I was able to copy an OS onto this volume and it booted fine.

Conclusion
---------

It's 7 months since I wrote this.  I didn't publish all of this when I wrote it because I kept having errors on the disks I created this way and they quit booting.  I tried to fix them but nothing worked.  I eventually decided not to do this anymore.  YOU HAVE BEEN WARNED.
