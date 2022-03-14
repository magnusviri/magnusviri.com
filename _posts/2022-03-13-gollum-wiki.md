---
layout:     default
title:      Gollum Wiki
date:       2022-03-13
editdate:   2022-03-13
categories: Sysadmin
disqus_id:  gollum-wiki.html
---

## What is Gollum?

[Gollum](https://github.com/gollum/gollum) is a simple wiki system written in Ruby that stores everything in a git repo. It was originally written by and for GitHub for their wiki system but they have diverged. Gollum now "strives" to be compatible with GitHub wikis. There are other similar wiki projects. I don't remember why, but I picked Gollum over them.

The built-in web interface allows you to edit pages and preview the edits before saving. It also allows you to browse the history, compare, and revert versions. You can also edit the git repo using any text editor, but you have to `git add` and `git commit` yourself.

### Gollum features:

- Markdown, AsciiDoc, Creole, MediaWiki, and more (some require installing renderers).
- Keyboard shortcuts (e for edit, cmd-s for save, cntl-shift-p for preview).
- YAML Frontmatter for controlling per-page settings.
- Headers, footers, and sidebars.
- [Macros](https://github.com/gollum/gollum/wiki/Standard-Macros) (like TOC and Navigation).
- [Redirects](https://github.com/gollum/gollum/wiki#redirects).
- [RSS Feed](https://github.com/gollum/gollum/wiki/5.0-release-notes#rss-feed) of latest changes.
- Recovered text if edit window is modified and closed without saving.
- [UML diagrams](https://github.com/gollum/gollum/wiki#plantuml-diagrams).
- [BibTeX and Citation support](https://github.com/gollum/gollum/wiki/BibTeX-and-Citations).
- Annotations using [CriticMarkup](https://github.com/gollum/gollum/wiki#criticmarkup-annotations).
- Mathematics via [MathJax](https://github.com/gollum/gollum/wiki#mathematics).
- Support for Right-To-Left Languages.

## Running Gollum

Gollum can be run many ways, but I prefer Docker. If you have Docker installed, this command will install and run Gollum.

    docker run --rm -p 4567:4567 -v $(pwd):/wiki gollumwiki/gollum:master

It can then be accessed in a web browser by going to [http://localhost:4567](http://localhost:4567).

Running Gollum means running a webserver. Gollum does not include any authorization or authentication. This means that anyone can connect to your computer to edit your wiki! To avoid this, I use the Murus Lite firewall and I just firewall the port.

There are also many 3rd party docker images for Gollum, at least one has basic auth support.

## Why I got interested in Gollum

I've used macOS Notes for a long time. It didn't do everything I wanted. As I used it I came up with a feature wish list.

- Within my price range (i.e. I can pay with time instead of money)
- Let's me use Markdown for styles and embed images
- Let's me link to files (images, pdfs)
- Let's me link between my notes
- Hierarchical folder structure
- Version history
- Syncs between devices
- Cross platform

A few times I've tried to find an app that meets all of these criteria. Here's what I found.

### Notes app

- iCloud sync to my iPhone is great, but I don't login to iCloud on my work computer, so not so great there. It's also hard to share all the notes with someone else.
- No version history.
- No linking.
- Not cross platform.
- Only one folder level.
- No Markdown, and in fact it auto-indents lines that start with "-", "*", or "1.", a real pain if you're writing Markdown.
- It's possible to accidentally disappear notes by selecting all the text, typing a random key, and then switching notes (this has actually happened to me too many times, a byproduct of my sloppy fast typing and using of lots of keyboard shortcuts).

### Joplin app

- The promise looked good but I ran into bugs in it's undo history because I use undo and redo a lot. My strange typing habits caused me to lose data fast. I didn't stay long.

### Text files, text editors, and Dropbox

- Dropbox version history only lasts so long (of course, now I realize I could've just turned my notes folder into a git repo).
- I tried BBEdit, MacDown, and Marked. I don't really like how any of them work with Markdown (I think Marked is great, but there was still something about the setup).
- TextAdept with a Markdown module was my preferred editor, and it is cross platform, but it lacked so many Mac keyboard shortcuts and required a lot of modifications. I've quit using it since I've found Gollum.
- Text editors don't support linking.
- Most text editors don't have inline image support.
- I've learned of other text editors, but I found Gollum first so I haven't tried them.

### Gollum

- Met all of my requirements.
- Switching between an editor and a rendered view, like how webpage work, has actually been easiest for me.
- I tried storing the files on a smb server, but this is git, I just decided to store the files locally and `git push` them to a GitLab server.
- An extra bonus I didn't anticipate was that GitLab rendered the Markdown files and allowed my coworker to edit them without having to mess with Gollum. Some of Gollums features like macros obviously didn't work with GitLab. And we figured out all links must be absolute from / to work with both Gollum and GitLab.
- I put the local files in my Dropbox folder so it would sync to my iPhone.
- I can edit the local files with BBEdit, MacDown, and use Marked just like the previous option. Doing manual edits meant I had to `git add` and `git commit` myself. If I didn't do this, Gollum would overwrite any local changes. So beware of that.
- Runs in Docker, so installing and running was a breeze.
- The web page editor actually has some good features like column selection, cmd-/ for commenting, tabbing content, etc.

## Contributing

Because it's a github repo, I was able to contribute by adding some code that gets the git username and uses that instead of making all edits Anonymous.

There's a few features I'd like to add to Gollum. I'd like cmd-s to force a commit message before saving. And I'd like esc to cancel editing. I've also added a feature request for a [.gollumignore](https://github.com/gollum/gollum/issues/1810) file.

## Wrap-up

I've been moving all of my notes to Gollum and haven't had any issues and only like it more and more. I have 2 Gollum servers running on my laptop (I used docker-compose to auto run them after a restart). One is a shared work wiki that I sync with GitLab and the other is for my personal work notes that I keep in Dropbox.

I actually ran Gollum with my Jekyll website as the wiki root and it actually worked. I may end up using Gollum to edit the Markdown source for my Jekyll website. Intersting times.