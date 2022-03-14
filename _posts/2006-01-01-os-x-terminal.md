---
layout:     default
title:      OS X Terminal
date:       2008-01-01
editdate:   2020-05-11
categories: MacAdmin Terminal
disqus_id:  os-x-terminal.html
---

Some time between 2003 and 2008 I wrote this.  It's a through discussion of the Terminal and UNIX commands.  It was targeted at Mac OS X 10.4.  Most of it is still applicable.  I am trying to reorganize it and update it.

<a name="before_the_GUI"></a>
#### Before the GUI, there was the terminal

This page assumes you don't have much knowledge of the Terminal but it jumps right in with in-depth information, like why you might want to use `sudo rm -- -r /` instead of just `sudo rm -r /`, or what happens when you create a file in the Finder with `/` in the name, what `{,}` does in the shell, the difference between `ditto` and `cp -R`, why `vsdbutil -d` is evil, etc. So I hope it offers something to the newbie and an experienced user.

<a name="what_and_why"></a>
#### What and why

"Command line", "command line interface", "terminal", and "shell" are words that describe a text user interface. You interface with the computer by typing text messages on a keyboard. The computer displays text messages back at you.

Why would you want to learn how to use the terminal?

<ul>
  <li>It was written by programmers for programmers, giving them the ability to do very powerful things.</li>
  <li>I've heard with each OS X update people moaning about getting a new Finder because the current one sucks so bad. Well, the Terminal can do everything Finder can, and faster too!</li>
  <li>If you want to remotely control a computer, ssh access is a very low bandwidth method, and it allows multiple permission levels (unlike VNC) so many users can all remotely access a computer.</li>
  <li>Debugging a computer is sometimes easier with 2 computers, one ssh'ed into the other.</li>
  <li>Shell scripting is very powerful and uses the same commands that the Terminal uses, so you don't need to learn a new way to talk about things (well, once you learn the terminal way to talk about things).</li>
  <li>If your computer wont boot, often it will boot to single user mode, allowing you to look at logs and also allowing you to try to fix it.</li>
</ul>

For all of these reasons, I'm going to discuss Terminal from the standpoint that we are going to replace the Finder. It can be used as a references, but each section builds on what comes before. While most of this applies to many Unix systems this page is Mac OS X centric. Some commands are only available on Mac OS X.

<a name="where_is_terminal"></a>
#### Where is Terminal?

You can get a Terminal many ways. Probably the most obvious is to open /Applications/Utilities/Terminal.app. If you have X11 installed, open the X11 app and it will open an xterm, which behaves a bit differently than Terminal.app. You can also download several 3rd party terminal applications like <a href="http://iterm.sourceforge.net/">iTerm</a>.

Or you can go hardcore and type "&gt;console" at the login prompt instead of your normal username and password (you might have to click the "Other" button if you are using a list of users at loginwindow). You wont be able to launch GUI applications.

Although you probably rarely want to do this (unless you are a system administrator), you can boot to single user mode by holding command-s right after the startup chime. Once the pinwheel appears, it is too late and it has gone to multi user. You will need to restart and try again. If it keeps not working, try holding down option at startup. Does it ask for a password? If it does, you will need to turn Open Firmware password off (Google is your friend).

I'm going to assume you are using Terminal.app.

<a name="new_window"></a>
#### New window

Finder can have many windows open at once, Terminal can too. Open a new Terminal shell with command-n. This is equivelent to the new Finder window command (and is the same keyboard short cut even).

<a name="find_out_where_you_are"></a>
#### Find out where you are

Just like a Finder window always is located in some folder, the Terminal is always at some folder as well. When opening a new Terminal window, it will most likely be located in your home directory (aka `$HOME`, or `~/`).

If you are unsure where you are, you can type `pwd`. This is equivalent to command clicking a Finder window titlebar, only the pwd version can be copied.

Example:

<pre><code>  [Computer:/Library] james% pwd
  /Library
</code></pre>

Notice that my prompt actually tells me where I am.

<pre><code>  [Computer:*/Library*]</code></pre>

It will not always tell you the full path though, so pwd is still needed.

<a name="look_at_a_file"></a>
#### Look at a file

To print out an entire file:

<pre><code>  cat &lt;filename&gt;</code></pre>

To view a file page by page:

<pre><code>  less &lt;filename&gt;</code></pre>

or

<pre><code>  more &lt;filename&gt;</code></pre>

("less is more")

<a name="create_an_empty_file"></a>
#### Create an empty file

To create an empty file:

<pre><code>  touch &lt;newfilename&gt;</code></pre>

Finder can't create files.

The file system keeps track of when files were last changed. If you use touch on a file that already exists, the file contents will not be changed, but the modification date will change the current time (thus, it was "touched" but not changed).

<a name="erase_contents_of_file"></a>
#### Erase the contents of a file (piping)

To erase (or create a new file).

<pre><code>  echo -n &gt; &lt;filename&gt;</code></pre>

To erase a file and put some text in it.

<pre><code>  echo "Your text here" &gt; &lt;filename&gt;</code></pre>

To append a line to the end of a file:

<pre><code>  echo "Your text here" &gt;&gt; &lt;filename&gt;</code></pre>

