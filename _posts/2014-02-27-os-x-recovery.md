---
layout:     default
title:      "How to recover an OS X computer"
date:       2014-02-27
editdate:   2020-05-11
categories: Mac
disqus_id:  os-x-recovery.html
---

#### How to recover an OS X computer

Because I post Mac OS X administrative stuff and it's entirely possible that someone might kill their computer trying out what I talk about I thought it would be wise that I have a post on how to recover.

I should say that anything you try as a result of reading my blog post is at your own risk and I offer no warranty of any kind.  Do not try these things on a production computer with any type of important data.

Let me explain a little about my environment.  I have 2 iMacs next to me that have absolutely no important data on them at all.  I regularly destroy the file systems on them in the course of my tests, sometimes on purpose, but because of the nature of what I do, sometimes it's on accident.  As you read my posts on OS X administration please remember that this stuff can ruin file systems.

If you don't know how to do things with the command line interface, I recommend you read my terminal post because many of these techniques require command line expertise.  I don't have my terminal post online right now, I'll work on it though.

#### Logging in remotely with SSH

In System Preferences, Sharing pane, there is an option for "Remote Login".  This turns on sshd, which allows you to connect one computer to another computer.  This is by far the easiest way to fix a computer.  Once you turn sshd on the target computer, you need the IP of the target computer and then you open Terminal on the other computer and type `ssh` followed by the IP of the target computer.  Say the target computer IP is 10.0.0.1, you would type `ssh 10.0.0.1`.  If you have a different admin user name on the target computer then you would type `ssh name@10.0.0.1` (replace "name" with the correct short username).

Once you have ssh'ed in, then you are free to fix it from the command line.  I actually spend most of my time ssh'ed into my test boxes.  I use their keyboards infrequently because I'm almost always ssh'ed in to them.

#### Single-User Mode

Sometimes you can boot to single-user mode to fix problems.  When a computer boots, it goes through many stages and once it loads the core OS it is in what is called single-user mode, but by default the computer doesn't stop to let you do anything, it continues to load stuff until the loginwindow shows up.  By booting to single-user mode, you are able to get in and do stuff before anything else happens.  It's pretty easy, just follow these steps.

* Get computer to an off state (shutdown somehow, or hold power button on back).
* Press and hold both the "command" (next to the space bar) key and the "s" key.
* Boot the Mac.
* You will see the Apple logo but no spinning cogwheel.
* When black text shows on the screen you can release the keys.

Sometimes there is trouble.  Here is the most common reason it doesn't work.

* If it goes to the Apple logo and the spinning cogwheel, something went wrong.
* Reboot and hold the option key, if a password field shows up then single-user mode is not an option, you have to find a different method to fix the computer.

If you get in, then continue doing this.

* When you see a prompt, type `fsck -fy`, which will check the hard disk for problems.  Depending on how much data is on the hard drive and how healthy it is, it could take awhile or be very quick.
* When fsck is finished, type `mount -uw /`, which will make your hard disk writable.
* Make changes as needed using the command line interface.

Here is [Apple's knowledge base article discussing single-user mode](http://support.apple.com/kb/HT1492).

Here is [a video showing booting to single-user mode](https://www.youtube.com/watch?v=39dqOmQWjbI) (I don't know the person in the video, it was just a good video).

When you are done with single-user mode, you can type `exit` and it will continue to load stuff, but usually it's just best type `reboot`.

If you want to see the source code that controls single-user mode, it's in [launchctl.c](http://opensource.apple.com/source/launchd/launchd-842.1.4/support/launchctl.c).  Just search for "single" in that file.  This is a really good file to study because everything that used to be in the /etc/rc.* scripts is now in launchctl.c.

#### Booting to the Recovery HD Partition

New Macs come with and the OS X installers add a hidden partition called "Recovery HD".  This started with 10.7, so if you have that OS installed you probably have a one.  If you are unsure, open Terminal and type `diskutil list`.  You will see something like this.

    /dev/disk0
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      GUID_partition_scheme                        *750.2 GB   disk0
       1:                        EFI                         209.7 MB   disk0s1
       2:                  Apple_HFS Macintosh HD            349.3 GB   disk0s2
       3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3

That "Apple_Boot" thing is what makes it hidden.  I have a post discussing the [Apple_Boot partition](http://www.magnusviri.com/apple-boot-partition.html).

Once you are booted to the Recovery HD there are a few things you can do, but honestly, I never use the Recovery HD, in fact, we remove them from our computers.  The partition is discussed elsewhere on the web, and even [Apple has Recover HD documentation](http://support.apple.com/kb/HT4718).

#### Booting to a Different Drive

If you do system administration you should have some sort of bootable drive that isn't the main boot drive.  This can be a USB stick (highly discouraged because it's so slow), an internal partition (even one of your own, and you could even make it Apple_Boot so that it's invisible to the GUI), a netboot volume (requires a netboot server and my experience with them is that it's always a pain unless you control your network--I don't), or an externally mounted hard disk (can be FireWire, USB, or Thunderbolt depending on the model of the computer--and some don't allow anything as far as I know, like the 1st gen MacBook Air).

To boot to an external disk, just follow these easy steps, assuming the computer is off.

* Get computer to an off state (shutdown somehow, or hold power button on back).
* Plug in drive (if it's external).
* Hold the option key.
* Press power button to turn computer on.
* Release keys when you see the boot picker or "Startup Manager".  You should see any extra partitions, external drives or netboot servers in the list.
* Click on the drive you want to boot.
* If you want to make this the startup disk, press and hold the "control" key.
* Press return.

[Apple has Boot picker documentation](http://support.apple.com/kb/HT1310)!  Yay!  It's funny Apple calls it "boot picker" everywhere but this knowledge base article.

Note, if you see a password field, then you have EFI firmware password turned on.  See this archived [Apple kb article on firmware passwords](http://support.apple.com/kb/HT1352).
