---
layout:     default
title:      OS X Server - Basics
date:       2014-07-16
editdate:   2020-05-11
categories: MacOSXServer
disqus_id:  os-x-server-basics.html
render_with_liquid: false
---

[Update 2019-04-13: I no longer run a Mac OS X Server and [Mac OS X Server is dead](https://support.apple.com/en-us/HT208312).]

Here are my notes for debugging and maintaining an OS X Server (3.1.2) on Mavericks 10.9.4.  This is mostly command line stuff, very little GUI stuff.

Note, this post is part of a series.  Here are the other posts.

* OS X Server - Basics (this page)
* OS X Server - [Managing user accounts](http://www.magnusviri.com/os-x-server-managing-user-accounts.html)
* OS X Server - [Postfix](http://www.magnusviri.com/os-x-server-postfix.html)
* OS X Server - [Dovecot](http://www.magnusviri.com/os-x-server-dovecot.html)
* OS X Server - [Sieve](http://www.magnusviri.com/os-x-server-sieve.html)
* OS X Server - [Postfix Queues](http://www.magnusviri.com/os-x-server-postfix-queues.html)

About OS X Server
-----

OS X Server is a product that reached it's peak around 2009-2011 with Mac OS X Server 10.6.  Back then it was a complete OS install and was different from Mac OS X client.  Since then Apple has scaled the product back, made it very inexpensive ($20), released very little documentation compared to 10.5 and 10.6, and made the server an app download from the Mac App Store that is installed on the client OS (rather then being a OS unto itself).

The OS X Server (3.1 on OS X 10.9) installs and pre-configures some of the best open source server products such as apache, php, postfix, dovecot, and openldap.  I am unsure if the bugs I've seen are in the Server.app, modifications Apple has made to the open source products, or in how Apple has configured all of these 3rd party server products to work with each other.

Working with OS X Server
-----

#### Make sure everything is ok

    sudo changeip -checkhostname

#### To change the IP

Do not change the IP of the server if you are using Open Directory.  Changing the IP destroys the LDAP and Kerberos databases.  If you are not using Open Directory, this is how you change the IP.

    sudo changeip <old-ip> <new-ip> <old-hostname> <new-hostname>

Then go to System Preferences.app and change the IP there.  Then reboot the server.

If you are using Open Directory, all hope is not lost.  Assuming you don't have replicas and you don't need to retain the passwords then run **something like** these commands (I did something like this, but I didn't save my history, so I don't remember exactly what I did):

Backup data

    sudo slapconfig -backupdb /full/path/to/archive

Export data

    dsexport -e dsAttrTypeStandard:AuthenticationAuthority -e dsAttrTypeStandard:AltSecurityIdentities \
      users.txt /LDAPv3/127.0.0.1 dsRecTypeStandard:Users
    dsexport groups.txt /Local/Default dsRecTypeStandard:Groups

Destroy database

    sudo serveradmin stop dirserv
    sudo slapconfig -destroyldapserver

Start over

    sudo slapconfig -createldapmasterandadmin

Reimport

    dsimport users.txt /LDAPv3/127.0.0.1 M --username <diradmin>
    dsimport groups.txt /Local/Default M --username <diradmin> <dirpassword>

If you need to keep passwords probably the easiest solution is to replicate your Open Directory database to a different server, promote the replica to a master, bind the first server to the new master, change the IP of the first server, then replicate the Open Directory database back.  But I don't know how to do any of this.  Years ago I seem to remember being told this is how it's done, but I don't remember too well because I didn't manage OS X Server's back then.

It should also be possible to export the Kerberos database but `kadmin -l dump` says "kadmin: hdb_foreach: iteration over database only supported for DSLocal".

Modifications to the system.
-----

<a name="periodic"></a>

#### Have the output from the periodic scripts emailed to you.

/etc/periodic.conf

    daily_output="you@example.com"
    weekly_output="you@example.com"
    monthly_output="you@example.com"

Backups
-----

The common wisdom is that you never know if your backup solution actually works unless you use it.  I'd like to add that you'll never know how your backup solution works unless you use it.  I've had to restore my system twice before it was even in production yet.

I'm just going to say this, you must know your backup software inside and out.  And if you're using TimeMachine as your backup, don't be deceived by the silly TimeMachine System Preferences pane.  *Read the [tmutil](https://developer.apple.com/library/mac/documentation/Darwin/Reference/Manpages/man8/tmutil.8.html) man page!*

Firewall
-----

Hey, OS X Server opens _a lot_ of ports.  I haven't fully tested this yet, but I don't want all of these ports open, so I'm going to shut them off and see if the server still works.  So remember, these are my notes, and as of the moment I'm writing this, I haven't actually tested them yet, so don't take this as truth yet.

This is all of the open ports on a server with Open Directory, Mail, ssh, and vnc turned on.

    22             ssh
    25             smtp
    80             http
    88             kerberos
    106            3com-tsmux
    110            pop3
    143            imap
    389            ldap
    443            https
    464            kpasswd
    587            submission
    625            dec_dlm
    636            ldaps
    749            kerberos-adm
    993            imaps
    995            pop3s
    1640           cert-responder
    2012           ttyinfo
    3659           apple-sasl
    4190           sieve
    5900           rfb

The the mail ports are 25, 110, 143, 587, 993, 995, they all need to be open.  4190 is used by dovecot for filtering mail, and I'm not sure if it actually needs to be open.

The ports for ssh and ARD are 22 and 5900.  I have a gateway and only the gateway can contact those ports.

The ports for Open Directory are 88, 106, 389, 464, 625, 636, 749, 3659 and for my setup, I don't want any of these open at all for anyone.  1640 and 2012 have something to do with certs.  80 and 443 are apache, and I have no idea why that is running, and ironically when I connect to the computer with a web browser it shows this text "Websites are turned off.
An administrator can turn them on using the Server application."  That's not "off" in my book...

#### Run a firewall script at startup.

I have my own startup solution using Xhooks (no real link for that anymore since I left my last job and haven't set up a new site for it).  Anyway, you can just create a launchdaemon or you can hijack Apple's /etc/rc.server.firewall script.  That script is executed by /etc/rc.server, and that script is executed by none other then [launchd](http://opensource.apple.com/source/launchd/launchd-842.90.1/support/launchctl.c) at startup (search that source file for rc.server).  And you thought the rc scripts were gone!

I can't explain all the ins and outs of setting up a firewall because there are too many things I don't know about them.  I'll just list a simple ipfw (deprecated) ruleset.  I'm not the best networking guru so I'm not sure if all of these rules are even needed for this, but I think it works so what the heck.

    # Default stuff
    sysctl -w net.inet.ip.fw.enable=1
    ipfw -q -f flush
    ipfw -q add allow all from any to any via lo0
    ipfw -q add deny log all from any to 127.0.0.0/8
    ipfw -q add deny log ip from 192.168.0.0/16 to any in via en0
    ipfw -q add deny log ip from 172.16.0.0/12 to any in via en0
    ipfw -q add deny log ip from 10.0.0.0/8 to any in via en0
    ipfw -q add deny log ip from any to 192.168.0.0/16 in via en0
    ipfw -q add deny log ip from any to 172.16.0.0/12 in via en0
    ipfw -q add deny log ip from any to 10.0.0.0/8 in via en0
    ipfw -q add allow tcp from any to any established
    ipfw -q add allow icmp from any to any
    ipfw -q add allow icmp from any to any icmptypes 3,4,11,12

    # Allow your GATEWAY (replace 10.0.0.9) with your IP or CIDR
    ipfw -q add allow ip from 10.0.0.9 to any

    # Allow the mail service (this isn't needed because it's a mostly open ruleset)
    ipfw -q add allow tcp from any to any 25, 110, 143, 587, 993, 995 in

    # Stop Open Directory
    ipfw -q add reset tcp from any to any 88, 106, 389, 464, 625, 636, 749, 3659 in
    # Stop Apache
    ipfw -q add reset tcp from any to any 80, 443 in
    # Stop Cert thingies
    ipfw -q add reset tcp from any to any 1640, 2012 in

    # Allow everything else
    ipfw add 65535 allow ip from any to any

If you wanted to really hijack /etc/rc.server.firewall, then create a directory at /etc/ipfilter and create an empty file named /etc/ipfilter/ipfwstate-on and a file named /etc/ipfilter/ipfw.conf that contains your rules.  Here is an example (note, this file is missing the 'ipfw' command because rc.server.firewall sends this whole thing to ipfw).

    add allow all from any to any via lo0
    add deny log all from any to 127.0.0.0/8
    add deny log ip from 192.168.0.0/16 to any in via en0
    add deny log ip from 172.16.0.0/12 to any in via en0
    add deny log ip from 10.0.0.0/8 to any in via en0
    add deny log ip from any to 192.168.0.0/16 in via en0
    add deny log ip from any to 172.16.0.0/12 in via en0
    add deny log ip from any to 10.0.0.0/8 in via en0
    add allow tcp from any to any established
    add allow icmp from any to any
    add allow icmp from any to any icmptypes 3,4,11,12

And just add this to protect the server from someone attempting to hack in.

    add deny log ip from 10.0.0.1 to any

More information on OS X Server
-----

* [Apple's advanced guide](https://help.apple.com/advancedserveradmin/mac/3.1/)
* [krypted.com guide](http://krypted.com/guides/mavericks-server/)
* [arstechnica.com review](http://arstechnica.com/apple/2013/12/a-power-users-guide-to-os-x-server-mavericks-edition)
* [Macgasm review](http://www.macgasm.net/2013/10/31/os-x-10-9-mavericks-server-review/)
* [yesdevnull.net](https://yesdevnull.net/2013/10/os-x-mavericks-server-my-tutorials/)
* [OS X Server Essentials 10.9 book](http://www.peachpit.com/store/apple-pro-training-series-os-x-server-essentials-10-9780321963543)
* [Take Control of OS X Server book](http://tidbits.com/article/14744)