Notice the difference is two `>>`. Be careful with this because the last thing you want to do is accidentally erase a file by only putting one `>` (I've done it).

<a name="argument_parameters"></a>
#### Arguments/parameters

Commands take options and other arguments and parameters. For example, touch takes the name of the file to create. The name of the file is an argument or parameter.

Unix commands can be given options telling it to do something different. Those are also arguments and parameters. For example, `touch -c <filename>` will do something different than the default behavior. When a parameter is an option, like `-c`, it is also called a flag or a switch.

Sometimes multiple flags can be combined (in any order usually), like this:

<pre><code>  pwd -PL</code></pre>

Or they can be specified individually:

<pre><code>  pwd -P -L</code></pre>

Some options use two dashes `--option-name`. Two dashes alone `--` (no letters after it) indicates there are no more flags. This is so that you can to do something to a file that begins with `-`. For example:

<pre><code>  [Computer:~/] james% touch -c
  usage: touch [-acfm] [-r file] [-t [[CC]YY]MMDDhhmm[.SS]] file ...</code></pre>

Oops, it didn't work but instead told me how I'm suppose to use the command. However, this works:

<pre><code>  touch -- -c</code></pre>

This creates a file named `-c`.

<a name="looking_at_contents_of_folder"></a>
#### Looking at the contents of a folder

Naturally the Finder always shows files and folder and gives you information about them and even allows you to "Get Info" so you can see more details and make some changes. You can get the same lists and, in fact, more information than the Finder shows. Use `ls` (list) for the basic list. Here are some of the different options:

Shows a quick directory list:

<pre><code>  ls</code></pre>

Show a quick list, only one item per line:

<pre><code>  ls -1</code></pre>

Show detailed list:

<pre><code>  ls -l</code></pre>

Show all files including hidden ones:

<pre><code>  ls -Al</code></pre>

Sort the listing by size (largest first):

<pre><code>  ls -S</code></pre>

Sort by time, reverse order (newest last):

<pre><code>  ls -tr</code></pre>

Look at the contents all of the sub-directories (recursive):

<pre><code>  ls -R</code></pre>

Show the locked state of a file (an extra column is shown):

<pre><code>  ls -ol</code></pre>

Show the contents of :

<pre><code>  ls -l &lt;dirname&gt;</code></pre>

Show but not the contents:

<pre><code>  ls -dl &lt;dirname&gt;</code></pre>

How do you read the output of `ls -l`?

<pre><code>  drwx------   37 james  james    1258 Oct  7 23:01 Desktop
  -rw-r--r--    1 root   james   17920 Oct  1 09:55 Desktop DB
  -rw-r--r--    1 root   james  113090 Oct  1 21:28 Desktop DF
  drwx------    9 james  james     306 Jul 15 22:05 Documents
  drwx------   53 james  james    1802 Jun 21 17:38 Library
  drwx------   50 james  james    1700 Sep 30 12:44 Movies
  drwx------   20 james  james     680 Jul  9 20:22 Music
  drwx------   25 james  james     850 Sep 10 22:52 Pictures
  drwxr-xr-x    6 james  james     204 Oct  8 15:49 Sites
</code></pre>

The first character is the type of file/folder. - d Directory. - l Symbolic link. - - Regular file.

The next nine characters `rwx------` are the permissions.

The first 3 characters are the "owner" or "user" permissions, the next 3 are the group permissions, the last 3 are permissions for anyone who has access to the computer if it has multiple accounts ("other" or "world").

<ul>
  <li>r means read access</li>
  <li>w means write access</li>
  <li>x means execute if file, search if folder</li>
</ul>

See `chmod` below for more info on permissions.

The next number tells you how many files are in a folder (including . and .. or any other hidden files) or the number of hard links a file has (don't worry about what that is, by default it will almost always be one).

Next is the user that owns the file. Then you get the group of the file. Then the filesize in bytes. Then you get the last modification date and time. Then you finally get the filename. If the file is a symbolic link (similar to a Finder alias), there will be an arrow showing what file the link points to (try running `ls -l /` to see some links).

<a name="more_options_available"></a>
#### More options available

To find out what a flag does, or to find out what other flags there are, use `man <commandname>`. For example:

<pre><code>  man ls</code></pre>

For more information on man, see the next tutorial on finding out everything about commands.

<a name="folder_separator_character"></a>
#### Folder separator character

The forward slash "/" is the folder separator character. No file or folder name can have this character in it. If you create a filename with this character in the Finder, it will let you. But if you look at it from the command line the "/" will be converted to ":".

Example:

<pre><code>  drwxr-xr-x    2 james  james     68 Oct  7 00:02 adsf:adsf</code></pre>

(In the Finder it appears as "asdf/asdf")

Note, in the Finder, ":" is the folder separation character. You can't create a file with that character in the Finder. But you can in Terminal. If you do, the Finder will display the ":" as a "/". Ok.

<a name="root_of_boot_disk"></a>
#### / = root of boot disk

So, look at the root of the hard disk:

<pre><code>  [Computer:~] james% ls /
  Applications
  Desktop DB
  Desktop DF
  Developer
  Icon?
  Library
  Network
  System
  TheVolumeSettingsFolder
  Users
  Volumes
  automount
  bin
  cores
  dev
  etc
  mach
  mach.sym
  mach_kernel
  private
  sbin
  tmp
  usr
  var
</code></pre>

Surprised? Where did all those things come from? This is what is at the root of your hard disk! The Finder only shows these though:

Applications, Developer, Library, System, Users

That is because it is <strong>protecting</strong> you from all of that Unix stuff and `ls` doesn't.

<a name="hidden_files"></a>
#### Hidden files

If a file begins with a period "." (like ".DS_Store") it is invisible in the Finder and with `ls`. `ls -A` (or `ls -a`) is how you view all of the invisible stuff. The Finder will never show you invisible items. Also, the root directory, "/", contains hidden files that are not visible by the Finder but don't begin with ".". The Finder looks at the file "/.hidden" (if it exists) and hides everything listed in the file. Finder also has meta file information that can hide a file that doesn't begin with a dot. You can view this meta information with something like GetFileInfo.

<pre><code>  [Computer:/Library] james% /Developer/Tools/GetFileInfo /private
  directory: "/private"
  attributes: aVbstclinmedz
  created: 04/17/2006 23:27:37
  modified: 10/02/2006 20:59:54
</code></pre>

Notice the V in the attributes line. Capital means it is invisible. (Type "man GetFileInfo" for more information-you must have the developer tools installed.)

To make a file invisible the Unix way just use a period as the first character in the name. Note, the Finder will not let you do this.

To make a file or folder invisible to the Finder, use SetFile.

<pre><code>  [Computer:~] james% /Developer/Tools/GetFileInfo /Users/james/Desktop
  directory: "/Users/james/Desktop"
  attributes: avbstclinmedz
  created: 09/13/2006 09:59:23
  modified: 10/07/2006 14:57:12
  [Computer:~] james% /Developer/Tools/SetFile -a V /Users/james/Desktop
  [Computer:~] james% /Developer/Tools/GetFileInfo /Users/james/Desktop
  directory: "/Users/james/Desktop"
  attributes: aVbstclinmedz
  created: 09/13/2006 09:59:23
  modified: 10/07/2006 14:57:12
</code></pre>

To make it visible, use a lowercase "v".

<pre><code>  [Computer:~] james% /Developer/Tools/SetFile -a v /Users/james/Desktop</code></pre>

<a name="absolute_paths"></a>
#### Absolute paths

An absolute path BEGINS with "/". It specifies the location of a file or folder starting with the root of the hard disk and descending folders. So /Users/mac starts at the root of the hard disk and descends into the "Users" folder and then the "mac" folder.

You don't need to be IN a folder to look at it or do anything in it. This makes Terminal more powerful than Finder, because in the Finder you always have to be in a folder to do anything in it.

For example, my prompt shows I'm in the /Library folder, and I can view other folders without moving to them:

<pre><code>  [Computer:/Library] james% ls /Users
  Shared  james   matt

  [Computer:/Library] james% ls -1 /Applications
  Address Book.app
  AppleScript
  Automator.app
  ...
  iPhoto.app
  iSync.app
  iTunes.app
  iWeb.app
  iWork '06
</code></pre>

<a name="volumes_vs_slash"></a>
#### /Volumes vs /

Why are servers and extra hard disks and media located in /Volumes but the root of the hard disk is at /? Does this mean they are copied to the boot hard disk? Not at all. A Unix file system is actually not an exact representation of the boot hard disk, like you would think. Rather, it is a "file system", meaning all files (and some things that AREN'T files) are accessible from the file system.

To do that, the OS has to "put" everything somewhere. Long ago it was decided that the boot hard disk was the root of the file system, or "/". All other hard disks have to be "mounted" somewhere in that file system (see below for instructions how to do that). Apple decided to mount them in /Volumes. Other Unixes put them in different places and is configurable.

This isn't the only goofy Unixy thing you will encounter either. The contents of the /dev directory are not files or folders either, but I'll just say they are "special" things that need to be accessible in the "file system". You don't want to try to edit them with a text editor.

<a name="moving_around"></a>
#### Moving around

Just like in the Finder where you can move around the folder hierarchy, you can do the same in Terminal using the cd (change directory) command. Note, in Finder you have folders. In Unix you have directories. They are the same thing. However, you earn geek points by using the word directory (it has more syllables).

Go to (valid paths will be discussed below):

<pre><code>  cd &lt;path&gt;</code></pre>

Go to your home folder:

<pre><code>  cd</code></pre>

Go to the parent directory (in Finder do this by pressing command-up arrow):

<pre><code>  cd ..</code></pre>

Toggle to the last location (in Finder click the back and forward button at the top of the window):

<pre><code>  cd -</code></pre>

You can also use `pushd` and `popd` if you plan on toggling around a lot. It was fun when I first used it, but then I realized trying to figure out where I would go the next time I typed popd took longer than just typing `cd <path>`.

<pre><code>  [Computer:~] james% pushd /
  / ~
  [Computer:/] james% pushd Library/
  /Library / ~
  [Computer:/Library] james% pushd /Applications/
  /Applications /Library / ~
  [Computer:/Applications] james% popd
  /Library / ~
  [Computer:/Library] james% popd
  / ~
  [Computer:/] james% popd
  ~
  [Computer:~] james%
</code></pre>

You don't have to `cd` to a folder every time you want to look at it. When I watch new people, they `cd` to a folder then immediately `ls`, then `cd` to another folder inside it, then `ls` again, the `cd` again, etc. If you know the name of the path, just type the full path (or use tab completion-see below). If you don't know exact paths, and if the folders aren't full of tons of files, you can `ls -R` to see everything inside of where you are going. Then you can write one `cd`.

Another little Mac OS X trick that I use often is to type `open .` (see below for more info). This will open the current directory in the Finder. Then I switch to the Finder column view navigation (command-3 to get that view). Then I use the arrow keys to find what I want. I grab the mouse and drag the location of that window back into the terminal. Click in the Terminal to bring it forwards. Then I press `ctrl-a` (see below again) to go to the beginning of the line, then I type <code>cd</code>. Kinda tricky, but with practice, it is very quick (much quicker than <code>cd ... ; ls ; cd ... ; ls ; cd ...</code>).

<a name="multiple_arguments"></a>
#### Multiple arguments

Some commands, like <code>cd</code>, only takes one argument. However, others, like <code>ls</code>, can take as many as you want. For example:

<pre><code>  [Computer:/Library] james% ls -1 /Users/ /Applications/
  /Applications/:
  Address Book.app
  AppleScript
  Automator.app
  ...
  iPhoto.app
  iSync.app
  iTunes.app
  iWeb.app
  iWork '06

  /Users/:
  Shared
  james
  matt
</code></pre>

Most commands will take many arguments and do the action on all of them.

<a name="relative_paths"></a>
#### Relative paths

A relative path can begin with either a name of a file or folder like "Library", "./", "../", or "~/".

Examples:

The folder named "Library" in the current working directory:

<pre><code>  Library</code></pre>

The current directory:

<pre><code>  .</code></pre>

or

<pre><code>  ./</code></pre>

Parent directory:

<pre><code>  ..</code></pre>

or

<pre><code>  ../</code></pre>

Your home folder:

<pre><code>  ~/</code></pre>

More examples of valid (but maybe a bit odd) relative paths (the first <code>cd .</code> goes to the current directory, basically it doesn't move):

<pre><code>  [Computer:~] james% cd .
  [Computer:~] james% cd ..
  [Computer:/Users] james% cd ../Library/
  [Computer:/Library] james% cd ../
  [Computer:/] james% cd Library/
  [Computer:/Library] james% cd ../Library/
  [Computer:/Library] james% cd ../Library/./.././Library/
  [Computer:/Library] james% cd ~
  [Computer:~] james% pwd
  /Users/james
</code></pre>

Kinda odd that I'm going in and out of the Library folder, but it is all ok and works.

<a name="tab_completion"></a>
#### Tab completion

This needs to be set up

That is a cool shell feature. The way it works is that you type part of a path and then you type the TAB key and the shell tries to figure out what file or folder you want and it fills it in if it can figure it out. For example, if you type "~/M" and press TAB, you have two options "~/Movies" or "~/Music". Because there are 2 options, the shell doesn't know what you want, and it wont complete it but will instead beep at you. Some shells will actually print out the options:

<pre><code>  [Computer:~] mac% cd ~/M
  Movies/ Music/
  [Computer:~] mac% cd ~/M
</code></pre>

To give the shell a better chance of figuring out what I really want, I type one more character, the "o". Then I hit TAB and the shell automatically fills in the rest:

<pre><code>  [Computer:~] mac% cd ~/Movies/</code></pre>

Sometimes, if tab completion doesn't work, it means you have a misspelling in your path.

Tab completion works with commands too:

<pre><code>  system_&lt;tab&gt;</code></pre>

becomes

<pre><code>  system_profiler</code></pre>

<a name="spaces_in_paths"></a>
#### Spaces in paths (kinda like "Pigs in Space", ok, maybe not)

Old Unix didn't use spaces in paths because spaces means "something new" on the command line. So "/Library/Application Support" is 2 things in Unix: "/Library/Application" and "Support".

Mac OS 9 and below used spaces as if they were saying to all the Unix and DOS people: "Hahaha! We got em and you don't!". But now we have OS X, and now we are cursed with all those old legacy spaces.

Sp to use spaces on the command line, you have two options. You either put quotes around the path or you "escape" the spaces by placing a backslash in front of it, like this: " ". Ok, this really shows that Unix did allow spaces, it just wasn't the norm. These options are the same:

<pre><code>  cd "/Library/Application Support"
  cd /Library/Application\ Support
</code></pre>

Tab completion will really help out here. It will automatically escape your spaces. And if it doesn't tab complete, there is a good chance you typed in the path wrong anyway.

<a name="case_insensitive_but_case_preserving"></a>
#### Case insensitive but case preserving

This is a attribute of the HFS+ file system, which is like rude jelly.

Technically, in HFS+, /etc is the same as /ETC. So both of these will work:

<pre><code>  ls /etc/
  ls /ETC/
</code></pre>

However, tab competition is case sensitive, so if get the case wrong, it wont complete for you.

Does nothing (but beep):

<pre><code>  ls /E&lt;tab&gt;</code></pre>

Works:

<pre><code>  ls /e&lt;tab&gt;</code></pre>

<a name="comma_wildcard"></a>
#### {,} Wildcard

Wildcards are like jokers, they represent things that they aren't. The {,} wildcard allows you to select multiple options, each separated by a comma. In this example, the <code>ls</code> command lists both Movies and Music:

<pre><code>  [Computer:~] james% ls -dl ~/M{ovies,usic}
  drwx------   50 james  james  1700 Sep 30 12:44 /Users/james/Movies
  drwx------   20 james  james   680 Jul  9 20:22 /Users/james/Music
</code></pre>

In this example, the <code>ls</code> command lists /mach, /mach.sym, and /mach<em>kernel. Each is separated by a command, first "" (blank), then ".sym", then "</em>kernel":

<pre><code>  [Computer:~] james% ls -l /mach{,.sym,_kernel}
  lrwxr-xr-x   1 root  admin  9 Oct  2 20:59 /mach -&gt; /mach.sym
  -r--r--r--   1 root  admin   615480 Oct  2 20:59 /mach.sym
  -rw-r--r--   1 root  wheel  8545336 Sep 27 02:13 /mach_kernel
</code></pre>

See below for more examples.

<a name="asterisk_wildcard"></a>
#### * Wildcard

The wildcard I use most is <code>*</code>.

Everything:

<pre><code>  *</code></pre>

Everything in <code>/</code>:

<pre><code>  /*</code></pre>

Everything in <code>/</code> that begins with "a" (including "a"):

<pre><code>  /a*</code></pre>

Everything in <code>/</code> that ends with "a" (including "a"):

<pre><code>  /*a</code></pre>

Everything in <code>/</code> that begins and ends with "a" (including "aa"):

<pre><code>  /a*a</code></pre>
Everything in <code>/</code> that has an "a" in it (including "a"):

<pre><code>  /*a*</code></pre>

The only exception to "everything" is dot files. To select files that begin with ".", you have to specify the dot:

Everything hidden in <code>/</code>:

<pre><code>  /.*</code></pre>

Everything hidden in <code>/</code> that begins with "a" (including "a"):

<pre><code>  /.a*</code></pre>

Everything hidden in <code>/</code> that ends with "a" (including "a"):

<pre><code>  /.*a</code></pre>

Everything hidden in <code>/</code> that begins and ends with "a" (including "aa"):

<pre><code>  /.a*a</code></pre>

Everything hidden in <code>/</code> that has an "a" in it (including "a"):

<pre><code>  /.*a*</code></pre>

If you want to select both at the same time, use {,} with *:

<pre><code>  ls -l {,.}*</code></pre>

A more realistic example:

<pre><code>  ls thumb*.jpg</code></pre>

You can also use it in paths. For example:

<pre><code>  [Computer:~/] james% ls -l /Library/*/Apple
  total 0
  drwxrwxr-x    3 root  admin  102 Jan 13  2006 Automator
  drwxrwxr-x    7 root  admin  238 Jan 14  2006 Chinese Input Method Plugin Samples
  drwxrwxr-x   13 root  admin  442 Aug  1 11:58 Developer Tools
  drwxrwxr-x    3 root  admin  102 Jan 14  2006 Grapher
  drwxrwxr-x    5 root  admin  170 Oct  4 16:55 Remote Desktop
  drwxrwxr-x    4 root  admin  136 Aug  1 18:02 System Image Utility
  drwxrwxr-x   11 root  admin  374 Aug 17 21:08 iChat Icons
</code></pre>

What folder am I looking at though? I don't know. Here is how I find out:

<pre><code>  [Computer:~/] james% ls -ld /Library/*/Apple
  drwxrwxr-x   9 root  admin  306 Oct  4 16:55 /Library/Application Support/Apple
</code></pre>

What if there were multiple folders found.

<pre><code>  [Computer:~/] james% mkdir /Library/Preferences/Apple
  [Computer:~/] james% touch /Library/Preferences/Apple/hahaha
  [Computer:~/] james% ls -l /Library/*/Apple
  /Library/Application Support/Apple:
  total 0
  drwxrwxr-x    3 root  admin  102 Jan 13  2006 Automator
  drwxrwxr-x    7 root  admin  238 Jan 14  2006 Chinese Input Method Plugin Samples
  drwxrwxr-x   13 root  admin  442 Aug  1 11:58 Developer Tools
  drwxrwxr-x    3 root  admin  102 Jan 14  2006 Grapher
  drwxrwxr-x    5 root  admin  170 Oct  4 16:55 Remote Desktop
  drwxrwxr-x    4 root  admin  136 Aug  1 18:02 System Image Utility
  drwxrwxr-x   11 root  admin  374 Aug 17 21:08 iChat Icons

  /Library/Preferences/Apple:
  total 0
  -rw-r--r--   1 james  admin  0 Oct  7 00:36 hahaha
</code></pre>

Well, it tells me what the folders are. The above command is the same as just giving ls 2 paths (really, that is exactly what the shell does, it gives the command the 2 paths, the command doesn't ever see the wildcard):

<pre><code>  ls "/Library/Application Support/Apple" "/Library/Preferences/Apple"</code></pre>

What if I try to <code>cd</code> to that?

<pre><code>  [Computer:~/] james% cd /Library/*/Apple
  tcsh: /Library/*/Apple: Ambiguous.
</code></pre>

Oops, it wont let me. This is because <code>cd</code> only takes on argument.

Tab completion doesn't work with wildcards.

<a name="root"></a>
#### Root

Do something as root (sudo will ask for password)

<pre><code>  sudo ...</code></pre>

Become root user

<pre><code>  sudo -s</code></pre>

<code>sudo</code> means super user do. Don't mix this up with <code>su</code>, which means substitute user.

If you have set a root password (by default Mac OS X does not have one set), then you can also do this:

<pre><code>  su root</code></pre>

When you are root, you can freely <code>su</code> to other user accounts.

To leave root, type <code>exit</code>.

<a name="moving_files_folders"></a>
#### Moving files/folders

Move a file:

<pre><code>  mv &lt;filename&gt; &lt;newlocation&gt;</code></pre>

<code>&lt;newlocation&gt;</code> must be a folder that exists already, mv will not create folders for you.

Move several files:

<pre><code>  mv &lt;filename1&gt; &lt;filename2&gt; &lt;newlocation&gt;</code></pre>

<a name="renaming_files_folders"></a>
#### Renaming files/folder

The rename command is exactly the same as the move command. The idea is that you are "moving it from one name to another".

<pre><code>  mv &lt;oldfilename&gt; &lt;newfilename&gt;</code></pre>

Or using the {,} wildcard:

<pre><code>  mv {&lt;oldfilename&gt;,&lt;newfilename&gt;}</code></pre>

Example:

<pre><code>  mv oldname newname</code></pre>

The above command is exactly the same as the following (only less typing, and geekier):

<pre><code>  mv {old,new}name</code></pre>

Example renaming:

<pre><code>  [Computer:~] james% mkdir oldname
  [Computer:~] james% ls -dl *name
  drwxr-xr-x   2 james  james  68 Oct 10 18:06 oldname

  [Computer:~] james% mv oldname newname
  [Computer:~] james% ls -ld *name
  drwxr-xr-x   2 james  james  68 Oct 10 18:06 newname

  [Computer:~] james% mv {new,newer}name
  [Computer:~] james% ls -ld *name
  drwxr-xr-x   2 james  james  68 Oct 10 18:06 newername
</code></pre>

You can rename and move at the same time:

<pre><code>  [Computer:~] james% touch blah
  [Computer:~] james% mv blah newername/bla
  [Computer:~] james% ls -l *name
  -rw-r--r--   1 james  james   0 Oct 10 18:06 bla
</code></pre>

<a name="making_directories"></a>
#### Making directories

Create a new directory:

<pre><code>  mkdir &lt;dirname&gt;</code></pre>

Create a bunch of new directories inside of each other

<pre><code>  mkdir -p &lt;dirname/dirname/dirname&gt;</code></pre>

Create a bunch of new directories

<pre><code>  mkdir -p &lt;dirname1&gt; &lt;dirname2&gt; &lt;dirname3&gt;</code></pre>

<a name="deleting"></a>
#### Deleting

<strong>WARNING, THESE CAN NOT BE UNDONE</strong> (unlike move to Trash)!

Delete a file:

<pre><code>  rm &lt;filename&gt;</code></pre>

Delete a directory (if empty):

<pre><code>  rmdir &lt;dirname&gt;</code></pre>

Delete a directory (doesn't matter if it is empty or not-DANGEROUS, BE CAREFUL!!!!!!!!!!!!!):

<pre><code>  rm -r &lt;dirname&gt;</code></pre>

Delete a bunch of files:

<pre><code>  rm &lt;file1&gt; &lt;file2&gt; &lt;file2&gt; ...</code></pre>

Erase your home folder (not wise):

<pre><code>  rm -r ~/</code></pre>

Erase your boot disk (I can admit to doing this once on a test box on purpose just to see what would happen, it was fun!):

<pre><code>  sudo rm -r /</code></pre>

Secure delete:

<pre><code>  srm &lt;file&gt;</code></pre>

Delete a file named "-r":

<pre><code>  rm -- -r</code></pre>

How to cause <code>rm -r</code> to fail:

<pre><code>  [Computer:~/asdf] james% touch -- -r
  [Computer:~/asdf] james% rm -r *
  usage: rm [-f | -i] [-dPRrvW] file ...
  unlink file
  [Computer:~/asdf] james% ls -l
  -rw-r--r--    1 james  james 0 Oct 10 22:40 -r
</code></pre>

Oops, that can cause a lot of havoc to scripts. How to safely delete files:

<pre><code>  [Computer:~/balladsf] james% rm -r -- *</code></pre>

I suppose I should update all of <em>my</em> scripts that only use <code>rm -r &lt;path&gt;</code>.

<a name="open_stuff"></a>
#### Open stuff

Open a file:

<pre><code>  open &lt;filename&gt;</code></pre>

Open a file with TextEdit:

<pre><code>  open -e &lt;filename&gt;</code></pre>

Open a file with default text editor (determined by LaunchServices-the "Open With" setting in Get Info):

<pre><code>  open -t &lt;filename&gt;</code></pre>

Open a file with a particular application:

<pre><code>  open -a &lt;path to app&gt; &lt;filename&gt;</code></pre>

Open a directory (in Finder):

<pre><code>  open &lt;directory&gt;</code></pre>

Launch an application:

<pre><code>  /path/to/application.app/Contents/MacOS/appname</code></pre>

Example

<pre><code>  /Applications/Safari.app/Contents/MacOS/Safari</code></pre>

If you run an app using the above technique, it is no different than running any other command, such as <code>rm</code>. The difference is that <code>rm</code> runs and quits very quickly (well, <code>sudo rm -r /</code> will probably take awhile). If you want to launch the app and keep using the terminal, then just "detach" it by putting a space and ampersand at the end, like this:

<pre><code>  /Applications/Safari.app/Contents/MacOS/Safari &amp;</code></pre>

Any app can print to the terminal, and that is exactly what command line apps do. GUI apps can do that too, but most do not. So if you use the ampersand, and text suddenly appears in your terminal, it could be from the command you detached. The text does nothing, so you can ignore it if you want (and if you can-you may need to clean up your display).

<a name="copy"></a>
#### Copy

Copy a file

<pre><code>  cp filename new_location/</code></pre>

Duplicate a file/directory:

<pre><code>  ditto &lt;copy contents of dir&gt; &lt;to dir&gt;
  cp -R &lt;copy dir&gt; &lt;to dir&gt;
</code></pre>

<code>ditto</code> and <code>cp</code> behave differently if the destination folder exists! <code>ditto</code> is a Mac OS X utility.

Create a duplicate of the Desktop folder and name the new folder Desktop2 (Desktop2 does not exist):

<pre><code>  ditto ~/Desktop ~/Desktop2</code></pre>

Same as the <code>ditto</code> command except a different name (Desktop3 does not exist)

<pre><code>  cp -R ~/Desktop ~/Desktop3</code></pre>

Desktop2 exists, <strong>copy the contents</strong> of Movies into Desktop2:

<pre><code>  ditto ~/Movies ~/Desktop2</code></pre>

Desktop3 exists, <strong>make a new folder</strong> named Movies in Desktop3:

<pre><code>  cp -R ~/Movies ~/Desktop3</code></pre>

Notice how <code>cp</code> and <code>ditto</code> behave very different if the destination folder exists! <code>cp</code> will create a new folder in the destination. <code>ditto</code> will copy the contents of the source folder to the destination folder! Very different.

<a name="file_owner_or_group"></a>
#### File owner or group

Every file and folder is "owned" by a user account. Use <code>chown</code> and <code>chgrp</code> to change who owns what. You can do this in the Finder with the "Get Info" dialog.

Change the owner:

<pre><code>  sudo chown &lt;username&gt; &lt;path&gt;</code></pre>

Change the owner of everything in a folder:

<pre><code>  sudo chown -R &lt;username&gt; &lt;path&gt;</code></pre>

Multiple owners can modify a file if they are in the same group as the file. That is what group is used for.

Change the group:

<pre><code>  sudo chgrp &lt;groupname&gt; &lt;path&gt;</code></pre>

Change the group of everything in a folder:

<pre><code>  sudo chgrp -R &lt;groupname&gt; &lt;path&gt;</code></pre>

<a name="change_permissions"></a>
#### Change permissions

Each file has a set of permissions associated with it. The permissions is called the "mode". This was talked about already in the <code>ls</code> section. However, there is more to know!

You do some of this in Finder in the "Get Info" dialog. The part you can't do in the Finder is change the x setting. Changing the x setting can bust stuff if you don't know what you are doing.

Change the mode:

<pre><code>  chmod &lt;mode&gt; &lt;path&gt;</code></pre>

Change the mode of everything in a folder:

<pre><code>  chmod -R &lt;mode&gt; &lt;path&gt;</code></pre>

Modes can be specified two ways: what you want done, or a number that represents all of the permissions.

The "what you want done" method is easy. You specify the "user" (aka owner), the group, or "other" (aka world) and then the operation (- or +) and the permission you want changed (r, w, or x). So if I wanted to give other write permission to /etc/crontab (which is a very bad idea), I use this command:

<pre><code>  sudo chmod o+w /etc/crontab</code></pre>

If I wanted to remove world write permissions for every user to every file (another bad idea), I use the command:

<pre><code>  sudo chmod ugo-w /</code></pre>

A number permission is fairly easy to read and you only use a few combinations anyway.

<pre><code>  r means read access (value of 4)
  w means write access (value of 2)
  x means execute if file, search if folder (value of 1)
</code></pre>

Add up the values to get a number (octal) representation of the permissions:

<pre><code>  rwx = 7
  rw- = 6
  r-x = 5
  r-- = 4
  -wx = 3
  -w- = 2
  --x = 1
  --- = 0
</code></pre>

You will usually only use 7, 6, 5, and 4.

Then because there are 3 categories of users, there are 3 of these numbers in a row:

<pre><code>  rwxrwxrwx = 777
  rwxr-xr-x = 755
  rw-r--r-- = 644
</code></pre>

Folders and executable binaries or scripts should be set to this permission:

<pre><code>  775 (rwxrwxr-x)</code></pre>

or

<pre><code>  755 (rwxr-xr-x)</code></pre>

It is common for files (that aren't scripts or executables) to be set to this permission:

<pre><code>  664 (rw-rw-r--)</code></pre>

or

<pre><code>  644 (rw-r--r--)</code></pre>

Usually 7 and 5 go together (rwx and r-x) and 6 and 4 go together (rw- and r-). The only times I've seen 766, 744, 655, or other combinations like that is when someone didn't know what they were doing (733 on a folder is actually a drop box, so old modes aren't always wrong, just rare).

There is also more mode information like SUID bit, sticky bit, etc.,. Just ignore them because you shouldn't mess with them if you don't already know what they are. That extra mode information is at the beginning of the number, making it a 4 digit number. Usually that number is 0 (meaning no extra info). So you might see 0755 and 0644 for example.

If you see 0777 (rwxrwxrwx) that is a good sign somebody didn't know what they are doing. It means that anyone who has an account on your computer can make changes to that file or folder. In most cases, this doesn't matter because Mac OS X is sold to consumers who only give accounts to their family. <em>However</em>, in a multiuser environment like a school lab or a server, 0777 is not a good idea. If you look at /private/tmp, you will see this permission: drwxrwxrwt (1777). Notice the "t"? This is a safe way of doing 777. Yes you can <code>chmod +t &lt;file&gt;</code>.

<a name="file_locking"></a>
#### File locking

In the Finder, you can select "Get Info" on any file or folder and there is a checkbox to "Lock" it. This makes it so you can't delete or change the file. You can do this in the Terminal too.

Lock a file/folder:

<pre><code>  chflags uchg &lt;path&gt;</code></pre>

Lock a directory and everything in it:

<pre><code>  chflags -R uchg &lt;path&gt;</code></pre>

Unlock a file:

<pre><code>  chflags nouchg &lt;path&gt;</code></pre>

Unlock a directory and everything in it:

<pre><code>  chflags -R nouchg &lt;path&gt;</code></pre>

<a name="recursive"></a>
#### Recursive

Command line tools do things to files and directories. Several of them will do things to everything in a directory (recursion). Getting a command to behave recursively depends on the command.

Some tools use -r, some -R. There is kinda a pattern. Most tools use lower case ("-r"). The tools (that I know of) that use upper case are <code>ls</code>, <code>cp</code>, and the <code>ch*</code> commands (<code>chmod</code>, <code>chown</code>, <code>chgrp</code>, and <code>chflags</code>). <code>ls -r</code> just reverses the sort order, so if you use it, no harm will be done (you just don't get what you wanted). <code>chmod -r</code> will remove read permissions (oops). The other ch* commands don't respond to -r. Again, the other tools use lower case ("-r").

If in doubt, try <code>man &lt;toolname&gt;</code> and look at the available options.

When using recursion with the * wildcard, there is a slight difference.

<pre><code>  chmod -R someuser ~/</code></pre>

The above is different from:

<pre><code>  chmod -R someuser ~/*</code></pre>

The first specifies the ~/ folder and all of its contents. The second specifies all of the contents of ~/, but not the folder ~/.

<a name="symbolic_link"></a>
#### Make symbolic link

This is similar to a Finder alias, but they are NOT the same.

<pre><code>  ln -s &lt;realfile&gt; &lt;linkfile&gt;</code></pre>

When you ls a symbolic link, it looks like this:

<pre><code>  lrwxr-xr-x    1 root   admin 11 Apr 18 07:29 tmp -&gt; private/tmp</code></pre>

Notice the first character is "l". Also notice the arrow pointing right. When creating a symbolic link, just remember that the arrow points the opposite direction: realfile &lt;- linkfile (ls is linkfile -&gt; realfile, see how it is different?)

If you want to create a real Finder alias from the command line, use <a href="http://osxutils.sourceforge.net/">OSXUtils</a>.

<a name="find_a_file"></a>
#### Find a file

<pre><code>  find &lt;path&gt; &lt;criteria&gt; &lt;commands&gt;</code></pre>

Examples:

<pre><code>  [Computer:/etc] james% sudo find /private/etc -name "host*" -print
  /private/etc/hostconfig
  /private/etc/hosts
  /private/etc/hosts.equiv
  /private/etc/hosts.lpd

  [Computer:~] james% find ~/.Trash -name ".DS_Store" -print -delete
  /Users/james/.Trash/.DS_Store
  /Users/james/.Trash/build/.DS_Store
  /Users/james/.Trash/build/Release/.DS_Store
  /Users/james/.Trash/build 23-02-55/Release/.DS_Store
  /Users/james/.Trash/untitled folder/.DS_Store

  [Computer:~] james% find ~/.Trash -name ".DS_Store" -print -delete
  [Computer:~] james%
</code></pre>

In the last command there were no files left to delete!

Finding files vs directories and executing a command on the found set:

<pre><code>  find /var/radmind/transcript -type d -exec /bin/chmod 770 '{}' ;
  find /var/radmind/transcript -type f -exec /bin/chmod 660 '{}' ;
</code></pre>

<code>find</code> can find files using many qualifiers, like permissions, size, path, modification date, older, newer, etc. <code>man find</code> to see the list.

You can also use Spotlight from the command line!

<pre><code>  mdfind &lt;text to find&gt;</code></pre>

Example:

<pre><code>  [Computer:~] james% mdfind modo
  /Library/Application Support/Luxology/Documentation/help/pages/Stretch.html
  /Library/Application Support/Luxology/Documentation/help/pages/Subdivide.html
  /Library/Application Support/Luxology/Documentation/help/pages/Subdivision_Level.html
  ...
  /Users/james/Library/Mail/IMAP-james@-----.com/mail/sent-mail.imapmbox/Messages/347181.emlx
  /Users/james/Library/Mail/IMAP-james@-----.com/mail/sent-mail.imapmbox/Messages/347819.emlx
  /Users/james/Library/Mail/IMAP-james@-----.edu/Sent Messages.imapmbox/Messages/348825.emlx
  /Users/james/WherezModo/source/Controller.h
  /Users/james/WherezModo/source/Controller.m
  /Users/james/Desktop/unix/Tutorial
</code></pre>

Here is another interesting example searching for world writable locations (output seriously shortened because it was so long.):

<pre><code>  [Computer:~] james% /usr/bin/find / ! -type l -perm -2
  /.Trashes
  /Applications/Adobe/Adobe Version Cue CS2/config/StartupOptions.xml
  /Applications/DivX Converter/DivX Converter.app
  /dev/tty
  /Library/Application Support/Adobe/Adobe Registration Database
  /Library/Audio/Apple Loops Index
  /Library/Caches
  /Library/Internet Plug-Ins/DRM Plugin.bundle
  /Library/Preferences/Adobe Systems
  /Library/Printers/EPSON/CIOSupport/Preferences
  /Library/Printers/Lexmark/Preferences
  /Library/ScriptingAdditions
  /Library/ScriptingAdditions/Adobe Unit Types
  /private/etc/opt/cisco-vpnclient
  /private/tmp
  /private/tmp/mysql.sock
  /private/var/run/asl_input
  /private/var/spool/samba
  /private/var/tmp
  /private/var/tmp/mds
  /Users/Shared
  /Users/Shared/GarageBand Demo Songs
  /Volumes
</code></pre>

And this command turned up some interesting finds (output pruned again):

<pre><code>  [Computer:/System/Library] james% find . -type f -perm -1 -print
  ./Frameworks/ApplicationServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister
  ./CoreServices/RemoteManagement/AppleVNCServer.bundle/Contents/Support/LockScreen.app/Contents/MacOS/LockScreen
  ./CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart
  ./CoreServices/Software Update.app/Contents/Resources/SoftwareUpdateCheck
</code></pre>

I tested a few and a few of the commands actually did things:

<pre><code>  [Computer:/] james% "/System/Library/CoreServices/Software Update.app/Contents/Resources/SoftwareUpdateCheck"
  2006-10-12 23:04:23.754 SoftwareUpdateCheck[11716] Checking for updates
</code></pre>

(The software update window appeared and showed my all of my out of date Apple software!)

I cheated, I already knew about this one:

<pre><code>  [Computer:] root# /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -help

  kickstart -- Quickly uninstall, install, activate, configure, and/or restart
  components of Apple Remote Desktop without a reboot.

  kickstart -uninstall -files -settings -prefs

  -install -package &lt;path&gt;
  ...
</code></pre>

I knew about this one too:

<pre><code>  [Computer:/] james% /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister
  lsregister: [OPTIONS] [-domain { system | local | user | network }]... [path]...
  Search the paths for application bundles and add each found item to the Launch
  Services database.  For domain specifications, ask CF for the list of application
  locations in the given domain(s).

  -kill     Reset the global Launch Services database before doing anything else
  -lint     Print information about plist errors while registering bundles
  -convert  Register apps found in older LS database files
  -lazy n   Sleep for n seconds before registering apps if the local cache
  is aleady populated.
  -r  Recursively register directory contents, do not recurse into
  packages or invisible directories.
  -R  Recursively register directory contents, including the contents
  of packages and invisible directories.
  -f  force-update registration info even if mod date is unchanged
  -v  Display progress information.
  -dump     Display full database contents after registration.
  -h  Display this help.
</code></pre>

<a name="clear_the_screen"></a>
#### Clear the screen

There is the command:

<pre><code>  clear</code></pre>

And the keyboard shortcut:

<pre><code>  ctrl-l</code></pre>

And in Terminal.app you can use command-K to clear the screen and the "scrollback". This is sometimes helpful if you need to run a command that prints a lot of text, because you can press home key to see the top of the output and page down to read it. This is much easier than trying to scroll up and see where you started the command with a full scrollback. You can set the scrollback length to unlimited in the Terminal prefs if you have really long winded commands.

<a name="history"></a>
#### History

The shell keeps track of what commands you type. This is a feature of the shell, not the application. This will print out a list of all remembered commands:

<pre><code>  history</code></pre>

You've also got keyboard shortcuts:

<pre><code>  up arrow - history up one word
  down arrow - history down one word
</code></pre>

When using the up arrow, you can use the <code>ctrl-a</code> key to jump to the beginning of the line and then <code>esc-f</code> to go forward each word until you get where you want to change it (I hate watching people hold down left arrow to the start of the line).

And there is history search:

<pre><code>  &lt;typeletters&gt; esc-p - history search backwards (does not work on BASH)
  &lt;typeletters&gt; esc-n - history search forwards (does not work on BASH)
</code></pre>

History search is similar to tab completion, you can start typing a command, but instead of hitting TAB to complete the command, use <code>esc-p</code> and it will complete it with whatever it finds in the history that matches the first part you've typed already. Keep pressing <code>esc-p</code> or <code>esc-n</code> to move up or down through the history.

The history is saved to a file, either ~/.bash<em>history or ~/.tcsh</em>history. This is a <strong>VERY GOOD REASON</strong> to <strong>NEVER TYPE A PASSWORD</strong>. If you do, you want to close all your terminal windows and then erase the history then open a new terminal window, then close the old one, then close the new one. Only after doing that complicated routine is the password really gone. Really, just don't type your password in a command.

This is why you need to do all of that to clear the history (and why the history isn't 100% accurate).

When a new terminal window is opened, it reads the history file and then every command you type after that is remembered by that window (but not written to the history file). When you close the window, the remembered history is written to the history file, including the old history it loaded when you opened the window.

If you open 2 Terminal windows at the same time, each will read the history file. If you type "bad things" in window A and close it, it will save "bad things" to the history file. If you then type "good things" in window B, then close it, it will OVERWRITE the history window A just saved with window B's history, thus erasing "bad things".

It is kinda complex. Just don't expect the history to remember every command you type. If you catch the hang of it, you can at least be aware of when you accidentally blow away the history (which I've done in agony). Of course you can avoid doing that by just keeping one Terminal window open, but I can't stand that and typically have a minimum of 3 open on my work computer, and sometimes as many as 10.

<a name="bindkey"></a>
#### Bindkey

Typing in the terminal can be a slow process, especially if your key repeat rate is slow (mine is all the way up-yours should be too). Luckily, there are some short cuts that let you move around quickly.

First of all, go to "Terminal" menu, "Window Settings", "Emulation" pop-up, and check "Option click to position cursor". Now you can option click and the cursor will try to move to that location. Terminal.app does this by using the keyboard arrow keys to move the cursor around (or something). What that means is that if it hits a tab, or some other strange character, the cursor will not actually move to the location you clicked, but it will be off. So you may have to option click a few times to get it to the right spot. It is better than just the arrow keys so be happy.

Moving around:

<pre><code>  ctrl-a - move to beginning of line
  ctrl-e - move to end of line
  esc-b - skip backwards a ward at a time
  esc-f - skip forwards a word at a time
</code></pre>

Cut and paste:

<pre><code>  ctrl-d - deletes the charcter **after** the cursor (opposite of the delete key)
  esc-backspace - delete letters before the cursor to the next space (word delete)
  esc-d - delete letters after the cursor to the next space (word delete)
  ctrl-u - delete whole line
  ctrl-k - delete from cursor to end of line)
  ctrl-w - delete from cursor to begin of line)
  ctrl-y - yank, puts back what ctrl-u/k/w removed (acts like paste)
  esc-y - cycle through yank
  esc-d
</code></pre>

Very important:

<pre><code>  ctrl-c - cancel</code></pre>

End of Line:

<pre><code>  ctrl-d - when in input mode (haven't mentioned that yet, but `grep a` is an easy way to get there), exit with cntl-d</code></pre>

Change case:

<pre><code>  esc-u - make word uppercase
  esc-l - make word lowercase
</code></pre>

To see all options, type <code>bindkey</code> if you are using TCSH or <code>bind -p</code> if you are using BASH.

<a name="open_a_cd_tray"></a>
#### Open a CD tray

<pre><code>  drutil eject</code></pre>

Use scripts that synchronize their times with their IP and send the command via Apple Remote Desktop that open and close the trays of rows of computers in front of large crowds of Apple system admins in order to pretend that you are Steve Hayman.

<a name="mount_a_disk_image"></a>
#### Mount a disk image file (dmg)

<pre><code>  hdiutil mount &lt;file.dmg&gt;

  [Computer:~/Desktop] james% hdiutil mount *dmg
  Checksumming Single Volume (Apple_HFS : 0)...
  .................................................................................
  Single Volume (Apple_HFS : 0): verified   CRC32 $A1000E0F
  verified   CRC32 $DAAF9163
  /dev/disk2    /Volumes/SomeDMG
</code></pre>

Unmounting:

<pre><code>  [Computer:~/Desktop] james% hdiutil unmount /Volumes/SomeDMG
  "disk2" unmounted successfully.
</code></pre>

<a name="ignoring_permissions_of_mounted_volume"></a>
#### Ignoring permissions of a mounted volume

Apple allows users to bypass Unix permissions on mounted volumes. To check to see if permissions are ignored on a volume:

<pre><code>  vsdbutil -c /Volumes/Diskname</code></pre>

To ignore permissions on the volume:

<pre><code>  vsdbutil -d /Volumes/Diskname</code></pre>

To use Unix permissions on a volume:

<pre><code>  vsdbutil -a /Volumes/Diskname</code></pre>

For example:

<pre><code>  [Computer:/] root# vsdbutil -c /Volumes/Disk
  Permissions on '/Volumes/Disk/' are enabled.
</code></pre>

Permissions are on.

<pre><code>  [Computer:/] root# ls -l /Volumes/Disk
  ...
  -rw-r--r--    1 james     admin    994 Jul 12 13:39 getip.pl
  -rwxr-xr-x    1 rootadmin 433544 Jun 26 14:12 hping_fat
  drwxrwxr-x    3 unknown   unknown  102 May 12 11:45 iMacSMCUpdate.pkg
  -rwxr-xr-x    1 unknown   unknown 2374 Dec 28  2005 indexLoops
  drwxr-xr-x   30 james     admin   1020 Sep  5 11:18 modo
  drwxrwxrwx   52 unknown   unknown 1768 Sep 19 21:53 ruby
  drwxr-xr-x   10 unknown   unknown  340 Sep 19 21:53 textmate
  -rw-r--r--    1 unknown   unknown  983820084 Aug 15 15:47 xcode_2.4_8k1079_6936199.dmg
</code></pre>

Notice the unknown user and group? That is because I created those files while permissions were off. I'll now turn off permissions, and see what havoc breaks loose.

<pre><code>  [Computer:/] root# vsdbutil -d /Volumes/Disk
  [Computer:/] root# vsdbutil -c /Volumes/Disk
  Permissions on '/Volumes/Disk/' are disabled.
</code></pre>

Permissions are now off. Notice I'm the root user.

<pre><code>  [Computer:/] root# ls -l /Volumes/Disk
  -rw-r--r--    1 unknown  unknown  994 Jul 12 13:39 getip.pl
  -rwxr-xr-x    1 unknown  unknown     433544 Jun 26 14:12 hping_fat
  drwxrwxr-x    3 unknown  unknown  102 May 12 11:45 iMacSMCUpdate.pkg
  -rwxr-xr-x    1 unknown  unknown 2374 Dec 28  2005 indexLoops
  drwxr-xr-x   30 unknown  unknown 1020 Sep  5 11:18 modo
  drwxrwxrwx   52 unknown  unknown 1768 Sep 19 21:53 ruby
  drwxr-xr-x   10 unknown  unknown  340 Sep 19 21:53 textmate
  -rw-r--r--    1 unknown  unknown  983820084 Aug 15 15:47 xcode_2.4_8k1079_6936199.dmg
</code></pre>

That's different. Now I'll become the user named "mac" (a local account on my computer) and look at the permissions.

<pre><code>  [Computer:/] root# su mac
  [Computer:/] mac% ls -l /Volumes/Disk
  -rw-r--r--    1 mac  mac  994 Jul 12 13:39 getip.pl
  -rwxr-xr-x    1 mac  mac     433544 Jun 26 14:12 hping_fat
  drwxrwxr-x    3 mac  mac  102 May 12 11:45 iMacSMCUpdate.pkg
  -rwxr-xr-x    1 mac  mac 2374 Dec 28  2005 indexLoops
  drwxr-xr-x   30 mac  mac 1020 Sep  5 11:18 modo
  drwxrwxrwx   52 mac  mac 1768 Sep 19 21:53 ruby
  drwxr-xr-x   10 mac  mac  340 Sep 19 21:53 textmate
  -rw-r--r--    1 mac  mac  983820084 Aug 15 15:47 xcode_2.4_8k1079_6936199.dmg
</code></pre>

The user named "mac" owns all those files! Now I'll become a different user and see what happens.

<pre><code>  [Computer:/Volumes] mac% exit
  exit
  [Computer:/Volumes] root# su james
  [Computer:/Volumes] james% ls -l Radmind Ignores/
  -rw-r--r--    1 james  james  994 Jul 12 13:39 getip.pl
  -rwxr-xr-x    1 james  james     433544 Jun 26 14:12 hping_fat
  drwxrwxr-x    3 james  james  102 May 12 11:45 iMacSMCUpdate.pkg
  -rwxr-xr-x    1 james  james 2374 Dec 28  2005 indexLoops
  drwxr-xr-x   30 james  james 1020 Sep  5 11:18 modo
  drwxrwxrwx   52 james  james 1768 Sep 19 21:53 ruby
  drwxr-xr-x   10 james  james  340 Sep 19 21:53 textmate
  -rw-r--r--    1 james  james  983820084 Aug 15 15:47 xcode_2.4_8k1079_6936199.dmg
</code></pre>

Now the user "james" owns the files!

What does this mean? If you allow other users SSH access to your computer and you <strong>think</strong> that they can't access mounted volumes, you better make sure by checking that permissions are not ignored. If permissions are ignored on a volume, every user that logs in will be the owner of everything on that volume.

<a name="mount_afp_volume"></a>
#### Mount an AFP volume

Mounting a disk is an existential act. First, you must have a plain (but empty) folder. If you want, you can create a new one using <code>mkdir</code>. For example:

<pre><code>  [Computer:/Volumes] james% mkdir "/Volumes/A Very New Disk"
  [Computer:/Volumes] james% ls -l
  total 8
  drwxr-xr-x    2 james  admin     68 Oct  7 20:52 A Very New Disk
  lrwxr-xr-x    1 root   admin1 Sep 27 09:35 Macintosh HD -&gt; /
</code></pre>

It's there. But it's empty:

<pre><code>  [Computer:/Volumes] james% ls -l "/Volumes/A Very New Disk"
  [Computer:/Volumes] james%
</code></pre>

Now you can proceed.

Mount a volume (so you don't have to type your password, which keeps the password out of the history file):

<pre><code>  mount_afp -i afp://user@server.example.com/Disk_Name "/Volumes/A Very New Disk"</code></pre>

Mount a volume with the password (for a script):

<pre><code>  mount_afp afp://user:password@server.example.com/Disk_Name /Volumes/A Very New Disk"</code></pre>

If the disk mounts and the Finder doesn't notice, try this to update the Finder:

<pre><code>  disktool -r</code></pre>

To unmount it:

<pre><code>  umount /Volumes/A Very New Disk</code></pre>

Very simple (yet very mystical).

Another example mounting the disk in your home directory:

<pre><code>  [Computer:~] james% mkdir Radical
  [Computer:~] james% mount_afp -i afp://secret@secret.example.com/A Disk Radical
  Password:
  mount_afp: the mount flags are 0000 the altflags are 0020
</code></pre>

The disk name is "A Disk" but the mount point is "Radical". And even more interesting is that "Radical" is located in my home directory! After I did this, Finder hid "Radical" from me and instead put it in my sidebar (how helpful). Terminal did the correct thing and allowed me to <code>cd</code> into it and do what I wanted. I don't know why Finder would go through the trouble to hide it. After all, it is very unlikely that a user would <em>accidentally</em> mount something in their home folder.

<a name="find_disk_usage"></a>
#### Find disk usage

Terminal can tell you how much space you have left just like the Finder.

<pre><code>  [Computer:~] james% df -lh
  Filesystem     Size   Used  Avail Capacity  Mounted on
  /dev/disk0s2    74G    68G   5.8G    92%    /
  /dev/disk1s2    74G    68G   5.8G    92%    /Users/james
</code></pre>

I happen to be using encrypted home folders, and wouldn't you know it, /Users/james is a mounted disk! It is kinda odd it is the same size as the hard disk though.

And ironically, no matter how big hard drives get, I always push my usage above 90%.

Display the amount of disk space a folder/file is taking up.

<pre><code>  du -hd0 &lt;path&gt;</code></pre>

It counts everything right then and there, so if you run <code>du -hd0 /</code>, you might want to go find something else to do.

<pre><code>  2.3G    /System/</code></pre>

Change the number after the d option to show more details. For example 3 shows the sizes of everything 3 levels deep:

<pre><code>  [Computer:/Applications] james% du -hd3 /Library/Application Support/Luxology/modo 201/Documentation
  8.0K    /Library/Application Support/Luxology/modo 201/Documentation/help/common/css
  56K    /Library/Application Support/Luxology/modo 201/Documentation/help/common/img
  4.0K    /Library/Application Support/Luxology/modo 201/Documentation/help/common/script
  68K    /Library/Application Support/Luxology/modo 201/Documentation/help/common
  525M    /Library/Application Support/Luxology/modo 201/Documentation/help/pages/clips
  18M    /Library/Application Support/Luxology/modo 201/Documentation/help/pages/imgs
  1.6G    /Library/Application Support/Luxology/modo 201/Documentation/help/pages/video
  2.1G    /Library/Application Support/Luxology/modo 201/Documentation/help/pages
  2.2G    /Library/Application Support/Luxology/modo 201/Documentation/help
  2.2G    /Library/Application Support/Luxology/modo 201/Documentation
</code></pre>

Thus we see that "help/pages/video" is 1.6 GB and "help/pages/clips" is 525 MB, totaling 2.1 GB, the bulk of modo's documentation (each folder contains video files).

<a name="creating_an_archive"></a>
#### Creating an archive

This will create archivename.zip and will include every file you specify:

<pre><code>  zip archivename.zip file1 file2 etc</code></pre>

This will create archivename.zip of the contents of "folder":

<pre><code>  zip -r archivename.zip folder</code></pre>

Hey folks, you can use tar too:

<pre><code>  tar cfvz archivename.tgz file1 file2 etc

  tar cfvz archivename.tgz folder
</code></pre>

You can double click on these in the Finder to open them (the tgz too). Or you can uncompress them from Terminal too:

<pre><code>  unzip archivename.zip

  tar xfvz archivename.tgz
</code></pre>

A note about <code>tar</code>. It has many purposes, and creating tgz files isn't the main one, so that is why you have to type so much to get it to do it. Just remember c stands for compress, x for extract, and fvz all kinda make similar sounds (and are all typed with the right hand on a qwerty keyboard).  O:)

<a name="restart"></a>
#### Restart
<pre><code>  sudo reboot
  sudo shutdown -r now
</code></pre>

You need to be root to restart a computer obviously.

<a name="shutdown"></a>
#### Shutdown

<pre><code>  sudo shutdown -h now</code></pre>

Example:

<pre><code>  [remote-computer:~] root# shutdown -h now
  Shutdown NOW!
  shutdown: [pid 12792]
  [remote-computer:~] root#
  *** FINAL System shutdown message from mac@james-tech-mac-1.scl.utah.edu ***

  System going down IMMEDIATELY





  System shutdown time has arrived
  Stopping Network Information Service
  Stopping Apache web server
  Stopping network time synchronization
  /usr/sbin/apachectl stop: httpd (no pid file) not running
  Starting...
  Stopped ARD Helper.
  Stopped ARD Agent.
  Stopped VNC Server.
  Done.
  Connection to remote-computer.example.com closed by remote host.
  Connection to remote-computer.example.com closed.
  [Computer:/Volumes] root# ping 12.34.56.78
  PING 12.34.56.78 (12.34.56.78): 56 data bytes
  ^C
  --- 12.34.56.78 ping statistics ---
  10 packets transmitted, 0 packets received, 100% packet loss
</code></pre>

Oops. Now what? Guess I'll have to wait until I get to work on Monday.

<a name="logout"></a>
#### Logout

<pre><code>  killall loginwindow</code></pre>

Ok, that really isn't the real way to logout. But it IS quick and works.

Although this should work, it doesn't:

<pre><code>  osascript -e 'try' -e 'ignoring application responses' -e 'tell application "loginwindow" to &amp;#171;event aevtrlgo&amp;#187;' -e 'end ignoring' -e 'end try'</code></pre>

I'm assuming it doesn't work because it can't wrap its head around the chevron characters.

Determined not to be thwarted, I came up with this awkward solution. First, you have to create the script on your local machine. If you don't mind using Script Editor.app, save the following as logout.scpt:

<pre><code>  echo try
  ignoring application responses
  tell application "loginwindow" to &amp;#171;event aevtrlgo&amp;#187;
  end ignoring
  end try
</code></pre>

Then run this command to get a hexdump of it:

<pre><code>  cat logout.scpt | perl -ne 'print unpack "H*", $_'</code></pre>

Mine prints out this:

<pre><code>  4661736455415320312e3130312e31300e000000040fffff00010002000301ff
  ff00000d000100026c00020000001c0004fffe0d000400035100000000001c00
  050006fffd0d00050003500000000300130007fffc00080d000700024f000100
  0800120009000a0d00090003490002000c0011fffbfffafff90afffb00182e61
  657674726c676f2a2a2a2a00000000000090002a2a2a2a01fffa000002fff900
  000d000a00016d000000080009000b0f000b01d8086e756c6c000000000001df
  80ff9c000975b30f6c6f67696e77696e646f772e617070db3016488280000000
  800000000100000001a001021890045ff8bfffd9d0bfffdbe190046044991e50
  d8bfffd9d0bfff6c676e7700001100616c697300000000017a00020001084d61
  63204f53205800000000000000000000000000000000000000bf145f5d482b00
  00000975b30f6c6f67696e77696e646f772e6170700000000000000000000000
  0000000000000000000000000000000000000000000000000000000000000000
  00000000000009991abf140d330000000000000000ffffffff00000920000000
  0000000000000000000000000c436f72655365727669636573001000080000bf
  14b3bd0000001100080000bf14619300000001000c000975b300090bf500090b
  f3000200344d6163204f5320583a53797374656d3a4c6962726172793a436f72
  6553657276696365733a6c6f67696e77696e646f772e617070000e0020000f00
  6c006f00670069006e00770069006e0064006f0077002e006100700070000f00
  120008004d006100630020004f0053002000580012002b53797374656d2f4c69
  62726172792f436f726553657276696365732f6c6f67696e77696e646f772e61
  707000001300012f00ffff000002fffc00000200080002fff8fff70afff80008
  0b636f6e73726d746502fff700000d0006000352000000000000fff6fff5fff4
  0afff600182e61736372657272202a2a2a2a00000000000090002a2a2a2a01ff
  f5000002fff4000001fffd000001fffe00000e000200000f1000030003fff300
  0c000d01fff3000010000c0001fff20afff200182e616576746f6170706e756c
  6c00008000000090002a2a2a2a0e000d000710fff1000efff0ffef000f0010ff
  ee0afff100182e616576746f6170706e756c6c00008000000090002a2a2a2a0d
  000e00016b00000000001c001102001100020001ffed02ffed000001fff00000
  02ffef000010000f000010001000050008000bffecffebffea0affec00182e61
  657674726c676f2a2a2a2a00000000000090002a2a2a2a01ffeb000002ffea00
  0011ffee001d14001567e013000de11200072a6a0c0002555657000858000300
  04680f00617363720001000dfadedead
</code></pre>

Copy that. Then on the remote machine, type "pico logout.hex" (see below for more info on pico). Paste. Type <code>ctrl-x</code> to save the file and exit pico. Then type this:

<pre><code>  perl -e 'chomp ( $hex = `cat logout.hex`);' -e 'print pack "H*", $hex' &gt; logout.scpt</code></pre>

Then to logout, type

<pre><code>  osascript logout.scpt</code></pre>

This will not ask to logout. However, if an app refuses to quit, logout will be canceled. So if after, say, 30 seconds you haven't logged out, run top, look to see what is still running, and you can kill it or you can actually tell it to quit with this command:

<pre><code>  osascript -e 'tell application "Terminal" to quit'</code></pre>

If it doesn't respond to that, perhaps it has a sheet asking for user input. I suppose you could use UI scripting to click "OK" or whatever, but even I have to say that is excessive.

However, what if you aren't sure what is going on? If the screensaver on the remote machine isn't running, you can see what the screen looks like with this command:

<pre><code>  screencapture filename.png</code></pre>

Then <code>scp</code> that file to your machine and voilà, poor man's VNC (except VNC is free). It is a neat trick anyway.

An even neater trick is if you have an isight, and you think someone is using your computer. Use <a href="http://www.intergalactic.de/hacks.html">isightcapture</a> to take a picture of them (You'll have to download this).

<a name="download_a_file"></a>
#### Download a file

<pre><code>  curl -O http://example.com/filename</code></pre>

If you install <a href="http://www.gnu.org/software/wget/">wget</a> then you can use it as well (<a href="http://rudix.sourceforge.net/">Rudix</a> is probably the easiest way to get it for Mac OS X). Example:

<pre><code>  wget http://example.com/filename</code></pre>


<a name="sleep"></a>
#### Sleep

<pre><code>  osascript -e 'tell application "System Events"' -e 'sleep' -e 'end tell'</code></pre>

Remotely waking it is going to be a bit hard. Apple Remote Desktop can do it (if you are on the same subnet). Otherwise, good luck.

<a name="finding_out_what_is_running"></a>
#### Finding out what is running

So the dock shows you what is running. You can get the same information by running the <code>ps</code> command with the <code>Aww</code> flags, which tells <code>ps</code> to show all processes and their full path.

<pre><code>  [Computer:~] james% ps -Aww
  PID  TT  STATTIME COMMAND
  1  ??  S&lt;s    0:02.99 /sbin/launchd
  23  ??  Ss     0:00.95 /sbin/dynamic_pager -F /private/var/vm/swapfile
  27  ??  Ss     0:01.66 kextd
  31  ??  Ss     0:28.50 /System/Library/PrivateFrameworks/DedicatedNetworkBuilds.framework/Resources/bfobserver
  32  ??  Ss     0:00.06 /usr/sbin/KernelEventAgent
  33  ??  Ss     0:05.80 /usr/sbin/mDNSResponder -launchdaemon
  34  ??  Ss     0:05.17 /usr/sbin/netinfod -s local
  35  ??  Ss     0:00.87 /usr/sbin/syslogd
  37  ??  Ss     0:31.53 /usr/sbin/configd
  38  ??  Ss     0:03.42 /usr/sbin/coreaudiod
  ...
</code></pre>

This will show you lots of good information, like the process ID (PID). Using the PID, you can kill (force quit) a process (see below). The STAT column tells you what the process is doing, such as sleeping (good processes are very much like cats, they sleep an awful lot). It also tells how much time of the CPU the process has consumed. Good, bug free processes, will not use the CPU when you are not using it. As of this writing, Photoshop is still Carbon, so we still must forgive it.

To read the STAT column, look at the first character. It will be either I (idle), S (sleep), R (runnable), T (stopped), U (uninterruptible wait, waiting for some disk or network event-possibly hung, but not necessarily), or Z (zombie). If you see a Z, then you have a zombie process that is trolling your computer eating other processes. Just kidding. A zombie process is a process that was quit but it wont die. To get rid of it, you will have to restart the computer. Zombie processes aren't suppose to happen. I've actually had some computers not restart because the computer waits for the zombie to die, and it never does, so I had to hard restart it. I've also had some computers with zombies not boot up after restarting. So having a zombie could spell trouble. Then again, it may be nothing but a programmer bug.

Adding the j flag will show user type information:

<pre><code>  [Computer:~] james% ps -Awwj
  USER PID  PPID  PGID   SESS JOBC STAT  TT TIME COMMAND
  root   1     0     1 2844e88    0 S&lt;s   ??    0:03.00 /sbin/launchd
  root  23     1    23 2844c60    0 Ss    ??    0:00.95 /sbin/dynamic_pager -F /private/var/vm/swapfile
  root  27     1    27 2844b4c    0 Ss    ??    0:01.66 kextd
  root  31     1    31 28438f8    0 Ss    ??    0:28.51 /System/Library/PrivateFrameworks/DedicatedNetworkBuilds.framework/Resources/bfobserver
  root  32     1    32 28445e8    0 Ss    ??    0:00.06 /usr/sbin/KernelEventAgent
  ...
  windowse    56     1    56 28437e4    0 Rs    ??   41:57.92 /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreGraphics.framework/Resources/WindowServer -daemon
  root  61    37    37 28444d4    0 S     ??    0:02.16 /usr/sbin/blued
  root  64     1    64 2843a0c    0 Ss    ??    4:41.96 /System/Library/CoreServices/coreservicesd
  james 69     1    69 28436d0    0 Ss    ??    0:09.11 /System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Support/ATSServer
  james 70     1    70 28434a8    0 Ss    ??    0:05.07 /System/Library/CoreServices/loginwindow.app/Contents/MacOS/loginwindow console
  ...
</code></pre>

Another method to find out what is running on your system is to use <code>top</code>. It will show you a second by second snapshot of what is running, so you can get a vague idea how busy your machine is.

<pre><code>  Processes:  72 total, 2 running, 70 sleeping... 269 threads16:18:21
  Load Avg:  0.43, 0.31, 0.30     CPU usage:  7.6% user, 8.0% sys, 84.4% idle
  SharedLibs: num =  241, resident = 36.6M code, 5.25M data, 5.83M LinkEdit
  MemRegions: num = 10821, resident =  305M + 15.9M private,  153M shared
  PhysMem:   233M wired,  473M active,  277M inactive,  984M used, 39.1M free
  VM: 12.3G +  158M   330051(0) pageins, 265393(0) pageouts

  PID COMMAND%CPU   TIME   #TH #PRTS #MREGS RPRVT  RSHRD  RSIZE  VSIZE
  5649 top   10.6%  0:08.43   1    18    20   624K   692K  1.04M  26.9M
  5618 tcsh   0.0%  0:00.02   1    15    20   408K   976K   908K  31.1M
  5600 tcsh   0.0%  0:00.04   1    15    20   408K   976K   912K  31.1M
  5548 mdimport     0.0%  0:00.15   3    61    42   704K  2.81M  2.34M  38.9M
  5522 mdimport     0.0%  0:00.57   4    66   106  1.29M  2.92M  3.66M  57.9M
  5369 ping   0.0%  0:01.54   1    14    19   140K   648K   376K  26.8M
  5355 iChatAgent   0.0%  0:00.52   3    70    68  1.34M  3.53M  11.6M   297M
  5354 iChat  0.0%  0:01.13   6   243   252  7.25M  9.54M  31.3M   360M
  ...
</code></pre>

<a name="force_quitting_processes"></a>
#### Force quitting processes

You can force quit ("kill") a process using the pid (obtained with <code>ps</code> or <code>top</code>):

<pre><code>  sudo kill 1</code></pre>

Or you can kill it by name:

<pre><code>  sudo killall launchd</code></pre>

Or you can force kill it (SIGKILL) if polite kill (SIGTERM) doesn't work:

<pre><code>  sudo kill -9 1
  sudo killall -9 launchd
</code></pre>

(BTW, killing launchd is a very bad idea.)

<a name="editing_text_files_from_command_line"></a>
#### Editing text files from the command line

The easiest option to edit via command line is <code>pico</code> (<code>nano</code> in 10.4). It was written for non-programmers to use with the email reader <code>pine</code>. So <code>pico</code> shows you the available commands at the bottom of the terminal window and is fairly obvious (for a Terminal based editor).

A problem with <code>pico</code> is that it will hard wrap lines. <code>nano</code> does not have this problem. However, if resize the window bigger while using <code>nano</code> it will hang (and take as much CPU as it can get away with). It does this in iTerm too, so it isn't a Terminal.app bug.

<pre><code>  pico &lt;filename&gt;
  nano &lt;filename&gt;
</code></pre>

In 10.4, if you type <code>pico</code>, it will open <code>nano</code> for you. For some reason, I can't get out of the habit of typing <code>pico</code>.

If you type <code>pico</code> and then the name of a file that doesn't exist, <code>pico</code> will create that file when you save. There is no way to open a new file (like the "File" -&gt; "Open" menu). You have to exit and then type <code>pico</code> again with a new filename.

The important functions in <code>pico</code> are:

<pre><code>  ctrl-o to save (it means write out, out being the significant word... don't ask me why)
  ctrl-x to exit (it will ask if you want to save if you made changes and haven't saved)
  ctrl-w to find (where being the significant word)
  ctrl-y page up
  ctrl-v page down
  ctrl-k cut line(s)
  ctrl-u uncut line(s)
  ctrl-shift-6 start/stop mark (so you can cut many lines)
</code></pre>

If you ever press <code>ctrl-j</code> (which is dangerously close to <code>ctrl-k</code>), it will "wrap" everything for you and I think it does a pretty miserable job, especially if it is code. Just press <code>ctrl-u</code> <strong>right after</strong> to undo it.

<a name="hardcore_editing_text_files_from_command_line"></a>
#### Hardcore editing text files from the command line

If you are serious about being a hardcore command line person, you will want to learn <code>vi</code> or <code>emacs</code>. I'll just say that you should at least learn enough <code>vi</code> to change, save, and exit a file, because <code>visudo</code> is one command line utility that forces you to use <code>vi</code>. Ok, you can configure it to use <code>pico</code>, but learning <code>vi</code> that hard. Well, if you really want to use <code>pico</code>, check out the next section (set EDITOR to "/usr/bin/pico").

Edit a file with <code>vi</code>:

<pre><code>  vi &lt;filename&gt;</code></pre>

<ul>
  <li>To go to insert mode (so you can add more lines and type things like ":") just start typing (look for the text "- INSERT -" to appear at the bottom).</li>
  <li>To save: hit the <code>esc</code> key (takes you out of insert mode), then type ":w"</li>
  <li>To save and quit: hit the <code>esc</code> key, then type ":wq"</li>
  <li>To quit without saving: hit <code>the</code> esc key, then type ":q!"</li>
</ul>

<a name="environment_variables"></a>
#### Environment Variables

I remember when I first learned Unix there were these mysterious things called environment variables. I knew what a variable was from algebra (y=m*x anyone?), what why was it called environment? If you are into 3D graphics, you might think it has something to do with the background lighting. Well, as it turns out, the environment isn't that complex. If you open 2 terminal windows, and you change a variable in one, it wont affect the other window. That is because each has its own "environment" that is independent of each other.

What sort of variables are there? Well, anything you want. There are many built in variables, like your HOME, your PATH, and your EDITOR. There variables are set to the locations of your home folder and the paths of terminal commands.

This is how to change a variable if you are using BASH:

<pre><code>  export VAR="new value"</code></pre>

And now TCSH:

<pre><code>  setenv VAR "new value"</code></pre>

This is how to change the PATH variable in BASH (specify $PATH to keep the old values, which is important):

<pre><code>  export PATH=/usr/local/mysql/bin:$PATH</code></pre>

And now TCSH:

<pre><code>  setenv PATH /usr/local/mysql/bin:$PATH</code></pre>

If you want a variable to affect other terminal windows, you need to make it part of the shell startup sequence. You do that by editing the startup script for the shell. The following commands will add the text you need for you (very handy):

BASH:

<pre><code>  echo 'export PATH=/usr/local/mysql/bin:$PATH' &gt;&gt; ~/.bash_profile</code></pre>

TCSH:

<pre><code>  echo 'setenv PATH /usr/local/mysql/bin:$PATH' &gt;&gt; ~/.tcshrc</code></pre>


<a name="replacing_bbedits_multifile_search"></a>
#### Replacing BBEdit's Multi-file search with the command line

To search for a word or phrase in a file or multiple files use <code>grep</code>. Grep stands for "global regular expression print", which is a function of the "ed" command: g/re/p" where g is global, re represents the regular expression, and p is print. The name doesn't come from the sound cats make coughing up hairballs (which is more like "grk").

<p>A regular expression is a formula for matching text that fits a pattern. The most obvious match is equals, that is "text" equals "text". With <code>grep</code>, you cam perform complex system of wildcards matches, like "(T|t).x(T|t)" matches "text" (and many other combinations).</p>

The really important thing to know is that certain characters have special regular expression meanings. When you use the special character, magical things will happen, and you suddenly find all kinds of text! For example, ".*" is a pattern that will find EVERYTHING! Another example is "..." which will find everything that has 3 characters!

So, this brings up a point. What if all you want is to find 3 real periods? You need to tell grep to not treat it like a special character, but as a character to find. Do this by "escaping" the character by placing a backslash in front of it, like this ".".

Here are the characters with regular expression meanings:

<code>.[]?*+{}|</code>

^ and $ also have special meanings if they come at the beginning or end of a word.

Any character following a also has special meanings (like "d" means digit), except for the special characters of course. Thus "." means period, "[" means "[", "?" means "?", etc.

Ironically, <code>grep</code> requires -e in order to use full regular expressions. You can also use <code>egrep</code>, which is the same thing as <code>grep -e</code>.

Here is an example of looking for errors in the system.log file (using the case insensitive switch):

<pre><code>  [Computer:/var/log] james% grep -i error system.log
  Oct  7 14:41:53 Computer cp: error processing extended attributes: Operation not permitted
  Oct  7 16:48:37 Computer kernel[0]: IOAudioStream[0x2b5df00]::clipIfNecessary() - Error: attempting to clip to a position more than one buffer ahead of last clip position (0,a83)-&gt;(1,1d5e).
</code></pre>

-i specifies that the search is case insensitive (default is case sensitive).

Here is an example of searching for the text "NSWindow" recursively in the Apple Developer Examples but only in files that end with ".m".

<pre><code>  [Computer:/Developer/Examples] james% grep -r --include="*.m" NSWindow *
  Accessibility/AXCanvas/CanvasDoc.m:- (void)windowControllerDidLoadNib:(NSWindowController *)aController
  Accessibility/AXCanvas/CanvasInspectorController.m:#pragma mark NSWindowController methods
  Accessibility/AXCanvas/CanvasProxyTabView.m:- (NSWindow *)caxWindowAttribute {
  AppKit/ClockControl/ClockControl.m:    [notifCenter addObserver:self selector:callback name:NSWindowDidBecomeKeyNotification object: [self window]];
  AppKit/ClockControl/ClockControl.m:    [notifCenter addObserver:self selector:callback name:NSWindowDidResignKeyNotification object: [self window]];
  ...
</code></pre>

<p>The following example searches for NSWindow like before, but omits NSWindowController. It does this by taking the output of the first <code>grep</code> and "piping" it to the <code>grep -v</code>, which will remove lines with NSWindowController (see below for more about the pipe "|").</p>

<pre><code>  [Computer:/Developer/Examples] james% grep -r --include="*.m" NSWindow * | grep -v NSWindowController
  Accessibility/AXCanvas/CanvasProxyTabView.m:- (NSWindow *)caxWindowAttribute {
  AppKit/ClockControl/ClockControl.m:    [notifCenter addObserver:self selector:callback name:NSWindowDidBecomeKeyNotification object: [self window]];
  AppKit/ClockControl/ClockControl.m:    [notifCenter addObserver:self selector:callback name:NSWindowDidResignKeyNotification object: [self window]];
  ...
</code></pre>

This version uses the -w option to specify only the word NSWindow.

<pre><code>  [Computer:/Developer/Examples] james% grep -r -w --include="*.m" NSWindow *
  Accessibility/AXCanvas/CanvasProxyTabView.m:- (NSWindow *)caxWindowAttribute {
  AppKit/HexInputServer/HexInputContext.m:    NSWindow *window = [textField window];
  AppKit/Sketch/SKTGridPanelController.m:- (void)setMainWindow:(NSWindow *)mainWindow {
  AppKit/Sketch/SKTInspectorController.m:- (void)setMainWindow:(NSWindow *)mainWindow {
  AppKit/TextEdit/Controller.m:  NSWindow *window = [windows objectAtIndex:count];
  AppKit/TextEdit/Document.m:    NSWindow *window = [scrollView window];
  AppKit/TextEdit/Document.m:  if (same &amp;&amp; updateIcon) [[self window] setTitleWithRepresentedFilename:@""]; // Workaround NSWindow optimization
  AppKit/TextEdit/Document.m:- (NSWindow *)window {
</code></pre>

This next `grep` uses extended grep (`egrep`, which is the same as `grep -e`) to display files that have NSWindow or NSPanel.

<pre><code>  [Computer:/Developer/Examples] james% egrep -r -w --include="*.m" "NS(Window|Panel)" *
  Accessibility/AXCanvas/CanvasProxyTabView.m:- (NSWindow *)caxWindowAttribute {
  AppKit/HexInputServer/HexInputContext.m:    NSWindow *window = [textField window];
  AppKit/HexInputServer/HexInputServer.m:  NSPanel *panel = [[NSPanel allocWithZone:[self zone]] initWithContentRect:NSMakeRect(0, 0, 100, 40) styleMask:NSBorderlessWindowMask|NSUtilityWindowMask backing:NSBackingStoreBuffered defer:YES];
  AppKit/Java/TextEdit/TextFinder.m:- (NSPanel *)findPanel {
  AppKit/Java/TextEdit/TextFinder.m:    return (NSPanel *)[findTextField window];
  AppKit/Java/TextEdit/TextFinder.m:    NSPanel *panel = [self findPanel];
  AppKit/Sketch/SKTGridPanelController.m:- (void)setMainWindow:(NSWindow *)mainWindow {
</code></pre>

<a name="piping"></a>
#### Piping

<p>Piping is when the output of one command is sent to another. So far, the output of every command we have tried so far is just printed to the terminal. By using the pipe character, "|", we can send that output to commands that take input. Here is an example of where that is useful.</p>

A very simple case of piping is when we are looking to see if a particular process is running.

<pre><code>  ps -Aww | grep -i &lt;process name&gt;</code></pre>

For example:

<pre><code>  [Computer:~] james% ps -Aww | grep -i Safari
  2121  ??  S     21:39.47 /Applications/Safari.app/Contents/MacOS/Safari -psn_0_18612225
  5669  p1  R+     0:00.00 grep -i Safari
</code></pre>

Technically, there are 2 processes running with "Safari" as part of the command. One is Safari of course, the other is the very <code>grep</code> command! That is because when <code>ps</code> was running finding processes, so was <code>grep</code>. So <code>ps</code> showed us <code>grep</code> and <code>grep</code> showed itself because it had Safari as part of its command. Kinda like chicken and egg. Anyway, it will always be listed in the process listing, just like <code>top</code> will be when running <code>top</code>.

To remove it <code>grep</code> from the output, use <code>grep -v grep</code>. The "-v" flag says to exclude a pattern. So we are taking the output of the <code>ps</code>, and print anything that has "Safari", then we take that output and print everything unless it has "grep". Like this:

<pre><code>  ps -Aww | grep -i &lt;process name&gt; | grep -v grep</code></pre>

Which produces this:

<pre><code>  [Computer:~] james% ps -Aww | grep -i Safari | grep -v grep
  2121  ??  S     21:53.69 /Applications/Safari.app/Contents/MacOS/Safari -psn_0_18612225
</code></pre>

That's better.

<a name="radmind_grep_example"></a>
#### A radmind grep example

If you aren't a radmind administrator, skip this section. So <code>lapply</code> gave an error that said that the folder "/Library/Application Support/Adobe/StartupScripts" could not be deleted because it was not empty. That means Radmind doesn't think the folder should exist, which happens if no transcripts contain the folder. Naturally, it would have contents if Radmind is told to put files in the folder. Radmind is like that, it wont create folders for you, even if you tell it to put files in the folder.

So we want to find out what transcripts specify files in that location, and we want to double check that at least one of them creates the folder (all of them should really). To do that, we search the files in "/var/radmind/client" for "/Library/Application Support/Adobe/StartupScripts".

First, we need to encode the path in such a way that <code>grep</code> can actually find it. Replace the space with "" because that is how radmind transcripts encode spaces. Escape the backslash "" in "" since it is a <code>grep</code> special character, so it becomes "". That results in "/Library/ApplicationSupport/Adobe/StartupScripts". We will put quotes around it because the shell interprets "" also. By putting quotes around it, you are telling shell just give it to grep unaltered.

So recursively search for the text and only print out transcript filenames:

<pre><code>  grep -lr "/Library/ApplicationSupport/Adobe/StartupScripts" /var/radmind/client</code></pre>

If you run this command, you will see all the transcripts that specify files in that location. Now we want to find out if one of them actually creates the folder. Do this by leaving out the "-l" flag so <code>grep</code> prints out every text match, like this:

<pre><code>  grep -r "/Library/ApplicationSupport/Adobe/StartupScripts" /var/radmind/client</code></pre>

But then exclude everything that has the folder separator character after the word "StartupScripts", like this:

<pre><code>  grep -v "StartupScripts/"</code></pre>

The line that creates the folder wont have the separator character after the name, so this should only print lines creating the folder:

<pre><code>  grep -r "/Library/ApplicationSupport/Adobe/StartupScripts" /var/radmind/client | grep -v "StartupScripts/"</code></pre>

Considering we got the error we did, we probably wont see anything! That is how we would know it isn't specified in any transcript! This is an easy mistake to make when updating overloads. To fix it, go to the server and execute the first <code>grep</code> (except search in "/var/radmind/transcript"), and add the directory to one or all of the transcripts.

<a name="what_next"></a>
#### What next?

I've pretty much covered everything the Finder can do, except burning CD's, and I've never done that from the command line, and I don't really feel like trying to figure it out (my ISP is currently down, and well, I didn't know all of this stuff off the top of my head ya know). And I'm not sure if it is possible from the command line to set the "Open with..." attribute of a file. I'm not sure that is possible.

So there you are! Who says we need a new Finder? You no longer need to use it!

Where to go next? How about learn everything there is to know about commands!
