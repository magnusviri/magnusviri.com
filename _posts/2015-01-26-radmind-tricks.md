---
layout:     default
title:      "Radmind Tricks"
date:       2015-01-26
editdate:   2020-05-11
categories: Graveyard
disqus_id:  radmind-tricks.html
render_with_liquid: false
---

The following radmind tricks are things I've learned over the years.  I assume you know how to use radmind, so if you don't know how to use it, I don't know that this document make much sense to you.

I assume that you're managing Mac OS X clients.  A lot of these tricks apply to Linux clients as well, but this document is full of Mac OS X references.

There are tricks to run on the server and tricks to run on the client.  I've also noticed that I tend to have 3 different categories of tricks:

* Avoiding errors
* Speeding up overload creation
* Improving discover (answering questions like, "how is the machine configured", "what version is installed", or even "what the heck is on the computers?")

I will be updating this document as I add more tricks.

If you see something that could be added or you know a better way to do something, please leave a comment.

---

### Test computer(s)

First of all, you need test computers, even if it's just one, even if it happens to be one "production" computer that you can easily access and run your tests on.  For example, if you have a classroom with 20 computers, set aside one of them as the "test" computer.

Ideally you'll have at least one or two test computers in your office or cubicle that you can access easily.  I've heard of people having as many as 8, but two is my sweet spot.

### Partitions on your test computers

Second, you need to have at least 2 partitions on your test computers with 2 bootable operating systems on each.  They can both be managed by radmind or not.  Either way, if you get into radmind too much, you're bound to accidentally make one of those partitions upbootable at least once if not more.  Having the 2nd bootable partition makes fixing it so much easier and faster.

### Learn how to recover computers quickly

