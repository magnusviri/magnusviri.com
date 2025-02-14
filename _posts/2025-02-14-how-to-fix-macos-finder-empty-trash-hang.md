---
layout:     default
title:      How to Fix macOS Finder Empty Trash Hang
date:       2025-02-14
editdate:   2025-02-14
categories: MacAdmin
disqus_id:  how-to-fix-macos-finder-empty-trash-hang.html
---

I'm still on macOS 13 Ventura. For a very long time now, my macOS Finder Empty Trash hangs. I've tried all the old tricks (any old websearch shows those). Nothing worked. I didn't want to create a new user folder. If I cancel the empty trash then it finally empties. So I've lived with it.

Today I finally fixed it! I ran this:

```
lsof | grep Trash
```

And what do you know? Some process has /Users/james/.Trash/iPhotoLibrary (or something like that) open. Well, that file doesn't exist. So I tried to `kill` it. But it didn't die so I `kill -9` it. Trash empties! And what's even better? It doesn't hang anymore! Yay!
