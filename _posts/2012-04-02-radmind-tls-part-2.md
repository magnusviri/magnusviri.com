---
layout:     default
title:      "Radmind TLS (part 2)"
date:       2012-04-02
editdate:   2020-05-11
categories: Radmind MacAdmin
disqus_id:  radmind-tls-part-2.html
---

Setting up -w2 is the same as setting up -w1 except for one big difference, you are going to create a cert for every command file that you want to associate with a cert.  That is potentially a lot of certs.  For that reason, this article is only going to briefly discuss the client cert creation process and then focus on automating it so that you can easily create and update the certs.

If you don't know how to create certs and you haven't read [part 1](http://www.magnusviri.com/radmind-tls-part-1.html), there is no point reading this.

Authorization -w1 requirements
--------------

Client

- /var/radmind/cert/ca.pem

Server default cert path (if you only have one server)

- /var/radmind/cert/cert.pem
- /Library/LaunchDaemons/com.example.radmind_server_secure_port.plist

Authorization -w2 requirements
--------------

Client

- /var/radmind/cert/ca.pem (part of -w1)
- /var/radmind/cert/cert.pem (unique for each command file)

Server

- /var/radmind/cert/ca.pem (same file as above)
- /var/radmind/cert/cert.pem (unique for each server, part of -w1)
- /Library/LaunchDaemons/com.example.radmind_server_secure_port.plist (modified!)

CA on Server
--------------

In [part 1](http://www.magnusviri.com/radmind-tls-part-1.html) I showed how to create a ca.pem file.  You need to put that file on your clients at /var/radmind/cert/ca.pem.

    cp /var/radmind/CA/ca.pem /var/radmind/cert/

Certificates on clients
--------------------------

This is pretty much the same as the previous post when you created a cert for the server. However, the common name (CN) is not the same.  The CN is the name that radmind looks for in the config file.

However, because this process needs to be repeated often, I'm not going to list teh commands because if you had to do this for each certificate, you wont!  I'm just going to list a script below that will do almost all of it.  It will create a cert and make an overload for it.  If you try to create a cert that already exists, it will ask if you want to revoke the old one and if you do then it will revoke the old one and create a new cert (revoking a cert doesn't seem to prevent stop to the server from the old cert).

The only thing the script doesn't do is decide which command files are going to use the cert.  So you must open up a command file and put the cert in it.

You also need to put the cert on the client.  The script creates symlinks from

    /certs/<name>

to

    /var/radmind/file/certs/<name>.T/private/var/radmind/cert/cert.pem

This makes it easier to transfer certs manually using to clients by running the following command on the client.

    sudo scp user@radmind.example.com:/certs/<name> /var/radmind/cert/cert.pem

If you are ever in doubt what the CN is for a cert, type the following command.

    grep Subject /path/to/cert.pem

Look for the text `CN=...`.

Certificates and the config file
--------------------------

You can use the cert in the config file to specify which command file a client should use.  You can still use IP if you want, but using a cert as an identifier may be easier for you.  If you want to mix IP and cert identification, then have a cert that wont be used for identification.  I use a cert named "identify_by_ip".

The main reason I use certs is if test boxes that have multiple partitions with different command files and for firewire drives that are managed by radmind but are run on machines that have other command files associated with them.  This allows us to boot a firewire drive to any computer and not care what the IP is and it can run radmind and get the right command file.  Anther good reason to use certs is if you are entirely DHCP and you can't control what IP goes to what machine.

So if the CN for a client cert is "generic_lab" then you would put the following in the config file to specify the command file named "some_file.K"

    generic_lab        some_file.K

Radmind server daemon running with -w2
---------------------------------------

Change your LaunchD plist files to use -w2 instead of the -w1 example listed in part 1 (change the 1 to 2 in the plist file).

After you make the change, you should unload it and reload it.

    launchctl unload /Library/LaunchDaemons/com.example.radmind_server_secure_port.plist

<p>Make sure that the radmind daemon listening on the port you intend to use is not running by running the command "ps awwx | grep radmind". If it is running, just kill it (if it isn't unloaded launchd will just relaunch it so make sure you unload it first). Next reload it.</p>

    launchctl load /Library/LaunchDaemons/edu.utah.scl.radmind_server_secure_port.plist

I'm sure there will be other issues. And you should test.

The script
---------------------------------------

Save this script to /usr/local/bin/makecert on your server.  Make sure you change the header information.  You need to have the openssl.conf file discussed in part one.  You need to create a file with the plaintext version of your password.  Then run the script.  It tries to do everything and protect you from mess up.

- [Download The Script](../blog/20110128_radmind_certs/makecert)

Links
---------------------------------------

- [http://webapps.itcs.umich.edu/radmind/index.php/TLS_Cookbook](http://webapps.itcs.umich.edu/radmind/index.php/TLS_Cookbook)
- [http://managingosx.wordpress.com/2006/09/22/certificate-creation-for-radmind/](http://managingosx.wordpress.com/2006/09/22/certificate-creation-for-radmind/)