I have written a whole blog post to [recovering a computer](http://www.magnusviri.com/os-x-recovery.html) and you should know all of these methods.  The braver you get with radmind, the more likely you'll kill a computer.  I've killed so many computers using radmind it's not even funny.  It's forced me to learn how to fix them quickly (well, the worst case is me walking around with a firewire drive to each computer).  But the benefit of being able to fix the computers quickly is that it made me quite brave (wreckless?) and so I can push out changes with radmind very quickly.

### Use afp/smb to connect to your radmind server

I'm assuming everyone uses afp/smb to connect to their radmind server to change the command files.  It's possible to use ssh to do the same thing, and I could, but I use afp/smb for a few reasons.

First, I can copy files back and forth using the Finder.  By extension, I make it as easy as possible to move files between my clients and the server as well, often using Apple Remote Desktop to copy the files to my main workstation and then copying them to the server, or somethings I'll mount the server on the client.

Second, I can edit the files on the server with my favorite text editor (TextWrangler).

Third, I can compare directories on the server easily with TextWrangler.

To use afp to connect to your radmind server you need to turn on file sharing and the best thing to do is to make /var/radmind a mountpoint.

### Use ssh to connect to your radmind server

A lot of the tricks I talk about in this document will require using the command line.  If you don't already have some experience with the command line, you should spend some time learning.  I've written a document that discusses [using Terminal instead of the Finder](http://www.magnusviri.com/os-x-terminal.html) and I think it starts pretty basic.  And there are countless other documents helping people learning the command line as well.

There are two ways to use the command line on the radmind server.  You can ssh into the radmind server, or you can mount the radmind volume using afp/smb and then use the Terminal on your local box and change directory to the mounted volume.  The advantage of ssh'ing into the server is everything is faster.  The advantage of using the mounted volume is that you can drag files from the Finder to the Terminal to get their paths.

I always ssh into my server.  The only time I use the mounted volume is when I'm working in the Finder heavily and I don't want to have to think about file paths so I just open a new Terminal window and drag the files in the Finder to the Terminal.  That isn't very common but it does happen.  Everything command line related in the rest of this document implies you're ssh'ed into the server.

### Use sub directories in /var/radmind/command and /var/radmind/transcript.

Move all of your command files and transcripts into sub folders.  In my transcript directory I have a several folders named after function like "os", "software", "config", etc.,.  I'll explain that more later.

In my command folder I have all of my machine command files (any command file that is listed in /var/radmind/config) in a folder named /var/radmind/command/machine.  If I have a kink (k-in-k or commandfile in a commandfile) then I put it in a different folder named after function like "os", "software", "config", etc.,.

The worst thing is to have a command file like /var/radmind/command/imac.T because it makes branching hard, which is discussed next.

### Command branching

Once you have a test computer, you want to put it on a different but parallel branch.  Do this by duplicating your production command file and either rename it or put it in a different folder.  Then change the config file so that your test computer points to this command file.

So say I had this command file:

    /var/radmind/command/machines/8_students/sb_150.K

I duplicate it and move it so that I now have this:

    /var/radmind/command/machines/7_dev/sb_150.K
    /var/radmind/command/machines/8_students/sb_150.K

Then I change my config file from this:

    10.0.1.<1-20>    machines/8_students/sb_150.K

To this:

    10.0.1.<1-19>    machines/8_students/sb_150.K
    10.0.1.<20>      machines/7_dev/sb_150.K

I now have 2 branches that are exactly the same right now, but it allows me to go in and change machines/7_dev/sb_150.K without affecting 10.0.1.1-19.  If I screw it up, I only screw up 10.0.1.20.

The reason why I use different folders for my branches instead of just renaming the file and leaving it in the same folder is because I can then use BBEdit (or the free TextWrangler) to compare the 2 folders.  Because the 2 file names are exactly the same, BBEdit will show me the differences between them.  I could just open both files and compare them, but if I have 10 command files, I can compare them all by comparing their parent directories.

Two branches should be good enough unless you embark on some serious long term changes.  In that case, you want 3 branches, one for stable, and one for short term testing, and one for long term testing.  If you don't always have a branch for short term testing, you'll find that you need to make changes but all you've got is long term testing and you aren't ready to push those changes out.  You can simply duplicate the stable environment for the short term testing.

I have no idea if you can use git or some other version control to create this kind of branching.  It would require far more git knowledge and skill than I've got to do it.  And this is such a non-standard why of using git that I don't think anyone ever really discusses it.  I once asked a coworker who understood git pretty well to set it up and he couldn't simply because this is such a crazy setup from the perspective of git.  This is basically why I don't use git or any other version control with my radmind setup except (cringe) Time Machine.

### Transcript branching

The next step to avoid errors is to have transcript branching as well.  There are 2 ways to do it depending on what you are doing.  For most updates, just put the date and version in the filename.  For example, I name my overloads something like "textwrangler_4.5.9_2014.07.01_jer.T".  When I make a new overload I rename it something like "textwrangler_4.5.12_2015.01.22_jer.T".

Put the new overload in the dev command file and run radmind on the test computer.  When you know there are no problems with the transcript update the stable branch with the new command file.  This is how you avoid most errors.

If you are making major changes to all of the overloads, then yes, duplicate everything in /var/radmind/transcript _and_ /var/radmind/file.  I realize this will take forever and will take a lot of hard disk space.  However, if you are changing all of the overloads, and you want to avoid errors, you pretty much have to do this.  I've tried so many tricks to avoid duplicating the whole thing and I _always_ screw it up, every single time.

### Use grep on the server to figure out what's going on

You can use twhich to find out what file is being installed on a particular machine, but often you want to find out all of the overloads that have a file.  You can quickly and easily find out what files are part of overloads by ssh'ing in to your server and using grep.  Here are some guidelines for using grep on the server.

If you use sub directories on your radmind server for both command and transcript then you don't always have to search through everything (speeds up searches).  For example, if I'm looking for all of the transcripts that specify /etc/authorization that are OS overloads, then I can run this next command.

    grep -r /etc/authorization /var/radmind/transcript/os

If you have to search for paths with spaces, you have to use quotes and triple escape them.  Don't ask me why triple escapes work, it just does.  The perfect example is "Application Support"

    grep -r "Application\\\bSupport" *

Usually I just grep for the partial path like this.

    grep -r bSupport/Apple/Remote *

### Use relative paths in your transcripts

When you run fsdiff on a client, always use ".", not "/".

Don't do this:

    fsdiff -Ic sha1 -C -o /var/radmind/client/new_transcript.T /

Do this:

    cd /
    fsdiff -Ic sha1 -C -o /var/radmind/client/new_transcript.T .

You can't mix transcripts created with "." with ones created with "/", you will get errors if you try.  You can add a "." to the beginning of all the transcript paths once they are on the server.  It doesn't really change the overload files or anything.  But be sure to change your radmind script on your clients to use "." as well.

If you ever use twhich, remember the paths have to be exact, so they have to start with "." for twhich to work.

### Use case insensitivity in your transcripts

When you run fsdiff on a client, always use "I".

    cd /
    fsdiff -Ic sha1 -C -o /var/radmind/client/new_transcript.T .

If you have a bunch of case sensitive transcripts already, use lsort to fix them because you can't mix them.  You'll need to do it all at once.  It's worth the effort.

The biggest problem with resorting files is that hard links may be placed before the actual files are created, and that will create an error.  [Greg Neagle discusses this and wrote a script that will fix it](https://managingosx.wordpress.com/2008/06/24/radmind-converting-to-case-insensitive-transcripts/).  The [script can be found here](http://homepage.mac.com/gregneagle/files/converttocaseinsensitive.pl).

### Beware of /private

/etc, /tmp, and /var are symlinks to /private/etc, /private/tmp, /private/var.  If you have a transcript with a path to /etc, /tmp, or /var, you wont see an error.  But it will mess things up.  Here's why.

Imagine a command file that contains 2 transcripts.  One transcript has /etc/sshd_config and the other has /private/etc/sshd_config.  It doesn't matter which transcript appears first in the command file because the output of fsdiff will see both files as different files and will list them like this:

    /etc/sshd_config
    /private/etc/sshd_config

So even if the transcript that specifies /etc/sshd_config comes last and should override /private/etc/sshd_config, it wont because both files will be listed and /private/etc/sshd_config will always come after /etc/sshd_config (p comes after e).

### Find the differences between two machine command files by running fsdiff -A on an empty folder

Once you have two branches, you can use this trick to see exactly what is different beween the two of them.

On a client, run these commands (the "I" assumes case insensitivity):

    ktcheck -c sha1 -h radmind.example.com
    cd /var/empty
    fsdiff -IAc sha1 ./ -o /tmp/1

On the server, change the config file from the dev branch to the stable branch (or vise versa) and then run this.

    ktcheck -c sha1 -h radmind.example.com
    fsdiff -IAc sha1 ./ -o /tmp/2
    diff /tmp/1 /tmp/2

You now are looking at the exact differences.

### Linking the transcripts and the command file dirs together

This is actually how I name the folders in my transcript and command directory.

I create a folder in /var/radmind/transcript and make a sym link in /var/radmind/command that points to it.  Like the following.

    mkdir /var/radmind/transcript/shared
    cd /var/radmind/command
    ln -s ../transcript/shared

The reason I link command to transcript (instead of the other way) is because it makes more sense to have the folder in transcript because it will have a twin folder in /var/radmind/file.

This is my current folder structure:

    /var/radmind/transcript/1_os
    /var/radmind/transcript/2_software
    /var/radmind/transcript/3_radmind
    /var/radmind/transcript/4_xhooks
    /var/radmind/transcript/5_cust
    /var/radmind/transcript/6_servers
    /var/radmind/transcript/7_dev

    /var/radmind/command/1_os -> ../transcript/1_os
    /var/radmind/command/2_software -> ../transcript/2_software
    /var/radmind/command/3_radmind -> ../transcript/3_radmind
    /var/radmind/command/4_xhooks -> ../transcript/4_xhooks
    /var/radmind/command/5_cust -> ../transcript/5_cust
    /var/radmind/command/6_servers -> ../transcript/6_servers
    /var/radmind/command/7_dev -> ../transcript/7_dev
    /var/radmind/command/machines

Here are 2 lines from a "machine" command file that shows a perfect example of why I do this.

    n 1_os/2_10.9_neg.T
    k 1_os/3_10.9_exclude.K

Notice one is a negative transcript (starts with "n") and the other is a command file (starts with "k").  They happen to be side by side in the same folder so it is easier for me to go back and forth between the two.

These are the commands I run to make my symlinks.

    cd /var/radmind/command
    find ../transcript -depth 1 -type d -print -exec ln -s \{\} \;

### Be flexible and quick

The danger of using command file and transcript branches is that it will become a huge inflexible beast that forces you to do things harder then it should be.  One of the biggest things I've learned is that there is no one solution.  There is no one best way to name your files and folders simply because I keep changing my own over and over and over.  So the goal isn't to find the best solution, it's to be as flexible as possible so that you can change your entire naming or organization structure to meet the needs you have at the moment.

This is such a huge topic and I'm not really prepared to discuss it yet.

### Use BBEdit/TextWrangler's "Compare Folders"

The whole purpose of the command file branching is to allow you to compare command files using BBEdit or TextWrangler.  I would be so much less productive without this feature.  There are some other apps (including the command diff) but none of them are as useful as BareBone's BBEdit/TextWranger compare.

### Edit transcripts on the server

So probably the biggest hurdle of beginners is learning to make changes on the server.  It's easy to scan something on a client with fsdiff, upload it with lapply, but once it's on the server don't be afraid to make changes to the uploaded transcript located in /var/radmind/tmp/transcript (or /var/radmind/transcript).

Some changes that you might make include:

* Adding commented notes
* Commenting out or deleting lines
* Changing owner/group permissions
* Changing absolute paths to relative

Here is an example of a commented out note.

    ## james password
    f ./private/var/db/shadow/hash/0F530701-5F2B-47B3-A01C-EB6F6F2376D0    0600     0     0 1414517391    1240 KZBwudO7gyZhgZcwvxd95vXoRuQ=

And here is an example of files you would typically want to comment out or delete.  In fact, there are probably better ways to deal with all of these files but I haven't gotten there yet.

    f ./Library/Application\bSupport/App\bStore/adoption.plist    0644     0    80 1404239200     798 dYLg/sI0DtlMH6V0cANkhHv4nnI=
    f ./Library/Preferences/com.apple.MCX.plist    0644     0     0 1404245914      86 7/CchUsiJ0uqT5wTB7Moe40YDd8=
    f ./Library/Preferences/SystemConfiguration/com.apple.wifi.message-tracer.plist    0644     0     0 1404241000    4728 NNgZUzUsgDTtfCR90UjnJy+vMq0=
    f ./Library/Printers/InstalledPrinters.plist    0644     0     0 1404244803     432 NXFsDk1mibRjoX/sPCBRz0mK3Fg=
    d ./Library/Updates/031-1878               0755     0     0
    f ./Library/Updates/031-1878/031-1878.English.dist    0644     0     0 1404244811    4210 F+OZYPqP+5HMAyk02PclvNQ3s64=

To change an absolute path to a relative is easy.

Absolute:

    f /Library/Updates/031-1878/031-1878.English.dist    0644     0     0 1404244811    4210 F+OZYPqP+5HMAyk02PclvNQ3s64=

Relative:

    f ./Library/Updates/031-1878/031-1878.English.dist    0644     0     0 1404244811    4210 F+OZYPqP+5HMAyk02PclvNQ3s64=

### Edit overloads on the server

Once you're comfortable making changes to transcripts, the next thing is to make changes to the files in overloads.  I usually do this with plist or unix config files.

For example, say I wanted to change the Firefox prefs so that it doesn't show the annoying "Welcome" webpage when it is opened.  I could open the prefs file at

/var/radmind/file/path_to_firefox.T/Users/your_template/Library/Application Support/Firefox/Profiles/random text.default/prefs.js

Then I'd search for these 2 lines:

    user_pref("extensions.lastAppVersion", "34.0.5");
    user_pref("extensions.lastPlatformVersion", "34.0.5");

And I'd change them to whatever version was the latest.  More likely I'd just rename the prefs.js file and copy the file from my client directly into the folder.

Whenever you make changes you want to run lcksum to make sure it checks out.

    lcksum -Icsha1 path_to_firefox.T

If you made changes it should say that it updated what you changed (checksum or file size).

### Make overloads on the server

Once you are comfortable changing overloads, heck, just make your overloads on the server.  Using the Finder, connect to your server and make a folder for the overload in the file directory.  If I wanted to make autologin prefs, I could do this on my very own workstation by just opening System Preferences and set autologin, then copy these files to the server.

These are the files on the client (my computer).

    /private/etc/kcpassword
    /Library/Preferences/com.apple.loginwindow.plist

On the server run these commands:

    mkdir -p /var/radmind/file/auto_login.T/private/etc/
    mkdir -p /var/radmind/file/auto_login.T/Library/Preferences/

Using the Finder copy them to the server.

    /var/radmind/file/auto_login.T/private/etc/kcpassword
    /var/radmind/file/auto_login.T/Library/Preferences/com.apple.loginwindow.plist

Or you could mount the radmind server on the client and run these Terminal commands.

    cp /private/etc/kcpassword /Volumes/radmind_server/var/radmind/file/auto_login.T/private/etc/kcpassword
    cp /Library/Preferences/com.apple.loginwindow.plist /Volumes/radmind_server/var/radmind/file/auto_login.T/Library/Preferences/com.apple.loginwindow.plist

Next, on the server run these commands.

    cd /var/radmind/file/auto_login.T
    fsdiff -c sha1 -K/dev/null . > ../../transcript/auto_login.T

You just created a whole overload on the server.  Piece of cake.

### Quickly create an overload from a package

I say "quickly" because this is something of a hack.  First, install the package.  Then run this script pointing to the package bom file.  The script reads each line in the bom and sends it to fsdiff.  You may need to massage the transcript a little before it will upload (sorting could be wrong).

    #!/bin/sh

    if [ "$1" = "" -o ! -e "$1" ]; then
       echo Please specify a valid bom file.
       exit
    fi

    lsbom -pf "$1" | xargs -I {} -L1 fsdiff -c sha1 -1 "{}"

Also, Apple has started using unified packages and I'm not sure how to use this with those packages.  And don't ask me about meta-packages.

### Update a transcript on the client.

If you make changes on the client and want to update the files in a pre-existing transcript you can run this script.

    #!/bin/sh

    if [ "$1" = "" -o ! -e "$1" ]; then
      echo Please specify a valid transcript file.
      exit
    fi

    if [ "$2" = "" ]; then
      echo Please specify a transcript to save the new results.
      exit
    fi

    if [ "$2" = "$1" ]; then
      echo Please don\'t use the same transcript name, it wont work.
      exit
    fi

    if [ -e $2 ]; then
      rm $2
    fi

    cat $1 | awk '{ print $2 }' | sed -e 's/\\b/\\ /g' | xargs -n1 fsdiff -c sha1 -1 >> $2

I used to use this script to update the radmind tools themselves, since there were rarely new files.  I'd run the installer, then run this script, then upload it.

### Get notified when a command finishes

Sometimes when your run commands on the radmind server it takes forever.  You can cause Terminal to beep even if you are ssh'ed into it with this command.

    tput bel

If you are running the commands on the local machine you can use the say command.

    say hey you I am done

You can even text your phone if you run a command on a client and have to walk away.

    curl http://textbelt.com/text -d number=8005551234 -d message="done"

### Fixing lmerge's hard links

The lmerge command combines overloads and it uses hard links for the files.  This is good if you want to save filespace, but bad if you want to modify either of the merged overload but not affect un-merged overloads (or vise versa).  To get rid of the hard links, I run lmerge like this:

    /usr/local/bin/lmerge your_overloads.T merged_transcript.T

Then I run this script using "merged_transcript.T" as the argument (or whatever is correct).

    #!/bin/sh

    cd /var/radmind/file
    merged_overload="$1"
    ditto ${merged_overload} ${merged_overload}2
    mv ${merged_overload} ${merged_overload}3
    mv ${merged_overload}2 ${merged_overload}
    rm -r ${merged_overload}3
    tput bel

### Verify all transcripts on server

    cd /var/radmind/transcript
    find . -name "*.T" -print -exec /usr/local/bin/lcksum -Incsha1 \{\} \;

This command takes a long time.

### Download a single file on the client

    twhich /path/to/file | lapply -h radmind.example.com

### Download a single overload

You can easily download a single overload by using this one liner.

     perl -e 'print "overload.T:\n";' -pe 's/^([fa])/+ $1/' \
     /var/radmind/client/overload.T  | lapply -CFh radmind.example.com

Note, this will download the files regardless if the file exists and regardless of if the file is the same or not.  It just plain downloads everything.

### Download multiple overloads

I have a much more complex downloader.  It works by creating a custom command file with only the transcripts listed.  After scanning the script removes all lines that deletes files.  I'm in the process of rethinking this whole script, but until I'm happy with it, here is my [old download_overload.pl script](../blog/954_radmind_trick_staging/download_overload.pl).
