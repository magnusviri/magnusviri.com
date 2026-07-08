---
layout:     default
title:      macOS defaults
date:       2026-06-04
editdate:   2026-06-04
categories: MacAdmin
---


## Change the spacing of the system menu items (on the top right of the screen)

From [9to5mac.com](https://9to5mac.com/2026/05/22/how-to-stop-menu-bar-items-being-hidden-behind-the-macbook-pro-notch/).

```
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 8
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8
```

Log out and log in.

Undo

```
defaults -currentHost delete -globalDomain NSStatusItemSpacing
defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
```
