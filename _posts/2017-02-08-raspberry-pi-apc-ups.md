---
layout:     default
title:      "Raspbery Pi's and APC UPS'es"
date:       2017-02-08
editdate:   2020-05-11
categories: Tech
disqus_id:  raspberry-pi-apc-ups.html
---

I use Raspberry Pi's to monitor the status of my APC UPS'es (Uninterruptible Power Supplies).  I don't know if it will work with brands other than APC.  I install Raspian on them.  After I lay down the image I do these things to get this working.  I compiled this from various notes that are over a year old so I'm not promising they work.  The next time I go through this process though I'll update this with any corrections.

Updating the Raspberry Pi
-------------------------

I run these commands.  Enter a new password when you run `passwd`.

    sudo -s
    passwd
    apt-get -y -q update
    apt-get -y -q upgrade
    nano /etc/hosts

In /etc/hosts change "127.0.1.1 .*" to "127.0.1.1    your_hostname"

    nano /etc/hostname

/etc/hostname should contain "your_hostname" and that's all.

Configure ssh and authorized_keys.  I'll leave that to you.

Setting up UFW (firewall)
------------------------

Change "10.0.0.0/24" below to the CIDR that you wish to allow access.

    apt-get -y -q install ufw
    ufw status
    ufw allow from 10.0.0.0/24
    ufw --force enable
    ufw status numbered

Setting up apcupsd
------------------

    apt-get -y -q install apcupsd

    nano /etc/default/apcupsd

In /etc/default/apcupsd change "ISCONFIGURED=no" to "ISCONFIGURED=yes".

    nano /etc/apcupsd/apcupsd.conf

In /etc/apcupsd/apcupsd.conf make sure the following values are set as below.  Change "pick_a_name" to the name you wish to use.

    UPSNAME pick_a_name
    UPSCABLE usb
    UPSTYPE usb
    DEVICE
    NISIP 0.0.0.0

Start it up.

    apcupsd restart
    apctest
    apcaccess status
    /etc/init.d/apcupsd status

Setting up apcupsd-cgi
----------------------

    apt-get -y -q install apache2
    apt-get -y -q install apcupsd-cgi

    nano /etc/apache2/apache2.conf

In /etc/apache2/apache2.conf add the line "ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/" to the end.

Start it up.

    service apache2 restart

Edit /etc/apcupsd/hosts.conf to look like this.

    # /etc/apcupsd/hosts.conf
    #
    # Network UPS Tools - hosts.conf
    #
    # This file does double duty - it lists the systems that multimon will
    # monitor, and also specifies the systems that upsstats is allowed to
    # watch.  It keeps people from feeding random addresses to upsstats,
    # among other things.  upsimage also uses this file to know who it
    # may speak to. upsfstats too.
    #
    # Usage: list systems running upsd that you want to monitor
    #
    # MONITOR <address> "<host description>"
    #
    # Please note, MONITOR must start in column 1 (no spaces permitted)
    #
    MONITOR 10.0.0.1 "pick_a_name"

Add a line 'MONITOR 10.0.0.1 "pick_a_name"' for each Raspberry Pi running apcupsd (change the IP and name to the correct info).

Open in web browser (change 10.0.0.1 to the IP of your Raspberry Pi): http://10.0.0.1/cgi-bin/apcupsd/multimon.cgi

Setting up email and text notifications
---------------------------------------

    apt-get -y -q install mailutils
    apt-get -y -q install ssmtp

In the files below change 1234567890 to your phone number and all example.com's to the correct info.

Edit /etc/ssmtp/ssmtp.conf to look like this.

    #
    # Config file for sSMTP sendmail
    #
    # The person who gets all mail for userids < 1000
    # Make this empty to disable rewriting.
    root=postmaster

    # The place where the mail goes. The actual machine name is required no
    # MX records are consulted. Commonly mailhosts are named mail.domain.com
    mailhub=smtp.example.com

    # Where will the mail seem to come from?
    #rewriteDomain=

    # The full hostname
    hostname=your_hostname.example.com

    # Are users allowed to set their own From: address?
    # YES - Allow the user to specify their own From: address
    # NO - Use the system generated From: address
    FromLineOverride=YES

