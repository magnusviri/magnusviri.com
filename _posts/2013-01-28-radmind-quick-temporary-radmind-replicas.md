---
layout:     default
title:      "Quick Temporary Radmind Replicas"
date:       2013-01-28
editdate:   2020-05-11
categories: Graveyard
disqus_id:  quick-temporary-radmind-replicas.html
---

Sometimes I want to distribute a large overload (2-40 gigs) to all 600 of my computers as quickly as possible without bringing my radmind server to a halt.  By turning some of my clients into temporary radmind servers I can use them to help distribute large overloads quickly.  I run these steps using Apple Remote Desktop.

The [radmind tools](http://radmind.org) need to be installed on the computer but I'm assuming the server portion wont be setup (obviously).  The [download_overload.pl](http://www.magnusviri.com/radmind-scripts.html) script needs to be installed on all of the clients.  For download_overload.pl to work you need to include the overload you wish to distribute in the command files for the machines located on the radmind server.

Run these commands on any computer you wish to turn into a radmind server quickly.  In all of these steps you'll need to replace `example_overload.T` with the name of the overload you really want to deploy.

Become root:

    sudo -s

Setup the folders that will contain the overload you want to distribute quickly.

    mkdir -p /var/radmind/transcript
    mkdir -p /var/radmind/file/example_overload.T

Download the overload from the radmind server (replace `radmind.example.com` with your radmind server).

    cd /var/radmind/file/example_overload.T
    download_overload.pl -kfh radmind.example.com example_overload.T

Move the transcript from the client folder to the deployment folder.

    mv /var/radmind/client/example_overload.T /var/radmind/transcript/example_overload.T

Set up the config and command file so that any computer can download it.  This is a security hole so don't leave this computer running like this, either disable radmind by rebooting or running `sudo killall radmind`.  Or you could setup a real

    echo "* all.K" > /var/radmind/config
    mkdir /var/radmind/command
    echo "p example_overload.T" > /var/radmind/command/all.K

Start the radmind daemon.

    /usr/local/sbin/radmind  -p 6222

---

Now on the clients you really want to download the overload (including the replica itself) run (`replica.example.com` with your the computer you just ran the above steps on).

    sudo -s
    cd /

    download_overload.pl -kfh replica.example.com example_overload.T

---

The point of the above steps is that you can deploy an overload extremely quickly.  If you had 600 computers run the above steps on about 20 of your computers and then each of those could be used as a temporary replica and host the overload for 30 other computers for a total of 600 computers.  This puts the burden on the network and not on a single server.  Hopefully the network can handle the load.  This way you only have to wait for the overload to download twice, once to the replicas, and the second time to all the clients, but you've just deployed it to 600 computers.  Coolness in my opinion.
