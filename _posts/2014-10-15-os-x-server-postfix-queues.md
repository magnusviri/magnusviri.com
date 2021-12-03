---
layout:     default
title:      "OS X Server - Postfix Queues"
date:       2014-10-15
editdate:   2020-05-11
categories: MacOSXServer
disqus_id:  os-x-server-postfix-queues.html
render_with_liquid: false
---

[Update 2019-04-13: I no longer run a Mac OS X Server and [Mac OS X Server is dead](https://support.apple.com/en-us/HT208312).]

Since running Postfix, I've had a few incidences where my queues filled and the server basically quit delivering email.  Here's my notes and a little script to help.  I'm a little surprised there isn't something like this out there already but maybe I'm missing something.  Please let me know if that's the case.

Note, this post is part of a series.  Here are the other posts.

* OS X Server - [Basics](http://www.magnusviri.com/os-x-server-basics.html)
* OS X Server - [Managing user accounts](http://www.magnusviri.com/os-x-server-managing-user-accounts.html)
* OS X Server - [Postfix](http://www.magnusviri.com/os-x-server-postfix.html)
* OS X Server - [Dovecot](http://www.magnusviri.com/os-x-server-dovecot.html)
* OS X Server - [Sieve](http://www.magnusviri.com/os-x-server-sieve.html)
* OS X Server - Postfix Queues (this page)

Queues
------

Postfix is likened to an email router.  In this sense it just moves messages from one queue to another.  The best explanation for queues that I could find is in the [Postfix book](http://www.amazon.com/The-Book-Postfix-State-Art/dp/1593270011) or [this website](http://www.porcupine.org/postfix/queueing.html).

I haven't had a need to understand all of the queues, so I'll just explain the ones I've dealt with.

The _active_ queue contains emails that are in line to be dealt with and emails go in and out of this queue fairly quickly, unless there is a problem, of which I've had to deal with twice in 2 years.  If the active queue fills up to 20,000 messages (the default max), the 'qmgr_message_active_limit' setting value), then the _incoming_ queue will fill up.

The _deferred_ queue contains emails that failed to deliver and those will be moved to the active queue after waiting ('queue_run_delay' setting value, mine is 5 minutes).  I've never had to deal with these, but it is important to know.

The _hold_ queue is for the administrator, and so postfix leaves it alone.  I move messages to the hold queue when something is wrong with the active queue.  For example, if the active queue is full of 1000's of messages and it keeps growing I move everything to the hold queue until I can figure it out (like if I'm basically under spam attack, getting the spam out of the active queue allows me to stop spam delivery and selectively move the real messages out of hold into the active queue).

Another reason to know about the hold queue is that you can use content filters (called "checks") to automatically move messages into that queue.  I talk more about content filters in the [earlier postfix post](http://www.magnusviri.com/os-x-server-postfix.html#content_filtering).

I've never seen any messages in any of the other queues (presumably because they move from queue to queue so quickly) so I've never had to deal with them.

Viewing the queues
------------------

View all of the queues:

    mailq

This command will print a list of emails that look like this.

    D62105E96CBD!    5805 Tue Jan 19 17:34:29  sender@mail1.example.com
                                             to@mail2.example.com

The first field is the queue id.  If it has an "*" it means it's in the active queue.  If it has a "!" it means it is in the hold queue.  If it has nothing it means it is in the deferred queue.

The second field is the size of the message.

The third field is the date it was received.

The fourth field is the sender.

The next lines will contain either the deferred message (if it's in the deferred field) or the recipients.

Stop accepting mail but continue to deliver mail in the queue
---------------------------

This will disable the inet services.

    postconf -e "master_service_disable = inet"
    postfix reload

A more invasive version would be to change the underlying sockets (see http://www.postfix.org/postconf.5.html#inet_interfaces).

In main.cf change inet_interfaces to be "inet_interfaces = loopback-only".  Then restart postfix.

    postfix stop
    postfix start

Viewing files in the queues
---------------------------

If you want to view the contents of a file you use `postcat` and give it either the path to the file or the `-q` flag followed by the queue id.  These 2 commands are the same.

    postcat /Library/Server/Mail/Data/spool/deferred/D/D62105E96CBD

    postcat -q D62105E96CBD

That will display everything about the message.  You can also just view the header (`-h`), the envelope (`-e`), or the body (`-b`).

Moving files that are in the queues
-----------------------------------

You can move files from the hold and active queues with these commands.

Move to hold queue.

    sudo postsuper -h D62105E96CBD

Move from hold to active queue.

    sudo postsuper -H D62105E96CBD

You can also delete a file with `-d` (careful with this one).

    sudo postsuper -d D62105E96CBD

If you don't want to specify each queue id you can use a "-" and then enter many message ID's.

    postsuper -d -
    1F2E25E965AA
    1FAE75E965AB
    201DD5E965AC

Or you can use the "ALL" keyword to affect all of them (very careful with this one).  You usually do NOT want to do this unless you're putting everything on hold.

    postsuper -h ALL

You can also use the ALL keyword followed by a queue name (hold, incoming, active and deferred).  This will requeue everything in the deferred queue.

    postsuper -r ALL deferred

Deferred messages
-----------------

I found it interesting that GoDaddy decided to blacklist me once.  I think GoDaddy probably blocks with little provocation.  It's been awhile since this happened to me so I don't remember exactly what I had to do.  I think I had to call them and tell them my server was legit, or submit an email or something.

    host mailstore1.secureserver.net refused to talk to me: 554 ...

Queue directory
---------------

Each message is stored as a file in a directory that represents the queue.  Note, the active queue has a directory and messages in it, but the "real" active queue is in memory.

The queue directory can be found with this command.

    postconf queue_directory

On OS X the queue directory is /Library/Server/Mail/Data/spool.

This is what is on my server.

    active
    bounce
    corrupt
    defer
    deferred
    flush
    hold
    incoming
    maildrop
    pid
    private
    public
    saved
    trace

Some of these directories are not queues (like pid).

The active directory has files coming in and out all the time.  I've never seen files in bounce, corrupt, incoming, or maildrop.  I have no idea what flush is about but I've got an empty file in there named after a second domain my server accepts mail at.

The deferred directory is full of sub directories and the deferred messages (messages that couldn't be delivered) are in there.  The defer directory is not a queue directory but are text files with the explanation of why the message is deferred.

Monitoring queue size
----------

If your active queue reaches 20,000 messages (the default max) you have a problem.  I actually have a problem way sooner than that, so I keep track of the size of my queue with a script that runs every minute or so.  It sends me a text (using textbelt.com) me if it gets too big.  I store it at /usr/local/bin/pf_queue_health.pf.  Be sure to change use your phone number and to change the queuedir_root to /Library/Server/Mail/Data/spool if you're on OS X.

    #!/usr/bin/perl -w

    use strict;

    my $phone_numbers = [
        '1234567890',
    ];

    my $emails = [
        '1234567890@txt.att.net',
        'you@example.com',
    ];

    my $from = 'root@example.com';
    my $queuedir_root = '/var/spool/postfix';
    my $max_queue_length = 40;

    my $text_trigger = "/tmp/text_trigger_pf_queue_health";
    my $text_pause = 12; # hours
    my $queues = [
        'active',
        'incoming',
        'deferred',
        'maildrop',
    ];

    my $message = "";
    foreach my $queue ( @$queues ) {
        my $count = `find "$queuedir_root/$queue" -type f | wc -l`;
        $count =~ s/.*(\w+).*\n/$1/;
        #print "Found $queue: $count\n";
        if ( $count > $max_queue_length ) {
            $message .= "$queue: $count mgs;";
        }
    }

    print "$message\n";

    if ( $message ) {
        my $send_text = 1;
        $send_text = 0 if -e $text_trigger and -M $text_trigger < $text_pause/24;
        if ( $send_text ) {
            system 'touch', $text_trigger;
            foreach my $phone_number ( @$phone_numbers ) {
                system 'curl', 'http://textbelt.com/text', '-d', "number=$phone_number", '-d', "message=$message";
            }
            foreach my $email ( @$emails ) {
                open(SENDMAIL, "|/usr/sbin/sendmail -oi -t") or die "Can't fork for sendmail: $!\n";
                print SENDMAIL << "THE_EOF";
    From: $from
    Subject: $message
    To: $email

    $message
    THE_EOF
                close(SENDMAIL) or warn "sendmail didn't close nicely!";
            }
        }
    } elsif ( -e $text_trigger ) {
        unlink $text_trigger;
    }

And I'm launching it with a launch daemon (/Library/LaunchDaemons/com.magnusviri.pf_queue_health.plist).

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
            <key>Label</key>
            <string>com.magnusviri.pf_queue_health</string>
            <key>ProgramArguments</key>
            <array>
                    <string>/usr/local/bin/pf_queue_health.pl</string>
            </array>
            <key>StartCalendarInterval</key>
            <dict>
                    <key>Minute</key>
                    <integer>10</integer>
            </dict>
            <key>AbandonProcessGroup</key>
            <true/>
    </dict>
    </plist>

Searching the queue
----------

I've found a few commands and scripts for deleting items out of the mail queue, but when my queue got to be 3000 messages and increasing fast, I wrote /usr/local/bin/mailq_search.pl.  It can delete messages but also put on hold or release messages.  It searches by regular expression and by default searches the whole line or can specify from, to, or Subject.  Yeah it's a long script.

    #!/usr/bin/perl -w

    use strict;
    use Getopt::Std;

    ##########################################################################################

    sub usage {
        print <<EOF;
    $0 [-c] [-a|d|h|H|r] [-l|ftS] regexp

        -c run postcat and parse the header (both for message printing or for Subject search).

        By default this script prints matching messages but does nothing to them.  To specify
        an action, use one of the following.

        -a Run commands while reading mailq output (better if the queue is really full).
        -d Delete messages
        -h Put messages on hold
        -H Release message from hold
        -r Re-queue messages

        Matching

        -! Not match, finds everything but what matches
        -l Match against whole line (default)
        -f Match against "from" address (envelope, not header)
        -t Match against "to" address (envelope, not header)
        -S Match against the "Subject" field in header (requires -c)

        Regular expression examples

            bl.*\@yahoo.com
            .
            \.top
            \.download
    EOF
        exit;
    }

    my %options;
    getopts("acdfhHlrSt!",\%options);
    my $operator;
    my $operator_count = 0;
    if ( $options{'h'} ) {
        $operator = "-h";
        $operator_count++;
    } elsif ( $options{'H'} ) {
        $operator = "-H";
        $operator_count++;
    } elsif ( $options{'d'} ) {
        $operator = "-d";
        $operator_count++;
    } elsif ( $options{'r'} ) {
        $operator = "-r";
        $operator_count++;
    }
    die "Only use one of -d -h -H -r.\n" if $operator_count > 1;

    my $active = 0;
    $active = 1 if $options{'a'};

    my $postcat = 0;
    $postcat = 1 if $options{'c'};

    my $search_count = 0;
    my $search; # default
    if ( $options{'f'} ) {
        $search = "f";
        $search_count++;
    } elsif ( $options{'t'} ) {
        $search = "t";
        $search_count++;
    } elsif ( $options{'S'} ) {
        die "-S requires -c\n" if ! $postcat;
        $search = "S";
        $search_count++;
    } elsif ( $options{'l'} ) {
        $search = "l";
        $search_count++;
    } else {
        $search = "l";
        $search_count++;
    }
    die "Only use one of -l -f -t -S.\n" if $search_count > 1;

    my $not = 0;
    $not = 1 if $options{'!'};

    my $REGEXP = shift || usage();

    print "Regular expression: $REGEXP (not: $not)\n";

    ##########################################################################################

    my $queue_id;
    my $bucket = {};
    my $groups = {
        'hold' => {},
        'active' => {},
        '?' => {},
        'matches' => {},
    };
    my $domains = {};
    my $domain_parts = {};
    my $output;
    my $match_count = 0;

    if ( $operator ) {
        print "postsuper $operator -\n";
        $output = 1;
        open( OUTPUT, "|postsuper $operator -" ) || die "Couldn't open postsuper";
    }

    my @data = qx</usr/sbin/postqueue -p>;
    for ( @data ) {
        if ( /^(\w+)(\*|\!)?\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/ ) {
            # Save the data
            $queue_id = $1;
            $bucket = {};
            $bucket->{'queue_id'} = $queue_id;
            $bucket->{'queue'} = $2;
            $bucket->{'size'} = $3;
            $bucket->{'day_of_week'} = $4;
            $bucket->{'month'} = $5;
            $bucket->{'day'} = $6;
            $bucket->{'time'} = $7;
            $bucket->{'envelope_from'} = $8;
            $bucket->{'line'} = $_;
            chomp( $bucket->{'line'} );

            # Parse from
            if ( $bucket->{'envelope_from'} =~ /\@/ ) {
                my $from = $bucket->{'envelope_from'};
                my @from_parts = split /\@/, $from;
                $bucket->{'from_username'} = $from_parts[0];
                $bucket->{'from_server'} = reverse_server($from_parts[1]);
            }

            # File into queue
            if ( ! defined $bucket->{'queue'} ) {
                $groups->{'deferred'}->{$queue_id} = $bucket;
            } elsif ( $bucket->{'queue'} eq '!' ) {
                $groups->{'hold'}->{$queue_id} = $bucket;
            } elsif ( $bucket->{'queue'} eq '*' ) {
                $groups->{'active'}->{$queue_id} = $bucket;
            } else {
                die "Unknown queue.";
            }

            # Look at content
            if ( $postcat ) {
                my @header = qx</usr/sbin/postcat -q -h $queue_id>;
                for ( @header ) {
                    if ( /^Subject:\s(.*)/ ) {
                        $bucket->{'Subject'} = $1;
                        if ( $search eq "S" and check_match( $bucket->{'Subject'}, $REGEXP, $not ) ) {
                            $groups->{'matches'}->{$queue_id} = $bucket;
                            $bucket->{'match'} = 1;
                        }
                    } elsif ( /^From: (.*)/ ) {
                        $bucket->{'envelope_from'} = $1;
                    } elsif ( /^To: (.*)/ ) {
                        $bucket->{'To'} = $1;
                    }
                }
            }

            # Look for match based on envelope_from and the whole line.
            if ( $search eq "f" and check_match( $bucket->{'envelope_from'}, $REGEXP, $not ) ) {
                $groups->{'matches'}->{$queue_id} = $bucket;
                $bucket->{'match'} = 1;
            } elsif ( $search eq "l" and check_match( $_, $REGEXP, $not ) ) {
                $groups->{'matches'}->{$queue_id} = $bucket;
                $bucket->{'match'} = 1;
            }

        } elsif ( $_ ne "\n" ) {
            my $more = $_;
            chomp $more;
            if ( $more =~ /^[^\(](.+)$/ ) {
    #           print "$1\n";
                $bucket->{'to'} = $1;
                if ( $search eq "t" and check_match( $bucket->{'to'}, $REGEXP, $not ) ) {
                    $groups->{'matches'}->{$queue_id} = $bucket;
                    $bucket->{'match'} = 1;
                }
            } else {
                push @{$bucket->{'more'}}, $more if $more ne '';
            }
        } elsif ( $bucket->{'queue_id'} and $bucket->{'match'} ) { # blank line

            if ( defined $bucket->{'from_server'} ) {
                my $temp = "";
                my @server_parts = split /\./, $bucket->{'from_server'};
                for ( @server_parts ) {
                    $temp .= "$_.";
                    $domain_parts->{$temp}++
                }
                push @{$domains->{$bucket->{'from_server'}}}, $bucket;
            } else {
                push @{$domains->{$bucket->{'envelope_from'}}}, $bucket;
            }

            $match_count++;
            if ( $active ) {
                print OUTPUT "$bucket->{'queue_id'}\n" if $output;
                print_message( $bucket );
            } else {
                print ".";
            }
        }
    }

    if ( ! $active ) {
        print "\n";
    }

    for my $domain ( sort {$#{$domains->{$a}} <=> $#{$domains->{$b}}} ( keys %$domains ) ) {
        print reverse_server($domain)."\n";
        my $count = 0;
        for my $bucket ( @{$domains->{$domain}} ) {
            if ( ! $active ) {
                print_message( $bucket );
                print OUTPUT "$bucket->{'queue_id'}\n" if $output;
            }
            $count++;
        }
        print "\tCount: $count\n";
    }


    # print "Parts-----------\n";
    # for my $domain ( sort keys %$domain_parts ) {
    #     chop $domain;
    #     if ( $domains->{$domain} ) {
    #         print "\t$domain\t";
    #         my $count = 0;
    #         for ( @{$domains->{$domain}} ) {
    #             $count++;
    #         }
    #         print "$count\n";
    #     } else {
    #         print "$domain = ".$domain_parts->{"$domain."}."\n";
    #     }
    # }

    print "Matches $match_count\n";

    # if ( ! $active ) {
    #     for ( keys %{$groups->{'matches'}} ) {
    #         my $item = $groups->{'matches'}->{$_};
    #         print_message( $item );
    #     }
    # }

    close ( OUTPUT ) if $output;

    print "Be sure to run `postqueue -f` to flush the queue and get the released emails requeued.\n" if $operator and $operator eq "-H";

    sub check_match {
        my ( $pattern, $regex, $not ) = @_;
        if ( $pattern =~ /$regex/i ) {
            if ( ! $not ) {
                return 1;
            }
        } elsif ( $not ) {
            return 1;
        }
        return 0;
    }

    sub print_message {
        my ( $item ) = @_;
        my $text = "\t";
        $text .= $item->{'queue_id'} if $item->{'queue_id'};
        $text .= "\t";
        $text .= $item->{'queue'} if $item->{'queue'};
        $text .= "\t";
        $text .= $item->{'Subject'} if $item->{'Subject'};
        $text .= "\t";
        $text .= $item->{'To'} if $item->{'To'};
        $text .= "\t";
        $text .= $item->{'to'} if $item->{'to'};
        $text .= "\t";
        $text .= $item->{'From'} if $item->{'From'};
        $text .= "\t";
        $text .= reverse_server($item->{'from_server'}) if $item->{'from_server'};
        $text .= reverse_server($item->{'from'}) if !$item->{'from_server'} and $item->{'from'};
        print "$text\n";
    }

    sub reverse_server {
        return join('.', reverse(split /\./, $_[0]));
    }