Edit /etc/apcupsd/apccontrol/changeme to look like this.

    #!/bin/sh
    #
    # This shell script if placed in /etc/apcupsd
    # will be called by /etc/apcupsd/apccontrol when apcupsd
    # detects that the battery should be replaced.
    # We send an email message to root to notify him.
    #
    SYSADMIN="poc@example.com"
    APCUPSD_MAIL="mail"

    HOSTNAME=`hostname`
    MSG="$HOSTNAME UPS battery needs changing NOW."
    #
    (
       echo "Subject: $MSG"
       echo " "
       echo "$MSG"
       echo " "
       /sbin/apcaccess status
    ) | $APCUPSD_MAIL -aFrom:no-reply@example.com -s "$MSG" $SYSADMIN

    curl "http://textbelt.com/text" -d "number=1234567890" -d message="$MSG"

    exit 0

Edit /etc/apcupsd/apccontrol/commfailure to look like this.

    #!/bin/sh
    #
    # This shell script if placed in /etc/apcupsd
    # will be called by /etc/apcupsd/apccontrol when apcupsd
    # loses contact with the UPS (i.e. the serial connection is not responding).
    # We send an email message to root to notify him.
    #
    SYSADMIN="poc@example.com"
    APCUPSD_MAIL="mail"

    HOSTNAME=`hostname`
    MSG="$HOSTNAME Communications with UPS lost"
    #
    (
       echo "Subject: $MSG"
       echo " "
       echo "$MSG"
    ) | $APCUPSD_MAIL -aFrom:no-reply@example.com -s "$MSG" $SYSADMIN

    curl "http://textbelt.com/text" -d "number=1234567890" -d message="$MSG"

    exit 0

Edit /etc/apcupsd/apccontrol/commok to look like this.

    #!/bin/sh
    #
    # This shell script if placed in /etc/apcupsd
    # will be called by /etc/apcupsd/apccontrol when apcupsd
    # restores contact with the UPS (i.e. the serial connection is restored).
    # We send an email message to root to notify him.
    #
    SYSADMIN="poc@example.com"
    APCUPSD_MAIL="mail"

    HOSTNAME=`hostname`
    MSG="$HOSTNAME Communications with UPS restored"
    #
    (
       echo "Subject: $MSG"
       echo " "
       echo "$MSG"
       echo " "
       /sbin/apcaccess status
    ) | $APCUPSD_MAIL -aFrom:no-reply@example.com -s "$MSG" $SYSADMIN

    curl "http://textbelt.com/text" -d "number=1234567890" -d message="$MSG"

    exit 0

Edit /etc/apcupsd/apccontrol/offbattery to look like this.

    #!/bin/sh
    #
    # This shell script if placed in /etc/apcupsd
    # will be called by /etc/apcupsd/apccontrol when the
    # UPS goes back on to the mains after a power failure.
    # We send an email message to root to notify him.
    #
    SYSADMIN="poc@example.com"
    APCUPSD_MAIL="mail"

    HOSTNAME=`hostname`
    MSG="$HOSTNAME Power has returned"
    #
    (
       echo "Subject: $MSG"
       echo " "
       echo "$MSG"
       echo " "
       /sbin/apcaccess status
    ) | $APCUPSD_MAIL -aFrom:no-reply@example.com -s "$MSG" $SYSADMIN

    curl "http://textbelt.com/text" -d "number=1234567890" -d message="$MSG"

    exit 0

Edit /etc/apcupsd/apccontrol/onbattery to look like this.

    #!/bin/sh
    #
    # This shell script if placed in /etc/apcupsd
    # will be called by /etc/apcupsd/apccontrol when the UPS
    # goes on batteries.
    # We send an email message to root to notify him.
    #
    SYSADMIN="poc@example.com"
    APCUPSD_MAIL="mail"

    HOSTNAME=`hostname`
    MSG="$HOSTNAME Power Failure !!!"
    #
    (
       echo "Subject: $MSG"
       echo " "
       echo "$MSG"
       echo " "
       /sbin/apcaccess status
    ) | $APCUPSD_MAIL -aFrom:no-reply@example.com -s "$MSG" $SYSADMIN

    curl "http://textbelt.com/text" -d "number=1234567890" -d message="$MSG"

    exit 0

### Test

You should get an email and a text when you do any of these actions.

* Unplug the UPS from the wall outlet
* Plug it back in
* Unplug the USB cable
* Plug it back in

You will also get a text when the battery is bad but I can't remember how to (or if you can) test that.