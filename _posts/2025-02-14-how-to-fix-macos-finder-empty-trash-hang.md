---
layout:     default
title:      How to Fix macOS Finder Empty Trash Hang
date:       2025-02-14
editdate:   2025-02-21
categories: MacAdmin
disqus_id:  how-to-fix-macos-finder-empty-trash-hang.html
---

I'm still on macOS 13 Ventura. For a very long time now, my macOS Finder Empty Trash hangs. I've tried all the old tricks (any old websearch shows those). Nothing worked. I didn't want to create a new user folder. If I cancel the empty trash then it finally empties. So I've lived with it.

Today I finally fixed it! I ran this:

```
lsof | grep Trash
```

And what do you know? Some process has /Users/james/.Trash/iPhotoLibrary (or something like that) open. Well, that file doesn't exist. So I tried to `kill` it. But it didn't die so I `kill -9` it. Trash empties! And what's even better? It doesn't hang anymore! Yay!

## Update 1 (2025-02-21)

It happened to me again! But now I know how to fix it! I decided to try to figure out more what is going on. I ran `lsof` again and this is the process that's hanging it.

```
sudo lsof | grep Trash
filecoord   913               root   27r      DIR               1,13         256           208863238 /Users/james/.Trash/Photos Library.photoslibrary
filecoord   913               root   28r      DIR               1,13        7808           115826471 /Users/james/.Trash
```

Turns out that ".Trash/Photos Library.photoslibrary" exists! Why is ".Trash/Photos Library.photoslibrary" in the trash? I didn't put that there. In fact, I don't even use Photos. And I don't use ~/Pictures. There's nothing in that folder (except a .DS_Store). In fact, I hide that folder (`chflags hidden ~/Pictures`). Could that be why this is happening? It would be strange if it was.

What is `filecoord`? Well, it's `/usr/sbin/filecoordinationd`. What is that? Well, it has a man page. And boy, you have to love Apple's man pages.

```
filecoordinationd(8)        System Manager's Manual       filecoordinationd(8)

NAME
     filecoordinationd – system-wide file access coordination

SYNOPSIS
     filecoordinationd

DESCRIPTION
     filecoordinationd is used by the Foundation framework's NSFileCoordinator
     class to coordinate access to files by multiple processes, and to message
     registered NSFilePresenters.

     There are no configuration options to filecoordinationd. Users should not
     run filecoordinationd manually.

Mac OS X                        March 15, 2011                        Mac OS X
```

That tells you everything you need to know. I guess the [NSFileCoordinator](https://developer.apple.com/documentation/foundation/nsfilecoordinator) actually is good docs. Here's a quote (emphasis is mine):

> You use instances of this class as is to read from, write to, modify the attributes of, change the location of, or **delete a file or directory**, but before your code to perform those actions executes, the **file coordinator lets registered file presenter objects perform any tasks that they might require to ensure their own integrity**.

So basically, filecoordinationd is letting something perform actions on "Photos Library.photoslibrary" before "Empty Trash" deletes it. Wonderful.

Can I uninstall Photos?

```
> mdfind Photos.app
2025-02-21 09:04:47.475 mdfind[38171:1101942] [UserQueryParser] Loading keywords and predicates for locale "en_US"
2025-02-21 09:04:47.475 mdfind[38171:1101942] [UserQueryParser] Loading keywords and predicates for locale "en"
/System/Applications/Photos.app
> rm -rf /System/Applications/Photos.app
rm: /System/Applications/Photos.app/Contents/_CodeSignature/CodeResources: Operation not permitted
rm: /System/Applications/Photos.app/Contents/_CodeSignature: Operation not permitted
rm: /System/Applications/Photos.app/Contents/MacOS/PhotosRelauncher: Operation not permitted
rm: /System/Applications/Photos.app/Contents/MacOS/Photos: Operation not permitted
rm: /System/Applications/Photos.app/Contents/MacOS: Operation not permitted
...
```

"Operation not permitted" always means SIPS (Apple's manditory access control). "Permssion denied" always means Unix file permissions. So it turns out that /System is immutable. I guess I can't uninstall it. Shucks. (I actually knew that already, I'm just being ornery)

Last sarcastic side note. Don't you just love how `mdfind` **ALWAYS** prints those "UserQueryParser" messages now? Maybe someone should've told Apple it's a regression before it got baked into the OS as a now permanent "feature." I'm using Ventura (yes, I know, I'm slow to upgrade). But I just checked Seqoia and it's still there. Wonderful.
