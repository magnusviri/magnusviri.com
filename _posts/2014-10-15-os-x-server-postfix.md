---
layout:     default
title:      "OS X Server - Postfix"
date:       2014-10-15
editdate:   2020-05-11
categories: Mac
disqus_id:  os-x-server-postfix.html
render_with_liquid: false
---

[Update 2019-04-13: I no longer run a Mac OS X Server and [Mac OS X Server is dead](https://support.apple.com/en-us/HT208312).]

Postfix handles the mail sending and receiving.  Email servers and email clients connect to postfix and either give it email to send somewhere else (either to another email server, or send it to dovecot for local users).  It does SMTP, not IMAP or POP.  Dovecot does IMAP and POP.

Here are my notes on managing postfix on OS X Server (3.1.2) on Mavericks 10.9.4.  This all assumes you know the basics of starting and configuring the Mail service using Server.app.  A lot of this information also applies to the default postfix installation in OS X.

Note, this post is part of a series.  Here are the other posts.

* OS X Server - [Basics](http://www.magnusviri.com/os-x-server-basics.html)
* OS X Server - [Managing user accounts](http://www.magnusviri.com/os-x-server-managing-user-accounts.html)
* OS X Server - Postfix (this page)
* OS X Server - [Dovecot](http://www.magnusviri.com/os-x-server-dovecot.html)
* OS X Server - [Sieve](http://www.magnusviri.com/os-x-server-sieve.html)
* OS X Server - [Postfix Queues](http://www.magnusviri.com/os-x-server-postfix-queues.html)

Working with the Postfix using non-postfix tools.
-----

#### Make sure MX record is set correctly

    dig -t MX example.com

#### Check the status

    sudo serveradmin fullstatus mail

#### Stop the mail service

    sudo serveradmin stop mail

#### Start the mail service

    sudo serveradmin start mail

#### A full list of settings

    sudo serveradmin settings mail

A lot of information on the different settings that can be configured is detailed at [krypted.com](http://krypted.com/mac-os-x/configure-the-mail-service-in-mavericks-server/).

OS X Client vs Server
-----

OS X has postfix installed by default and it has a default set of config files.  The default config files are configured to send email only, it will not act as an email server.

The launchdaemon at /System/Library/LaunchDaemons/org.postfix.master.plist controls how the system launches postfix.  By default, that launchdaemon instructs launchd to watch the directory /var/spool/postfix/maildrop, and if it changes, then it executes /usr/libexec/postfix/master, the master postfix daemon.  The launchdaemon also gives the master daemon the arguments "-e 60", which tells master to quit after 60 seconds.

The Server.app changes a few things.  It installs a new set of config files at /Library/Server/Mail/Config/postfix.  It changes the launchdaemon shown above to launch postfix using the new config files.  It doesn't quit the master daemon after 60 seconds.  And it watches a different directory for email to send, /Library/Server/Mail/Data/spool/maildrop.

If you want to see the differences between OS X client and server, compare /etc/postfix with /Library/Server/Mail/Config/postfix.

Specify the correct config files with `-c config_dir`
-----

When running postfix commands you need to specify which config files located at /etc/postfix you want to read or else it will read the default config files that are installed with the OS.

I'm not going to show the -c argument in this document for every command I run.  If I show the output of a command, I'll probably show the output of the default /etc/postfix directory, and maybe I'll show what is different for /Library/Server/Mail/Config/postfix.  Either way, you kind of have to read the text to figure out if I'm talking about /etc/postfix or /Library/Server/Mail/Config/postfix because I don't want to list "-c /Library/Server/Mail/Config/postfix" all the time.

View non-default settings on OS X client (/etc/postfix).

    postconf -n

View non-default settings on OS X Server.

    postconf -n -c /Library/Server/Mail/Config/postfix

If you get tired of typing that -c argument, you could create an alias.

For sh (using a hypothetical postsomething command)

    alias postsomething2="postsomething -c /Library/Server/Mail/Config/postfix"

For tcsh (using a hypothetical postsomething command)

    alias postsomething2 "postsomething -c /Library/Server/Mail/Config/postfix"

Or you could assign it to a shell variable.

For sh (dc is short for "dash c")

    dc="-c /Library/Server/Mail/Config/postfix"
    postconf -n $dc

For tcsh

    setenv dc "-c /Library/Server/Mail/Config/postfix"
    postconf -n $dc

You might want to setup your shell to always alias these commands or assign the variables if you use the command line often, because I can imagine typing that path is going to get lame fast.

Or if you're lazy like me, you could just create a symlink so you don't have to type the full path.

    ln -s /Library/Server/Mail/Config/postfix /p
    postconf -n -c /p

Learning Postfix
-----

Official docs can be found at [postfix.org](http://www.postfix.org/documentation.html).  Note, OS X Server 3.1 includes Postfix 2.9.4 (I found that by looking at /var/log/mail.log while starting the mail service, and by running `postconf mail_version`).

The Postfix version matters because the documentation is for all versions of Postfix and when different versions behave differently, the documentation specifies which version does what. As of July 2014, the lastest version of Postfix is 2.11.  I have heard that many institutions are about 2 dot versions behind, so I don't think it's too alarming that OS X Server is 2 dot versions behind.

Read man pages:

* [postfix(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postfix.1.html)
* [postconf(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postconf.1.html)
* [postmap(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postmap.1.html)
* [postalias(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postalias.1.html)
* [newaliases(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/newaliases.1.html)
* [postlog(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postlog.1.html)
* [postcat(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postcat.1.html)
* [postsuper(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postsuper.1.html)
* [sendmail(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/sendmail.1.html)
* Many more (see [postfix(1)](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/postfix.1.html) man page for a full list)

Postfix Basics
-----

#### Start and Stop Postfix

    postfix start
    postfix stop

#### To re-read configuration files (after you make a change), enter:

    postfix reload

The log is located at: /var/log/mail.log.  This is set by /etc/asl.conf.

If you `tail -f /var/log/mail.log` you'll see the mail server sending and receiving mail as it runs.  It's very informative.

Postfix Settings
-----

#### Displaying settings

This will display a long list (over 800) of settings (including default settings).

    postconf

Display settings that are not default (changed in main.cf).

    postconf -n

On OS X it produces this.  OS X Server has a much longer list.

    biff = no
    command_directory = /usr/sbin
    config_directory = /Library/Server/Mail/Config/postfix
    daemon_directory = /usr/libexec/postfix
    data_directory = /Library/Server/Mail/Data/mta
    debug_peer_level = 2
    debugger_command = PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin xxgdb $daemon_directory/$process_name $process_id & sleep 5
    dovecot_destination_recipient_limit = 1
    html_directory = /usr/share/doc/postfix/html
    imap_submit_cred_file = /Library/Server/Mail/Config/postfix/submit.cred
    inet_interfaces = loopback-only
    inet_protocols = all
    mail_owner = _postfix
    mailbox_size_limit = 0
    mailq_path = /usr/bin/mailq
    manpage_directory = /usr/share/man
    message_size_limit = 10485760
    mydomain_fallback = localhost
    mynetworks = 127.0.0.0/8, [::1]/128
    newaliases_path = /usr/bin/newaliases
    queue_directory = /Library/Server/Mail/Data/spool
    readme_directory = /usr/share/doc/postfix
    recipient_delimiter = +
    sample_directory = /usr/share/doc/postfix/examples
    sendmail_path = /usr/sbin/sendmail
    setgid_group = _postdrop
    smtpd_client_restrictions = permit_mynetworks permit_sasl_authenticated permit
    smtpd_tls_ciphers = medium
    smtpd_tls_exclude_ciphers = SSLv2, aNULL, ADH, eNULL
    tls_random_source = dev:/dev/urandom
    unknown_local_recipient_reject_code = 550
    use_sacl_cache = yes

To see how Mac OS X configures Postfix differently than the default, run these commands.

    postconf > /tmp/postconf_all
    postconf -d > /tmp/postconf_default
    diff /tmp/postconf_all /tmp/postconf_default

#### Display a particular setting:

    postconf -h config-value

#### Change a setting

    postconf -e param=value

Or edit your mail.cf file.

#### Some settings you should probably look up

What the machine name is (this is not shown by postconf -n)

    postconf myhostname

What Postfix version you have

    postconf mail_version

Postfix Mappings
-----

Mappings are similar but different then settings.  Note, postmap uses the -c to specify the config directory just like postconf.  Mappings are stored in plain text but then they are converted into a database so that postfix and read them quickly.  They have different formats.

#### Find out what lookup table types your Postfix supports.

    postconf -m

OS X and OS X Server support these lookup tables (that means this version of postfix was compiled with support for these, there are others that could be added but Apple didn't choose to include them).

    btree
    cidr
    environ
    fail
    hash
    internal
    ldap
    memcache
    pcre
    proxy
    regexp
    static
    tcp
    texthash
    unix

Mostly you will work with hash.

#### Lookup tables

There are many different lookup tables.  They are located in the config directory, /etc/postfix for OS X client (the send only version), or /Library/Server/Mail/Config/postfix for OS X Server.  These are the tables in /etc/postfix.

    access
    aliases
    canonical
    custom_header_checks
    generic
    header_checks
    relocated
    transport
    virtual

All of these files have commented out instructions and are essentially empty (except for `custom_header_checks`, which has one entry).  If you ever change one of these files you need to run postmap and point it to the file so that it can update the indexed database that postfix uses whenever you change the canonical table.

Update a mapping

    postmap /etc/postfix/canonical

The exception is aliases, you need to run `newaliases`.  There is also the `postalias` command that allows you to maintain the alias database.  Also, OS X Server appears to be configured to us /etc/aliases instead of /Library/Server/Mail/Config/postfix/aliases (that file exists, but isn't used).  Run `postconf -c /Library/Server/Mail/Config/postfix alias_maps` to make sure.

OS X Server has a few more lookup tables.  Server.app edits these extra files and they basically have comments telling you not to edit them.

    rbl_whitelist
    system_user_maps
    virtual_domains
    virtual_users

This is what you see in rbl_whitelist.

    ### DO NOT MANUALLY EDIT THIS FILE ###
    # This file is automatically generated
    # any manual additions to this file will be lost


#### Display a mapping.

    postmap -q key lookup_table_type:lookup_table

Example:

    postmap -q "subject: " regexp:/etc/postfix/custom_header_checks

Regular Expressions:

    postmap -q "string" regexp:/etc/postfix/filename
    postmap -q - regexp:/etc/postfix/filename <inputfile

Perl Compatible Regular Expressions:

    postmap -q "string" pcre:/etc/postfix/filename
    postmap -q - pcre:/etc/postfix/filename <inputfile

Name rewriting
---------------

To find out the location for your system, execute the command "postconf alias_maps".

    aliases
    alias_maps = hash:/etc/aliases

Queues
---------

I have a dedicated page discussing [Postfix queues](http://www.magnusviri.com/os-x-server-postfix-queues.html).

Authentication
-----------

You should read the [SASL_README](http://www.postfix.org/SASL_README.html), and in particular, the section [Enabling SASL authentication and authorization in the Postfix SMTP server](http://www.postfix.org/SASL_README.html#server_sasl_enable).

To see all of the settings related to authentication, use this command

    postconf | grep sasl

If "smtpd_sasl_auth_enable" is "yes", then it is turned on.  On OS X in /etc/postfix it is off.  The server config (/Library/Server/Mail/Config/postfix) has it turned on.

Find out the SASL compiled into postfix:

    postconf -a

OS X and OS X Server include these:

> cyrus
> dovecot

#### Broken Outlook

Outlook up to and including version 2003 and Outlook Express up to version 6 is broken.  The broken_sasl_auth_clients configuration option lets Postfix talk to these broken clients using non-standard communications.  This option does not hurt other clients.

To view the setting.

    postconf -h broken_sasl_auth_clients

To change it.

    postconf -e broken_sasl_auth_clients=yes

#### Disable non TLS plain text password

By default Postfix allows plain text authentication over a non-TLS connection.  OS X Server uses the default setting as well.  You can change it so that non-TLS will not allow plain text but a TLS connection will allow plaintext like this.

    postfix -e smtpd_sasl_tls_security_options=noanonymous
    postfix -e smtpd_sasl_security_options=noanonymous,noplaintext

<a name="TLS"></a>

TLS/SSL and certificates.
-----------

You should read the [TLS_README](http://www.postfix.org/TLS_README.html).

Learn [what TLS, SSL, and STARTTLS really means](https://www.fastmail.fm/help/technical/ssltlsstarttls.html).  Summary: it means something different to each email client.  STARTTLS is suppose to mean start talking unencrypted and switch to encryption for SMTP, IMAP, and POP over ports 25/587, 143, and 110 respecively.  TLS/SSL is suppose to mean start talking encrypted from the beginning, SMTP, IMAP, and POP over ports 465, 995, and 993 respectively.

Unencrypted at first (STARTTLS switches it to encrypted):

* SMTP 25/587 - STARTTLS
* IMAP 143 - STARTTLS
* POP 110 - STARTTLS

Encrypted the whole time:

* SMTP 465 - SSL/TLS
* IMAP 993 - SSL/TLS
* POP 995 - SSL/TLS

If you use TLS/SSL you must get a valid certificate for your server or else your clients will get constant warnings that your server certificate is not valid (because OS X self-signs it).  The University of Utah has a [contract with a certificate provider](https://uofu.service-now.com/cf/kb_view.do?sysparm_article=KB0000934).

It took me several attempts to get my certificate to work with OS X.  First you have to generate a certificate signing request (CSR) using the Server app.  You send that to the vendor for a certificate.  When you get the certificate back, you are suppose to drop it in the Server app but I kept getting errors that there was no corresponding private key.  I really hate how OS X does private keys because I haven't been able to find out which one is for what.

Anyway, I did get my certificate installed but I'm not entirely sure what I did.  I believe I dragged it into KeyChain Access.

Quarantine
-----------

My server gets so much quarantined email that it is impossible to keep up with it.  The server can email you when it gets an alert for one, but I had to filter all of the to the trash because I got so many.  They are stored in /Library/Server/Mail/Data/scanner/quarantine.  They are eventually deleted.

You can read quarantined email with these commands.

    zless /Library/Server/Mail/Data/scanner/quarantine/spam-jSrs79ZVXT8I.gz
    gzcat /Library/Server/Mail/Data/scanner/quarantine/spam-jSrs79ZVXT8I.gz
    zgrep "not spam" /Library/Server/Mail/Data/scanner/quarantine/

If you are using Time Machine, you can search all the backups like this.

This shows you the part of each file that matches.

    zgrep -r "text" /Volumes/TimeMachine/Backups.backupdb/Your_Server/*/Macintosh\ HD/Library/Server/Mail/Data/scanner/quarantine

This shows the list of files.

    zgrep -rl --null "text" /Volumes/TimeMachine/Backups.backupdb/biomail/*/Macintosh\ HD/Library/Server/Mail/Data/scanner/quarantine | xargs -0 ls -l

This shows the first 15 lines of each message.

    zgrep -rl --null "text" /Volumes/TimeMachine/Backups.backupdb/biomail/*/Macintosh\ HD/Library/Server/Mail/Data/scanner/quarantine | xargs -0 head -n15

<a name="content_filtering" />

Content filtering (checks)
--------------------------

Postfix allows you to filter emails based on the content.  This is designed to be a lightweight check though since it can significantly slow things down.  By default OS X Server has the header_check enabled and it points to /Library/Server/Mail/Config/postfix/custom_header_checks.  You can edit this file to add something like the following.

    /^subject: [SPAM$/ HOLD

Note, when making filters you should use WARN instead of HOLD and you instead of modifying /Library/Server/Mail/Config/postfix/custom_header_checks create a file like /tmp/test_filter that contains your filter.  This way you're not writing and testing filters in production.  So I'm putting this text in a file /tmp/test_filter.

    /^subject: [SPAM$/ WARN

Then I create a test email and save it to /tmp/test_email.  It looks like this.

    From: nil@example.com
    Subject: [SPAM-90%] Buy this or that
    bla bla bla

Then you can test your filter like this.

    postmap -q - pcre:/tmp/test_filter < /tmp/test_email

If I run it, it prints a message:

    postmap: warning: pcre map /tmp/test_filter, line 1: error in regex at offset 16: missing terminating ] for character class

Doh!  Good thing I tested first!  I forgot I was writing regular expressions.  It should look like this.

    /^subject: \[SPAM$/ WARN

Nothing was printed, which means my regular expression didn't match.  Well, ok, it really should look like this (without the ending $).

    /^subject: \[SPAM/ WARN

If it matches it will print this.

    Subject: [SPAM-90%] Buy this or that    WARN

Now I move the contents of /tmp/test_filter to /Library/Server/Mail/Config/postfix/custom_header_checks and then I run these commands.

    postfix reload
    sendmail null@example.com < /tmp/test_email

There should be a warning in my mail log (/var/log/mail.log).  When I'm happy with it, I need to change WARN to HOLD or REJECT or DISCARD.

If you search the web for "header_checks examples" you can find webpages that list some examples.  Here's mine.  It's all listed WARN for testing.

    #/^subject: *$/                             REJECT empty subject header
    #/^Subject: \[SPAM/                         WARN SPAM subject
    #/^From:(.*)user005@badspammerdomain.com/   WARN #spam Known spammer address

    /^To:.*<?Undisclosed Recipients?>?$/        WARN Wrong undisclosed recipients header
    /^Subject: .*      /                        WARN Spam Header Many Spaces 1
    /^Date: .* 19[0-9][0-9]/                    WARN Spam Header Past Date 1
    /^Date: .* 200[0-9]/                        WARN Spam Header Past Date 2
    /^Date: .* 201[0-4]/                        WARN Spam Header Past Date 3
    /^Date: .* 20[2-9][0-9]/                    WARN Spam Header Future Date 1
    /^X-Spam-Level: \*{15,}.*/                  WARN Spam level above 15

    #### non-RFC Compliance headers
    /[^[:print:]]{7}/                           WARN 2047rfc
    /^.*=20[a-z]*=20[a-z]*=20[a-z]*=20[a-z]*/   WARN 822rfc1
    /(.*)?\{6,\}/                               WARN 822rfc2
    /(.*)[X|x]\{3,\}/                           WARN 822rfc3

    /^Subject:.*=\?(GB2312|big5|euc-kr|ks_c_5601-1987|koi8)\?/ WARN NotReadable1 $1
    /^Content-Type:.*charset="?(GB2312|big5|euc-kr|ks_c_5601-1987|koi8)/ WARN NotReadable2 $1
    /^Content-(Type|Disposition):.*(file)?name=.*\.(bat|com|exe)/ WARN Bad Attachment .${3}

    /^Received: from .*\.local/                 WARN
    /^Subject: ADV:/                            WARN Advertisements not accepted by this server
    /^Subject: =?Windows-1251?/                 WARN Russian encoding not allowed by this server 1

    /[^[:print:]]{8}/                           WARN Sorry, ascii characters only permitted by this server
    /^(To|From|Cc|Reply-To):.*@optonline/       WARN Sorry, your message is probably spam

Avoiding getting blacklisted
-----------

Avoiding getting blacklisted
-----------

There are free services you can sign up that will monitor the real-time blacklist servers (RBL).

* [http://mxtoolbox.com](http://mxtoolbox.com)

You can also view your mail server score

* [https://senderscore.org](https://senderscore.org)
* [http://www.senderbase.org](http://www.senderbase.org)

Other things you should do.  Make sure your DNS is correct. Use an MX record.  Use an SPF record.  [This article on email server DNS records](http://www.rackaid.com/blog/email-dns-records/) is pretty helpful.

Outlook problem #2
-----------

In /Library/Server/Mail/Config/postfix/main.cf, locate the smtpd_helo_restrictions setting.  Remove "reject_non_fqdn_helo_hostname" from the list of settings.  Restart the Mail service.  [Apple KB article](http://support.apple.com/kb/TS3023).

Debugging
-----------

You should read the [DEBUG_README](http://www.postfix.org/DEBUG_README.html).

You can do [bottleneck analysis](http://www.postfix.org/QSHAPE_README.html).

To debug a particular site:
    debug_peer_list = example.com
    debug_peer_level = 2

There are several other links about debugging postfix.

* [Postfix book](http://www.postfix-book.com/debugging.html)
* [OnLamp article](http://www.onlamp.com/pub/a/onlamp/2004/01/22/postfix.html)

3rd party utils:

    [postfinger](http://ftp.wl0.org/SOURCES/postfinger)
    [saslfinger](http://postfix.state-of-mind.de/patrick.koetter/saslfinger/)

Postfix version 2.1 and later can produce debugging reports, a "what-if" report and a "what-happened" report.

What-if:

    $ /usr/sbin/sendmail -bv address...

What happened:

    $ /usr/sbin/sendmail -v address...

The reports are emailed to you and the format of these reports is practically identical to that of ordinary non-delivery notifications.

To see what ports are listening:

    netstat -t -a | grep LISTEN
    lsof -i tcp:25

Stress test (don't run this on a production server):

    smtp-source
    smtp-sink

Example:

    smtp-sink -c localhost:25 1000

    time smtp-source -s 20 -l 5120 -m 100 -c -f sender@example.com -t recipient@example.com localhost:25

Meaning of flags.

* "-s 20" - 20 parallel sessions
* "-l 5120" - 5KB message size
* "-m 100" - 100 total messages
* "-c" - display a counter
* "-f sender@example.com" - From
* "-t recipient@example.com" - To
* "localhost:25" - target

Sending email from the command line:

    echo bla | /usr/sbin/sendmail -f root root && tail -f /var/log/mail.log

Working with log files
-------------

Because my log files got really really big after awhile, I added "rotate=local-basic dest=/var/log/mail ttl=1780" to the asl.config.  I specify ttl of 1780 days because I'm pretty sure the default is 7 and I want to save my mail log files so I can process them.  Now the line for mail looks like this.

    ? [= Facility mail] [<= Level info] file /var/log/mail.log mode=0644 uid=27 gid=27 gid=6 format=bsd rotate=local-basic dest=/var/log/mail ttl=1780

I also created the directory /var/log/mail.

There is also the utility [pflogsumm](http://jimsun.linxnet.com/postfix_contrib.html).  I downloaded the script, put it in /usr/local/bin, and then I created a script at /etc/periodic/daily/510.pflogsumm, which grabs the newest file and runs pflogsumm on it.

    #!/usr/bin/perl

    my $mail_dir = "/var/log/mail";
    opendir(my $DH, $mail_dir) or die "Error opening $mail_dir: $!";
    my %files = map { $_ => (stat("$mail_dir/$_"))[9] } grep(! /^\.\.?$/, readdir($DH));
    closedir($DH);
    my @sorted_files = sort { $files{$b} <=> $files{$a} } (keys %files);
    my $file = "$mail_dir/$sorted_files[0]";

    system "/usr/local/bin/pflogsumm -u 5 -h 5 --problems_first $file | mail -s \"pflogsumm $file\" root";
