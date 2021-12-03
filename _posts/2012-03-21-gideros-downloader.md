---
layout:     default
title:      "Gideros Downloader"
date:       2012-03-21
editdate:   2020-05-11
categories: Graveyard
disqus_id:  gideros-downloader.html
render_with_liquid: false
---

[Updated 2012-05-10 with UrlLoader, compatible with Gideros 2012.2.2 and later]

[Updated 2012-11-01: If you think "live coding" is awesome, you really need to check out [ZeroBrane Studio](http://studio.zerobrane.com), in particular, [this video](http://notebook.kulchenko.com/zerobrane/live-coding-in-lua-bret-victor-style)]

Want to run an iPhone (or Android device) app built with Gideros Studio (developer account required) and simultaneously change it's source code and have those changes affect the running app (aka "live coding")?  This also allows you to edit on an iPad using Textastic or other Dropbox capable editor and immediately run the code on an iPhone.  I've been doing this and it works great.

By the way, you should never try to get an app on the AppStore that does this.  It's one of the the main reasons the AppStore is curated, to prevent this.  If you did it and got it past the reviewers, you'd likely have your developer account revoked when caught.  Only do this on your iPhone using Xcode and your own developer account.

Here is a video showing this in action.

<iframe width="560" height="315" src="http://www.youtube.com/embed/LSs_mIzXQDU" frameborder="0" allowfullscreen></iframe>

[Clarification about putting "this" on Apple's AppStore: you may put Gideros apps on Apple's AppStore, you just can't put this downloader app on Apple's AppStore because it downloads and executes code and Apple doesn't allow that.]

Here are the current instructions.

- Put the code below in a [Gideros Studio](http://www.giderosmobile.com) project.
- Put a file on some webserver (like your [Dropbox](http://www.dropbox.com) Public folder).
- Get the link to the file (use the Dropbox website).
- Find `downloadURLs` in the code and put your url there.
- If you need to download other images, put the url's in `downloadURLs`.
- Find `loader = FileLoader.new(downloadURLs, "main.lua")` and replace `main.lua` with the file you want to run.
- Export the project and put it on your device.
- Run the app on your mobile device.

Here is the code (Note, this version uses UrlLoader and is compatible with Gideros 2012.2.2 and later).

    function exists(fname)
        local f = io.open(fname, "r")
        if (f and f:read()) then return true end
    end
    FileLoader = Core.class()
    function FileLoader:onComplete(event)
        local out = io.open("|D|"..self.currentFilename, "wb")
        out:write(event.data)
        out:close()
        self.info:setText(self.currentFilename.." downloaded")
        print(self.currentURL.." downloaded")
        self:step()
    end
    function FileLoader:onError()
        self.info:setText("error downloading "..self.currentFilename)
        print("error downloading "..self.currentURL)
    end
    function FileLoader:onProgress(event)
        self.info:setText("progress: " .. event.bytesLoaded .. " of " .. event.bytesTotal)
        print("progress: " .. event.bytesLoaded .. " of " .. event.bytesTotal)
    end
    function FileLoader:step()
        if ( table.getn(self.urls) >= self.currentDownload ) then
            self.currentURL = self.urls[self.currentDownload]
            self.currentDownload = self.currentDownload +1
            self.currentFilename = string.match(self.currentURL, ".*/(.*)" )
            local download = not exists("|D|"..self.currentFilename)
            download = true
            if download then
                self.info:setText("loading "..self.currentFilename)
                print("loading "..self.currentURL)
                self.loader = UrlLoader.new(self.currentURL)
                self.loader:addEventListener(Event.COMPLETE, self.onComplete, self)
                self.loader:addEventListener(Event.ERROR, self.onError, self)
                self.loader:addEventListener(Event.PROGRESS, self.onProgress, self)
            else
                self.info:setText(self.currentFilename.." exists")
                self:step()
            end
        else
            success, error = pcall( function() dofile("|D|"..self.dofile) end )
            if ( success ) then
                self.info:setText("")
            else
                self.info:setText(error)
            end
        end
    end
    function FileLoader:init(urls, dofile)
        self.urls = urls
        self.finishedUrls = {}
        self.dofile = dofile
        self.info = TextField.new(nil, "")
        self.info:setPosition(10, 10)
        stage:addChild(self.info)
    end
    function FileLoader:start()
        self.info:setText("loading files...")
        self.currentDownload = 1
        self:step()
    end
    --------------------------------------------------
    Texture.oldNew = Texture.new
    function Texture.new(filename, filtering, options)
        if exists(filename) then
            return Texture.oldNew(filename, filtering, options)
        elseif exists("|D|"..filename) then
            return Texture.oldNew("|D|"..filename, filtering, options)
        else
            return nil
        end
    end
    --------------------------------------------------

    local downloadURLs = {
        "http://dl.dropbox.com/u/1234yourid/main.lua",
    }

    application:setOrientation(Application.LANDSCAPE_LEFT)

    seconds = 0 -- 0 doesn't reload
    repeatCount = 1
    loader = FileLoader.new(downloadURLs, "main.lua")

    loader:start()
    if seconds > 0 then
        local timer = Timer.new(seconds * 1000, 0)
        local function onTimer(event)
            repeatCount = repeatCount + 1
            loader:start()
        end
        timer:addEventListener(Event.TIMER, onTimer)
        timer:start()
    end

When you run the app it will show that it is downloading the file(s) and run them.  Every 2 seconds it will download your file(s) again and run them again.  The state of the downloaded file is maintained each time it is downloaded, so variables hold their values from the previous time.  You have to write the downloaded file a certain way for it not to stomp on itself.  Here is a basic example of a file you could download.

    if ( myinfo == nil ) then
        myinfo = TextField.new(nil, "loading files...")
        myinfo:setPosition(10, 30)
        stage:addChild(myinfo)
    end
    myinfo:setText("current repeat: "..repeatCount)

Notice it has a first run check by seeing if the myinfo variable is nil or not.  Then the code below it will run every time that it is downloaded.

Normally in a Gideros app you will have everything happening inside of an event handler.  So I wanted to see how this worked with that.  Because addEventListener keeps a reference to the function, if you redefine the function, the event listener will keep the old one around.  So you need to remove it and then re-add the new one.  Here's an example.

 [Updated: March 25, 2012 - had to move `stage:removeEventListener()` to the top before `onEnterFrame()` is redefined so that it works right.]

    if ( firstime ~= nil ) then
        stage:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
    end

    function onEnterFrame(event)
        x = oh:getX()
        if x > width or x < 0 then
            oh.directionX = -oh.directionX
        end
        oh:setPosition(x+oh.speed*oh.directionX, height/4)
    end

    if ( firstime == nil ) then
        firstime = 1
        width = application:getContentWidth()
        height = application:getContentHeight()
        oh = TextField.new(nil, "O")
        oh.directionX = 1
        stage:addChild(oh)
        stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
        oh.speed = 3
    else
        stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
    end

Enjoy, I'm going to have a lot of fun with this.
