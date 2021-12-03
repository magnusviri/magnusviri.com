---
layout:     default
title:      "Apple Boot Partition"
date:       2014-01-17
editdate:   2020-05-11
categories: Mac
disqus_id:  apple-boot-partition.html
---

In Mac OS X 10.7 Apple started creating partitions named "Recover HD" that don't show when you boot the computer unless you hold down the option key while booting it.  This is discussed elsewhere on the web so I'm  not going to discuss it.  Rather, I'm going to talk about what we did with this.

To make it short and sweet, we created a 10 GB partition on all of the computers we manage, changed its type to Apple_Boot, and put a minimal OS that is under 10 GB on it.  The purpose of this blog is to document the command that turns a partition to Apple_Boot (because I can never remember it and _it isn't documented on the asr man page_), assuming the partition that you want to convert is disk0s3.

    diskutil unmount disk0s3
    asr adjust -target /dev/disk0s3 -settype Apple_Boot

The main purpose of our admin partition is to upgrade the OS on the main partition.  We struggled every time we had to do a major OS upgrade since 10.2.  Back then we upgrade the OS while booted to it and the upgrade would either stall, leaving half of the disk the old OS and half the new OS, which usually resulted in a non-bootable disk, or if the upgrade would finish, it never restarted and we'd have to go around and manually restart every machine, which isn't that big of a deal but upgrading the OS is full of so much work that eliminating even a small step saved us a ton of time.

We also had to spend development time with every major OS upgrade testing or redoing the upgrade process.  I remember the year that we tried to implement a chrooted OS.  I also remember downloading the new OS and swapping it out after it was all downloaded.  We tried many tricks but nothing seemed reliable.

Using an admin partition is so much more stable then anything we've tried in the past.  And best of all, we no longer have to wonder if the method we used with the last major OS upgrade will work on the next one.

The secondary purpose of the admin partition is to have a bootable partition that we can use to save computers that no longer boot.  We would also like to use it for other maintenance like running DiskWarrior but we haven't gotten around to that yet.  It sure beats walking around with Firewire drives.

## Tools and Changes

Switching to the admin partition wasn't simple.  We had to build a set of tools and make other changes.

The first tool we wrote created the admin partition using diskutil to create the 10 GB partition and then use the asr command to switch it to Apple_Boot.

Next we had to create a tool that automatically generated a minimal OS by duplicating our radmind transcript for the OS baseload and edit out what we didn't think was needed.  It used a symlink for the files so that we didn't have duplicated files on the radmind server.

We had to rewrite our radmind script so that it worked relatively.  We had already started to use our old script relative more and more but it was written to log to the root disk, and it also used the certs and client files of the root disk.  We started writing our original radmind script back in 2002, based on a script written by UMich's RSUG group.  Our original radmind script was how I learned Perl.  It was also used by other groups including Disney and on some government research lab's grid computer (not because it was so good, but because it was one of the first public script that did the job).  It was ugly.  Anyway, I rewrote it in python for 2 reasons: Python could up it's own max open file limit (we were way past the default 256 limit), and it could run a shell command (like ktcheck, fsdiff and lapply) and allow us to grab stdout and stderr and do whatever we wanted with them, print them to stdout, save them to a log file, parse them, whatever.  I do believe it is slower, but I don't know if I care.  The new script is called xradmind.py.

Part of our xradmind.py rewrite was to give it robust cert handling, that is, to allow us to use any cert path.  But we also had to have the cert tools working.  I've blogged about this with the articles titled [radmind tls part 1](http://www.magnusviri.com/radmind-tls-part-1.html) and [radmind tls part 2](http://www.magnusviri.com/radmind-tls-part-2.html).  Our cert setup is to use certs on all computers, but only a few care about which cert they use, mainly our firewire drives and this admin partition.  Every other computer has a cert that allows it to connect but their IP is used to select the command file.  This is all determined by what is listed first in the radmind config file on the server.  If the cert is listed first, then the cert specifies the command file.  If the IP is listed first, the IP is used.

The final tool and change we had to make is to make sure that the admin partition always had the correct network prefs.  The way we accomplished this was to create a startup script that checked to see if network prefs exist at startup, which means it had to run before they were auto created and we did that by running the script by executing it with /etc/rc.server, a script that runs before any launchd jobs run (the old /etc/rc scripts were moved into launchd and is easily visible in the launchd source code except for /etc/rc.server).  If the network prefs don't exist, the script creates a trigger file and a later script modifies the network prefs with the correct IP.  The "correct IP" is whatever is set in an NVRAM variable.  We set the NVRAM variable when we run radmind on a box, because presumably the IP when it runs radmind, no matter when it runs, is the "correct IP" since we use mostly use IP to determine the whole computer configuration.  I mentioned earlier we don't use certs to identify what command file a machine should use, we use IP, so that's what I mean by it being the "correct IP."
