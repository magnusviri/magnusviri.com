---
layout:     default
title:      Using heredocs in Apple Remote Desktop to run Perl/Python/Ruby code
date:       2014-04-18
editdate:   2020-05-11
categories: MacAdmin
disqus_id:  using-heredocs-in-apple-remote-desktop-to-run-perlpythonruby-code.html
render_with_liquid: false
---

#### The Send UNIX Command in Apple Remote Desktop

Apple Remote Desktop (ARD) is pretty cool.  It has this Send UNIX Command ability that lets me send some BASH code to any number of machines.  The only thing that I've come across that is as nice as this is [Ansible](http://ansible.com).

I do have one gripe about ARD.  The Send UNIX Command defaults to BASH on the clients and I don't believe that can be changed.  I prefer to code in Perl so I finally figured out how to run Perl.

First, here is a little bit about the environment I when running these commands as root.

    echo $0
    pwd
    echo $HOME
    whoami

I get this.

    /bin/bash
    /
    /var/root
    root

#### Here document

A Heredoc is code that appears in a script and is treated as if it were a separate file.  You can find out a lot more by reading [Wikipedia's here document page](https://en.wikipedia.org/wiki/Here_document).

In BASH the syntax looks like this (this doesn't actually do anything and will generate an error because some_command isn't real).

    # line 1
    # line 2
    some_command << EOF
    # separate file line 1
    # separate file line 2
    EOF
    # line 7

Everything between "&lt;&lt; EOF" and "EOF" is treated as a different file (or a single string) and it's sent to some_command.  The "EOF" can be any text and is used to mark the end of the heredoc.  Here's another example and this one actually works.

    cat << END_OF_FILE
    line 1
    line 2
    END_OF_FILE

This works because `cat` expects a file.  If I had used `echo` instead of `cat` it wouldn't have worked because `echo` prints the arguments sent to it, not a file where `cat` prints a file.  This is important because when the `perl` command expects a file to execute and `perl -e` executes the first argument.  So I can't use -e (when I first tried doing this I kept using -e and it never worked... duh).

Here is a simple BASH script that executes a `perl` script and gives it some code that prints "12".  I can send this in ARD and it works.

    perl << EOF
    for ( 1..2 ) {
        print;
    }
    EOF

#### Escaping heredocs

So the thing that sucks is that this is still a BASH script, and as such BASH is treating this text as a string and so any occurrence of $ is treated as a variable.  So this code will not work.

    perl << EOF
    $var = 1;  # BROKE!
    EOF

It needs to be escaped like this.

    perl << EOF
    \$var = 1;  # Works
    EOF

Using back ticks similarly doesn't work unless I escape them.  Yes, this sucks.

    perl << EOF
    \$var = \`hostname\`
    EOF

#### ARD Heredoc running Perl

Here is a more complex heredoc and gets me closer to what I want to do (different actions based on the hostname).

    perl << EOF
    use Sys::Hostname;
    my \$hostname = hostname;
    for ( \$hostname ) {
        /^radmind-1/ && do {
            print "Hi I'm 1";
            last;
        };
        /^radmind-2/ && do {
            print "Hi I'm 2";
            last;
        };
        /^radmind-3/ && do {
            print "Hi I'm 3";
            last;
        };
        do {
            print "Hi I'm \$hostname";
        };
    }
    EOF

#### ARD Heredoc running Python

It's also possible to run Ruby or Python code this way.  Here's a Python example.  Because Python doesn't use $'s for variables this is clearly the cleanest because there aren't any escape slashes.  However, Python doesn't have a switch statement so I'm using elif's.

    python << EOF
    import socket
    hostname = socket.gethostname()
    if hostname[:9] == "radmind-1":
        print "hi I'm 1"
    elif hostname[:9] == "radmind-2":
        print "hi I'm 2"
    elif hostname[:9] == "radmind-3":
        print "hi I'm 3"
    else:
        print "I'm " + hostname
    EOF

#### ARD Heredoc running Ruby

Here's a Ruby example

    ruby << EOF
    require "socket"
    \$hostname = Socket.gethostname
    case \$hostname
    when /^radmind-1/
      puts "Hi I'm 1"
    when /^radmind-2/
      puts "Hi I'm 1"
    when /^radmind-3/
      puts "Hi I'm 3"
    else
      puts "I'm " + \$hostname
    end
    EOF

#### Conclusion

Welp, that's how to use heredocs in ARD.  I'm so much more fluent in Perl then BASH so it was worth it to me.  But the unbelievable irony here is that the problem I was trying to solve turned out to be actually easier in BASH.  I didn't realize this until after I started coding the Perl version.  Here's the final BASH script I wrote (which probably means nothing to you but oh well).

    cd /Volumes/rserver/var/radmind/cert/
    hostname=`hostname -s`
    ln -s $hostname.pem link.pem
    ls -l

Sigh.
