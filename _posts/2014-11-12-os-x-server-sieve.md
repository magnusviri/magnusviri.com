---
layout:     default
title:      OS X Server - Sieve
date:       2014-11-12
editdate:   2020-05-11
categories: MacOSXServer
disqus_id:  os-x-server-sieve.html
render_with_liquid: false
---

[Update 2019-04-13: I no longer run a Mac OS X Server and [Mac OS X Server is dead](https://support.apple.com/en-us/HT208312).]

Dovecot uses Sieve to do server side filtering.  I had this information on the Dovecot page, but it kept growing, so I decided it deserved it's own page.

Note, this post is part of a series.  Here are the other posts.

* OS X Server - [Basics](http://www.magnusviri.com/os-x-server-basics.html)
* OS X Server - [Managing user accounts](http://www.magnusviri.com/os-x-server-managing-user-accounts.html)
* OS X Server - [Postfix](http://www.magnusviri.com/os-x-server-postfix.html)
* OS X Server - [Dovecot](http://www.magnusviri.com/os-x-server-dovecot.html)
* OS X Server - Sieve (this page)
* OS X Server - [Postfix Queues](http://www.magnusviri.com/os-x-server-postfix-queues.html)

Sieve
----

Sieve is this thing that lets you do server side filtering.  It seems to work best with Thunderbird and the 3rd party [sieve add-on](https://github.com/thsmi/sieve/blob/master/nightly/README.md).  I think the "stable" builds don't work, but the nightly build does.

The online documentation for Sieve seems to be rather disorganized.  Every implementation of Sieve might be slightly different.  I couldn't find a comprehensive description of the language, just RFC's and such.

Here is an example sieve script.

    require ["fileinto", "envelope"];
    if anyof ( address :is "from" "yahoo-inc.com",
               address :is "from" "yahoo.com" ) {
      fileinto "yahoo";

    } elsif anyof ( address :is "from" "usatoday.com",
                    address :contains "from" "desnews.com",
                    address :contains "from" "foxnews.com" ) {
      fileinto "News";

    } else {
      # The rest goes into INBOX
      # default is "implicit keep", we do it explicitly here
      keep;
    }

You can also create sieve folders for your users on the server.  They are stored in /Library/Server/Mail/Data/rules/.  Each user will have a folder in there.  You can find out exactly what the directory is for a user by running `doveadm user <name>` and looking for "sieve" or "sieve_dir".  Make the directory if it doesn't exist already.  Place your script in there and run these 2 commands.

    cd <path/to/use/sieve_dir>
    ln your_file.sieve dovecot.sieve
    sievec dovecot.sieve

The server might run the `sievec` command for you, but just in case it wont hurt to run it manually.

Data types
----

Again, this isn't suppose to be comprehensive or a tutorial, these are just my notes.  So this might well not be all of the possible data types, just what I've found.

Comments: `# ...` or `/* ... */`
Identifier: `bla`
Tag: `:bla`
Number: `123` or `1K` or `1M` or `1G`
String: `"bla"`
String list: `["here", "there", "anywhere"]`
Multi-line string:

    text:
    text here
    .

or
    text:-EOT
    .
    EOT

Headers (subset of strings): `From` (headers do not contain colons)
Addresses (subset of strings): `me@example.com` or `Me <me@example.com>`

Commands
----

Basic structure:

    command-name [optional args] <required args>;

Actual commands

    stop; # Stops the script
    keep; # Default command if none have been specified
    discard; # Silently throw away
    fileinto "Spam"; # Moves message into mailbox
    reject "Spam someone else"; # Sends a rejection message with an explaination.
    redirect "johndoe@example.com"; # Redirects the message to the specfied address.

Control Flow
----

    if condition { ... }
    if condition { … } else { … }
    if cond1 { … } elsif cond2 { … } else { … }

Tests
----

Match types

    :is
    :contains
    :matches
    :regex
    :over
    :under
    :value relation
    :count relation

Match wildcards

`*` - zero or more characters (not regex)<br />
`?` - single character

This means you have to use "\\*" and "\\?" in strings if you want those characters.

Valid relations (same as Perl's)

    eq
    ne
    gt
    ge
    lt
    le

Parts of an email address

    :all
    :localpart
    :domain

Comparators

    i;ascii-casemap
    i;octet

Logic

    and
    or

Built-in Tests
----

    not
    false
    true
    allof
    anyof
    address [address-part] [comparator] [match-type] header-names key-list
    envelope [address-part] [comparator] [match-type] envelope-part(string-list) key-list(string-list)
    exists header-names(string-list)
    header [comparator] [match-type] [:mime] header-names(string-list) key-list(string-list)
    size [:over | :under] limit(number)

Note: commands that require string lists can use a

Examples
----

I have not tested these.  Most of them were extracted from other websites.

Throw away anything that doesn't have a "From" and "Date" header.

    if not exists ["From","Date"] { discard; }

Throw away everything from someone you@example.com

    if address :is :all "from" "you@example.com" { discard; }

Throw away everything from example.com

    if address :is :domain "from" "example.com" { discard; }

Throw away everything from someone you@example.com

    require "envelope";
    if envelope :all :is "from" "you@example.com" { discard; }

Throw away messages that don't have "From" and "Date" headers, or if it's from "you@example.com".

    if anyof (not exists ["From", "Date"], header :contains "from" "you@example.edu") { discard; }

Throw away messages from 2 addresses

    if header :contains "from" ["a@example.com","b@example.com"] { discard; }

Throw away message if they are FROM or TO a specific address

    if header :contains ["From", "To"] "a@example.com" { discard; }

Wildcard example

    if envelope :matches "from" "*spammy-???@*" { discard; }

Search the body for certain text

    require "body";
    if body :text :contains ["spammy", "mortgages", "drugs", "phishy"] { discard; }

Move into spam folder

    if anyof (
        not address :all :contains ["To", "Cc", "Bcc"] "me@example.com",
        header :matches "subject" ["*make*money*fast*", "*university*dipl*mas*"])
    {
        fileinto "spam";
    }

Throw away large messages

    if size :over 100K { discard; }

Reject large messages

    if size :over 1M {
        reject text:
    Please do not send me large attachments.
    Put your file on a server and send me the URL.
    Thank you.
    .... Fred
    .
    ;
        stop;
    }

Other commands
----

    #inclue "filename"

    require string;
    require string-list;

Vacation replies
----

Vacation out-of-office auto-replies can be implemented using Sieve.  Here is a example script.

    require ["fileinto", "vacation"];
    # Move spam to spam folder
    if header :contains "X-Spam-Flag" "YES" {
      fileinto "spam";
      # Stop here so that we do not reply on spams
      stop;
    }
    vacation
      # Reply at most once a day to a same sender
      :days 1
      :subject "Out of office reply"
      # List of additional recipient addresses which are included in the auto replying.
      # If a mail's recipient is not the envelope recipient and it's not on this list,
      # no vacation reply is sent for it.
      :addresses ["j.doe@company.dom", "john.doe@company.dom"]
    "I'm out of office, please contact Joan Doe instead.
    Best regards
    John Doe";

[Vacation auto-reply docs](http://wiki2.dovecot.org/Pigeonhole/Sieve/Examples#Vacation_auto-reply)


More info
----

More can be found out about sieve at these sites.

* [wiki2.dovecot.org/Pigeonhole/ManageSieve](http://wiki2.dovecot.org/Pigeonhole/ManageSieve)
* [sieve.info](http://sieve.info)
* [mailutils.org/manual/html_chapter/Sieve-Language.html](http://mailutils.org/manual/html_chapter/Sieve-Language.html)
* [www.faqs.org/rfcs/rfc3028.html](http://www.faqs.org/rfcs/rfc3028.html)
