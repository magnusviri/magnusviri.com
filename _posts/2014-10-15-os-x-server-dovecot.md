---
layout:     default
title:      OS X Server - Dovecot
date:       2014-10-15
editdate:   2020-05-11
categories: MacOSXServer
disqus_id:  os-x-server-dovecot.html
render_with_liquid: false
---

[Update 2019-04-13: I no longer run a Mac OS X Server and [Mac OS X Server is dead](https://support.apple.com/en-us/HT208312).]

Dovecot gets email handed to it by postfix (called "local delivery") and dovecot stores the email until an email client connects and retrieves email.  Dovecot does IMAP or POP, not SMTP.  Postfix does SMTP.

Here are my notes on managing dovecot on OS X Server (3.1.2) on Mavericks 10.9.4.  This all assumes you know the basics of starting and configuring the Mail service using Server.app.

Note, this post is part of a series.  Here are the other posts.

* OS X Server - [Basics](http://www.magnusviri.com/os-x-server-basics.html)
* OS X Server - [Managing user accounts](http://www.magnusviri.com/os-x-server-managing-user-accounts.html)
* OS X Server - [Postfix](http://www.magnusviri.com/os-x-server-postfix.html)
* OS X Server - Dovecot (this page)
* OS X Server - [Sieve](http://www.magnusviri.com/os-x-server-sieve.html)
* OS X Server - [Postfix Queues](http://www.magnusviri.com/os-x-server-postfix-queues.html)
* OS X Server - [Postfix Queues](http://www.magnusviri.com/os-x-server-postfix-queues.html)

Learning Dovecot
-----------

[Apple's mail server architecture documentation](http://help.apple.com/advancedserveradmin/mac/3.1/#apdDCC9970C-9253-47C4-8152-7A5272CF753E) includes a good explanation how all of the services (postfix and dovecot) fit together.  If you don’t have a basic idea, it’s good to just look this over.

Here are links to the official dovecot site and documentation.

* [Dovecot.org](http://www.dovecot.org), note, OS X Server includes dovecot v2.2.5 (Find by running `dovecotd --version`)
* [Dovecot wiki](http://wiki2.dovecot.org/FrontPage)
man pages: doveadm(1), doveconf(1), dovecot-lda(1), dsync(1)
* [TestInstallation](http://wiki2.dovecot.org/TestInstallation)
* [TestPop3Installation0](http://wiki2.dovecot.org/TestPop3Installation0

Dovecot is not installed by default on OS X.  It is included in the Server.app bundle, located at /Applications/Server.app/Contents/ServerRoot/usr/libexec/dovecot.

Dovecot Basics
-----------

#### Start Dovecot

    dovecotd

#### Stop Dovecot

    dovecotd stop

#### To re-read configuration files (after you make a change), enter:

    dovecotd reload


Dovecot Settings
-----------

Display settings that are not default.

    doveconf -n

The config file is located at /Library/Server/Mail/Config/dovecot/dovecot.conf.

To see how Mac OS X configures Dovecot differently than the default, run these commands.

    doveconf -a > /tmp/doveconf_all
    doveconf -d > /tmp/doveconf_default
    diff /tmp/doveconf_all /tmp/doveconf_default

Dovecot Logging
-----------

To find the location of the logs use

    doveadm log find

They are located at /Library/Logs/Mail/.  Here's all of the log files I've got in there.

    amavis.log
    clamav.log
    freshclam.log
    junkmail.log
    listserver.log
    mail-debug.log
    mail-err.log
    mail-info.log
    mail-info.log.0.bz2

If I run `tail -f /Library/Logs/Mail/mail-info.log` I'll see all of my user's connections.  You'll also notice that the old log files are bzipped.  You can search them using `bzgrep` and you can display them using `bzcat`.

This is how I'd find out when a user named "matt" last logged in (assuming my server IP was 10.0.0.1).

    bzgrep -r "Login: user=<matt" mail-info.log.* | grep -v rip=10.0.0.1| tail -n1
    grep -r "Login: user=<matt" mail-info.log | grep -v rip=10.0.0.1| tail -n1

I've use this regular expression to convert the log entries to tab delimited format so I can put it in a spreadsheet.  My replacement syntax is for BBEdit.

    Search: .*mail-info.log.*:(\w+ \w+ \w+:\w+:\w+) (\w+)-login: Info: Login: user=<(.+)>, method=(.+), rip=([:.\d]+), lip=([:.\d]+), mpid=(\d+),? ?(.*)

    Replace: \1\t\2\t\3\t\4\t\5\t\6\t\7\t\8

This script will do an exhaustive search to find all of the last Dovecot and Postfix logins (including looking for aliases).

    #!/usr/bin/perl

    my $ignore_users = "^vpn|^diradmin";
    my $logs_dir = "/Library/Logs/Mail";

    my $dovecot_logins = {};
    my @old_logs = `ls -tr $logs_dir/mail-info.log.*`;
    foreach my $old_log ( @old_logs ) {
        parse_dovecot_logins( "bzgrep -r \"Login: user=<\" $old_log", $dovecot_logins );
    }
    parse_dovecot_logins( "grep -r \"Login: user=<\" $logs_dir/mail-info.log", $dovecot_logins );

    my $postfix_logins = {};
    parse_postfix_logins( "grep username= /var/log/mail.log", $postfix_logins );

    my @user_names = @ARGV;
    if ( $#user_names < 0 ) {
        @records = `dscl /LDAPv3/127.0.0.1 -list /Users`;
        foreach my $record ( @records ) {
            chomp $record;
            if ( $record !~ /$ignore_users/ ) {
                push ( @user_names, $record );
            }
        }
    }

    print "Server\tDate\tUser\tProtocol\tAuthType\tIP\tDNS\tEncryption\n";

    foreach my $user ( @user_names ) {
        my $check_for_aliases = `dscl /LDAPv3/127.0.0.1 -read /Users/$user RecordName`;
        chomp $check_for_aliases;
        my @aliases = split(/ /, $check_for_aliases);
        shift @aliases;
        my @logins = ();
        my $dovecot_login = 0;
        my $postfix_login = 0;
        foreach my $alias ( @aliases ) {
            if ( $$dovecot_logins{$alias} ) {
                my $logins = $$dovecot_logins{$alias};
                my $last_login = pop @$logins;
                print "Dovecot\t$$last_login{date}\t$alias\t$$last_login{proto}\t$$last_login{authtype}\t$$last_login{RIP}\t\t$$last_login{encrypt}\n";
                $dovecot_login = 1;
            }
            if ( $$postfix_logins{$alias} ) {
                my $logins = $$postfix_logins{$alias};
                my $last_login = pop @$logins;
                print "Postfix\t$$last_login{date}\t$alias\tsmtp\t$$last_login{authtype}\t$$last_login{ip}\t$$last_login{dns}\t\n";
                $postfix_login = 1;
            }
        }
        if ( ! $dovecot_login ) {
            print "Dovecot\tNever\t$user\t\t\t\n";
        }
        if ( ! $postfix_login ) {
            print "Postfix\tNever\t$user\t\t\t\n";
        }

    }

    sub parse_dovecot_logins {
        my ( $command, $hash ) = @_;
        my @lines = `$command`;
        foreach my $line ( @lines ) {
            if ( $line =~ /.*mail-info.log.*:(\w+ +\w+ \w+:\w+:\w+) (\w+)-login: Info: Login: user=<(.+)>, method=(.+), rip=([:.\d]+), lip=([:.\d]+), mpid=(\d+),? ?(.*)/ ) {
                my $user = $3;
                my $login_hash =  {'date'=>$1,'proto'=>$2,'authtype'=>$4,'RIP'=>$5,'encrypt'=>$8,};
                if ( $$hash{$user} ) {
                    push @{$$hash{$user}}, $login_hash;
                } else {
                    $$hash{$user} = [$login_hash];
                }
            }
        }
    }

    sub parse_postfix_logins {
        my ( $command, $hash ) = @_;
        my @lines = `$command`;
        foreach my $line ( @lines ) {
            if ( $line =~ /^(\w+ +\w+ \w+:\w+:\w+) .* postfix\/smtpd\[\d+\]: (.*): client=(.*)\[([\.\d]+)\], sasl_method=(.*), sasl_username=(.*)/ ) {
                my $user = $6;
                my $login_hash =  {'date'=>$1,'dns'=>$3,'ip'=>$4,'authtype'=>$5,};
                if ( $$hash{$user} ) {
                    push @{$$hash{$user}}, $login_hash;
                } else {
                    $$hash{$user} = [$login_hash];
                }
            }
        }
    }

Authentication methods
-----------

[Apple's mail service documentation](http://help.apple.com/advancedserveradmin/mac/3.1/#apdF077011B-DA71-475C-B95A-3F4855CE9C78) lists the available authentication mechanisms in the "Change authentication settings” section.  This means this is how the password is dealt with, not the connection type.  Here is the list that OS X Supports.  These change

    • Digest-MD5
    • Digest (CRAM-MD5)
    • APOP
    • Cleartext (if SSL is enabled)
    • Kerberos (when connected to an Open Directory server)

This page lists all of the methods that dovecot has

http://wiki2.dovecot.org/Authentication/Mechanisms

Here are the descriptions on that webpage that OS X Server is configured to use.

    • Plaintext authentication - see the webpage for a really good discussion about this.
    • CRAM-MD5: Protects the password in transit against eavesdroppers. Somewhat good support in clients.
    • DIGEST-MD5: Somewhat stronger cryptographically than CRAM-MD5, but clients rarely support it.
    • APOP: This is a POP3-specific authentication. Similar to CRAM-MD5, but requires storing password in plaintext.
    • GSSAPI: Kerberos v5 support.

Connection Encryption
-----------

The above authentication methods have nothing to do with the connection, or SSL/TLS, that is an entirely different matter.  [Apple's mail SSL documentation](http://help.apple.com/advancedserveradmin/mac/3.1/#apdC34BB415-E458-4C5D-9B2B-A4A92330C3C6) describes using SSL on OS X Server.

[Dovecot has some SSL documentation](http://wiki2.dovecot.org/SSL) as well, and it is especially useful in describing the difference between SSL, TLS, and STARTTLS.

I also have a section on my [postfix page about SSL/TLS](http://www.magnusviri.com/os-x-server-postfix.html#TLS).  It is especially useful because it talks about what you have to do to get rid of client certificate warnings.

Unencrypted at first (STARTTLS switches it to encrypted):

* SMTP 25/587 - STARTTLS
* IMAP 143 - STARTTLS
* POP 110 - STARTTLS

Encrypted the whole time:

* SMTP 465 - SSL/TLS
* IMAP 993 - SSL/TLS
* POP 995 - SSL/TLS

doveadm
-----------

The doveadm tool is your gateway to all things dovecot.  Dovecot stores email in it's own "home" directories, not system home directories.  That's because dovecot email accounts might not be system accounts.  You do **not** want to manually change anything in those directories because dovecot keeps indexes of everything in there and any changes that dovecot doesn't know about will ruin the indexes.

The doveadm tool allows you to make all the types of changes you'd normally want to, but it makes sure that all of the meta data it keeps stays good.

The first thing to know about the doveadm too is that you have to know how to specify what to work with, either users or mail.  I'll discuss searching next, but I wanted to list what types of things doveadm can do.

* Create/delete/list mailboxes (`doveadm-mailbox`)
* Move messages between mailboxes (`doveadm-move`)
* Show (fetch) message content (`man doveadm-fetch)
* Delete (expunge) messages (`man doveadm-expunge`)
* Delete (purge) messages that are marked as deleted (`man doveadm-purge`)
* View quota (`man doveadm-quota`)
* Search mailboxes or messages, results are id's, not message contents (`man doveadm-search`)

To display information on a user named "matt".

    doveadm user matt

Would print something like this.

    field    value
    uid    214
    gid    6
    home
    mail    maildir:/Library/Server/Mail/Data/mail/8C088880-2DA0-4752-AE11-719BAF76FF87
    quota    maildir:User quota:noenforcing
    quota_rule    *:storage=0
    mail_location    maildir:/Library/Server/Mail/Data/mail/8C088880-2DA0-4752-AE11-719BAF76FF87
    sieve    /Library/Server/Mail/Data/rules/8C088880-2DA0-4752-AE11-719BAF76FF87/dovecot.sieve
    sieve_dir    /Library/Server/Mail/Data/rules/8C088880-2DA0-4752-AE11-719BAF76FF87
    sieve_storage    /Library/Server/Mail/Data/rules/8C088880-2DA0-4752-AE11-719BAF76FF87

/Library/Server/Mail/Data/mail/8C088880-2DA0-4752-AE11-719BAF76FF87 is dovecot's "home" directory for the user.

To specify a users, use -u.

    doveadm quota get -u matt

doveadm mailbox
-----------

To list the mailboxes for a user, use this.

    doveadm mailbox list -u matt

You should see something like this.

    Deleted Items
    Deleted Messages
    Drafts
    Junk E-mail
    Notes
    Sent Items
    Sent Messages
    INBOX

To create a mailbox use this.

    doveadm mailbox create -u matt Junk

Searching with grep
-------------

Maybe you don't want to use doveadm to search, either you don't know how to use doveadm yet, because the index is corrupt, or because you want to search a Time Machine backup.  Here's how you would do that.

This shows you the part of each file that matches.

    grep -r --exclude "dovecot*index*" "text" /Library/Server/Mail/Data/mail/users/matt

This shows the list of files.

    grep -rl --null --exclude "dovecot*index*" "text" /Library/Server/Mail/Data/mail/users/matt | xargs -0 ls -l

This shows the first 15 lines of each message.

    grep -rl --null --exclude "dovecot*index*" "text" /Library/Server/Mail/Data/mail/users/matt | xargs -0 head -n15

This searches Time Machine.

    grep -rl --null --exclude "dovecot*index*" "text" /Volumes/TimeMachine/Backups.backupdb/Your_Server/*/Macintosh\ HD/Library/Server/Mail/Data/mail/users/matt

Do not modify the files you find with grep.  If you change the files you will corrupt the Dovecot indexes.

doveadm search
-----------

Study the [dovecot search documentation](http://wiki2.dovecot.org/Tools/Doveadm/SearchQuery).  And read the man page.

    man doveadm-search-query

Here is a list of available search keys (based on IMAP version 4 revision, RFC 3501, section 6.4.4).

       ALL
       ANSWERED
       BCC pattern
       BEFORE date specification
       BODY pattern
       CC pattern
       DELETED
       DRAFT
       FLAGGED
       FROM pattern
       HEADER field pattern
       KEYWORD keyword
       LARGER size
       MAILBOX name
       MAILBOX-GUID guid
       NEW
       NOT search key
       OLD
       ON date specification
       search key OR search key
       RECENT Matches messages with the IMAP flag \Recent set.
       SEEN   Matches messages with the IMAP flag \Seen set.
       SENTBEFORE date specification
       SENTON date specification
       SENTSINCE date specification
       SINCE date specification
       SMALLER size
       SUBJECT pattern
       TEXT pattern
       TO pattern
       UID sequence
       UNANSWERED
       UNDELETED
       UNDRAFT
       UNFLAGGED
       UNKEYWORD keyword
       UNSEEN Matches messages, which do not have the IMAP flag \Seen set.

Additional dovecot search keys.

       SAVEDBEFORE date specification
       SAVEDON date specification
       SAVEDSINCE date specification

Dovecot has a method of indicating the date, either as day-month-year (e.g. "13-Apr-2007"), an interval (e.g. "1w", "1weeks", "7days"), as a [unix timestamp](http://www.epochconverter.com) (e.g. "1176418800"), or using YYYY-MM-DD (e.g. "2007-04-13").

Dovecot also has a size representation format that can specify octets, bytes, kilobytes, megabytes, gigabytes, or terabytes (e.g. "1M" or "1024k").

Search examples
-------------

Count number of messages in matt's INBOX

    doveadm search -u matt mailbox INBOX all | wc -l

List messages older then 30 days in user matt’s Inbox

    doveadm search -u matt mailbox INBOX savedbefore 30d

It will show a list of message ID's like this.  The first number is the mailbox-guid, the second number is the message uid.

    08fb930926bbb5532bb00000fdd69a3a 5136
    08fb930926bbb5532bb00000fdd69a3a 5143
    08fb930926bbb5532bb00000fdd69a3a 5145

To view one of those messages, specify it's uid.  I'll discuss fetch more later.

    doveadm fetch -u matt body uid 5143

List messages from joe@example.com

    doveadm search -u matt from "joe@example.com"

List messages to joe@example.com

    doveadm search -u matt to "joe@example.com"

List messages with the subject "This is a test"

    doveadm search -u matt subject "This is a test"

List messages that matt has looked at

    doveadm search -u matt -- SEEN

Find a message sent from joe@example.com on November 7th, 2014.

    doveadm search -A from "joe@example.com" senton "2014-11-07"

It's pretty easy to search once you realize you have to specify the user, the key, and the value.  You can include as many search keys as you want for an "and" search.

    doveadm search -u matt mailbox INBOX subject "This is a test"

    doveadm search -u matt mailbox INBOX savedbefore 1d new

Use "or" and "not" as well.

    doveadm search -u matt mailbox INBOX or mailbox Trash

    doveadm search -u matt mailbox INBOX not savedafter 4d

Searching for a message that has some text in the body

    doveadm search -u matt mailbox INBOX BODY phish

Once you know how to search...
-------------

Once you know how to search, then you can work with those messages.  The first task is to actually look at the messages (respect your users' privacy please).

A single message.

    doveadm fetch -u matt "hdr body" uid 5143

All messages in the inbox

    doveadm fetch -u matt hdr mailbox INBOX all | egrep "Date|From|Subject"

All seen messages

    doveadm fetch -u matt -- hdr SEEN | egrep "Date"

I'll discuss the things you can display in a fetch next.

You can also delete (expunge) all messages older then 7 days in matt’s Trash folder.

    doveadm expunge -u matt mailbox Trash savedbefore 7d

Empty matt's INBOX

    doveadm expunge -u matt mailbox INBOX all

What to fetch
-------------

You can fetch many fields in an email message.  They must be in quotes.

This will fetch the body and date received of all messages in the inbox.

    doveadm fetch -u matt "body date.received" mailbox INBOX

Here is a list of fields that can be fetch.

    body   The body of a message.
    date.received
    date.saved
    date.sent
    flags  (A message's IMAP flags.)
    guid   (A message's globally unique identifier.)
    hdr    (The header of the message.)
    imap.body
    imap.bodystructure
    imap.envelope
    mailbox
    mailbox-guid
    pop3.uidl (A message's unique (POP3) identifier within a mailbox.)
    seq    (A message's sequence number in a mailbox.)
    size.physical
    size.virtual
    text   (The header and body.)
    text.utf8
    uid
    user

/usr/local/bin/doveall
-----------

"-A" is suppose to specify all users, but for some reason it doesn't work on my server, and worse, when you try to control-c the command, it takes forever to exit.  I tried to debug it but it was easier to just write a script that I call "doveall".

    #!/usr/bin/perl -w

    my $ignore_users = "^vpn|^diradmin";
    my @commands = qw /altmove backup batch copy deduplicate expunge fetch force-resync import index move purge search sync/;

    my $command = shift @ARGV;
    if ( ! $command or $command eq "" ) {
        print "Missing command\n";
        usage();
    }
    if ( ! grep /^$command$/, @commands ) {
        print "Unknown command: $command\n";
        usage();
    }

    my $user_arg = shift @ARGV;
    if ( ! $user_arg or ( $user_arg ne "-u" and $user_arg ne "-A" ) ) {
        print "-u or -A is required as the second argument, instead I got $user_arg.\n";
        usage();
    }

    my @user_names = ();
    if ( $user_arg eq "-u" ) {
        my $flag = 1;
        while ( $flag ) {
            if ( $#ARGV < 0 ) {
                print "When using -u, a \"--\" is required.\n";
                usage();
            }
            my $arg = shift @ARGV;
            if ( $arg ne "--" ) {
                push @user_names, $arg;
            } else {
                $flag = 0;
            }
        }
    } elsif ( $user_arg eq "-A" ) {
        @records = `dscl /LDAPv3/127.0.0.1 -list /Users`;
        foreach my $record ( @records ) {
            chomp $record;
            if ( $record !~ /$ignore_users/ ) {
                push ( @user_names, $record );
            }
        }
    }

    if ( $#user_names >= 0 ) {
        foreach my $user ( @user_names ) {
            print "doveadm $command -u $user @ARGV\n";
            system "doveadm", $command, "-u", $user, @ARGV;
        }
    } else {
        print "No users specified.\n";
        usage();
    }

    sub usage {
        print "Usage: $0 <command> ( -u user [.. user] -- | -A ) <args>\n";
        print "\tCommands: @commands\n";
        print "\tSee `man doveadm` for a list of valid args\n";
        exit 1;
    }

I use it like this to delete phishing emails.

    doveadm search -u matt -- from phisher@example.com
    doveall search -A from phisher@example.com
    doveall fetch -A body from phisher@example.com
    doveall expunge -A mailbox inbox from phisher@example.com

Or

    doveall fetch -A hdr subject "Important Account Verification" | egrep "dove|Subject|Date"

It also allows me to specify a user list instead of -A, like this.

    doveadm search -u matt joe jack -- from phisher@example.com

/usr/local/bin/dovephish
-----------

I'm getting so much phishing emails lately that it became burdensome to search for them all.  So I wrote a script to help me search and expunge these emails quickly.  It's interactive, so no need to explain how to use it.  It only searches inboxes (since the mailbox-guid returned by `doveadm search` isn't usable with `doveadm expunge`, and I didn't think it was important enough to figure out how to map mailbox-guid's to mailbox names).

    #!/usr/bin/perl -w

    use strict;
    die( "Run me as root.\n"  ) if $> ne 0;

    my @all_users = `dscl /LDAPv3/127.0.0.1 -list /Users`;
    chomp( @all_users );
    @all_users = grep !/^vpn_|^diradmin$|^_ldap_replicator$/, @all_users;

    my @user_list = ();
    my $search_group;
    my $search_by;
    my $search_query;

    if ( 1 ) {
        $search_group = ask_question( 'Search (A)ll users or specify (U)sers? ', '^[AaUu]$' );
        if ( lc($search_group) eq 'u' ) {
            my %all_users_hash = map {$_ => 1} @all_users;
            my %defined_users = ();
            while ( 1 ) {
                my $result = ask_question( 'Specify a user (leave blank to finish): ', '' );
                if ( ! $result ) {
                    if ( $#user_list >= 0 ) {
                        last;
                    } else {
                        print "I need at least 1 user to search.\n";
                    }
                } elsif ( $all_users_hash{$result} ) {
                    if ( ! $defined_users{$result} ) {
                        push @user_list, $result;
                        $defined_users{$result} = 1;
                    } else {
                        print "User already specified.\n";
                    }
                } else {
                    print "Unknown user: $result.\n";
                }
            }
        } else {
            @user_list = @all_users;
        }
        $search_by = ask_question( 'Search (F)rom or (S)ubject? ', '^[FfSs]$' );
        $search_query = ask_question( 'Search query? ', '.' );
    } else {
        # STUB CODE FOR TESTING
        @user_list = @all_users;
        $search_group = 'a';
        $search_by = 'f';
        $search_query = 'bad@example.com';
    }

    my $command;
    my $header = "from" if $search_by eq lc 'f';
    $header = "subject" if $search_by eq lc 's';

    foreach my $user ( @user_list ) {
        print "doveadm search -u $user $header $search_query\n";
        my @results = `doveadm search -u $user mailbox INBOX $header \"$search_query\"`;
        my $result_count = @results;
        print "$result_count results found.\n";

        for my $result ( @results ) {
            chomp $result;
            my ( $mb_guid, $uid ) = split / /, $result;
            print "doveadm fetch -u $user hdr mailbox INBOX uid $uid\n";
            my @full_header = `doveadm fetch -u $user hdr mailbox INBOX uid $uid`;
            my $small_header = join '', grep /^(Return-Path: |Date: |Subject: |From: |To: )/, @full_header;
            print "------------------\n";
            print $small_header;

            my $flag = 1;
            while ( $flag ) {
                my $next = ask_question( 'What now? (N)ext, View full (H)eader, (B)ody, or (Expunge)? ', '^(N|n|H|h|B|b|Expunge)$' );
                if ( $next eq 'Expunge' ) {
                    print "doveadm expunge -u $user mailbox INBOX uid $uid\n";
                    system "doveadm expunge -u $user mailbox INBOX uid $uid";
                    $flag = 0;
                } elsif ( $next eq lc 'n' ) {
                    $flag = 0;
                    next;
                } elsif ( $next eq lc 'b' ) {
                    print "doveadm fetch -u $user body mailbox INBOX uid $uid\n";
                    system "doveadm fetch -u $user body mailbox INBOX uid $uid";
                } elsif ( $next eq lc 'h' ) {
                    print "doveadm fetch -u $user hdr mailbox INBOX uid $uid\n";
                    print @full_header;
                }
            }
        }
    }

    sub ask_question {
        my ( $message, $regex_exit ) = @_;
        while ( 1 ) {
            print "$message";
            my $input;
            chop( $input = <STDIN> );
            if ( defined $input and $input =~ /$regex_exit/ ) {
                return $input;
            }
        }
    }

Sieve and Vacation replies
----

Sieve is this thing that lets you do server side filtering, including vacation replies.  I now have a page dedicated to [Sieve](http://www.magnusviri.com/os-x-server-sieve.html).

Debugging
----

Here's links to debugging documentation.

* [Authentication](http://wiki2.dovecot.org/Debugging/Authentication)
* [Logging](http://wiki2.dovecot.org/Logging)
* [Logging](http://help.apple.com/advancedserveradmin/mac/3.1/#apdD29208D8-0DC5-4A6A-B908-BD12897A39FE)
* [Mac OS X Server: Microsoft Outlook clients may not be able to send mail](http://support.apple.com/kb/TS3023)
* [Configure additional Mail service support for 8-bit MIME](http://help.apple.com/advancedserveradmin/mac/3.1/#apd6D06DB3C-4AD7-49AB-BE65-5B3E9D2DB668)
* [Mail settings you might need from your email provider](http://support.apple.com/kb/HT1277?viewlocale=en_US)
