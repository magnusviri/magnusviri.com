---
layout:     default
title:      "Mobile Game Programming Lesson 6"
date:       2012-08-02
editdate:   2020-05-11
categories: Graveyard
disqus_id:  mobile-game-programming-lesson-6.html
---

## Interacting with the Game

We've looked at a single touch button.  This chapter will focus on other ways of interacting with a game.  Some games have you touch the screen or buttons.  Some have you drag objects.  Sometimes you tilt the mobile device like a steering wheel.  Sometimes you use a virtual joystick.  We will look at all of the examples and so this will be very example heavy.  Be sure to copy and paste each example into Gideros Studio and try it out so you can see what each example does.  It's easier to see it then to read about it.  We wont discuss the details of each example, just explain the basics.  Don't try to understand the details if you don't need to.  When you need to, then come back and figure out the details by examining the examples and changing the code to see what changes.

Events
--------------------

All user interaction is handled by events.  Many things generate events.  Gideros displays 60 frames a second even if your app doesn't do anything and right before every frame is generated it creates an event.  When the screen is touched an event is generated.  You can create timers and when they fire they generate an event.  There are many more events that you will encounter as you write your app.

Events are ignored unless you use addEventListener() to link an event to a function.  It takes 2 parameters and an optional 3rd parameter.  The first parameter is the name of the event.  The second is the name of the function that should run when the event occurs, called the event handler.  The optional third parameter is data that you can pass to the event handler.

Normally every event handler is executed when a specific event happens.  Touch events are different than other events for a good reason.  For example, if you have a button and you touch it you don't want every button on the screen to run it's event handler, only the button you touched.  So with touch events you usually check to see if the touch was inside of the button and if it is then you do what the button is suppose to do and then you call Event:stopPropagation().  Let's look at this now.

Any Touch
---------------

If we just wanted to know of any touch anywhere on the screen we use simply use `stage:addEventListener()` and an event handler.

    local textfield = TextField.new(nil,"Touch/click the screen")
    function anyTouch(event)
        textfield:setText(tostring(event.x)..", "..tostring(event.y))
    end
    textfield:setPosition(10,20)
    stage:addChild(textfield)
    stage:addEventListener(Event.MOUSE_DOWN, anyTouch)

In this case, we need to put the `local textfield = ...` above the `function anyTouch(event)` because anyTouch() references textfield and if it doesn't exist yet it will get an error.  One solution is to give addEventListner() the textfield and to use the textfield in the anyTouch() argument list like this.

    function anyTouch(textfield, event)
        textfield:setText(tostring(event.x)..", "..tostring(event.y))
    end
    local textfield = TextField.new(nil,"Touch/click the screen")
    textfield:setPosition(10,20)
    stage:addChild(textfield)
    stage:addEventListener(Event.MOUSE_DOWN, anyTouch, textfield)

Touch Buttons
-----------

Most buttons will use graphic images.  Images look better and it's easier to control their size.  For the purpose of learning how buttons work we will just use TextFields for a little bit.

First let's look at how events are sent to sprites.  This code will display fractions of each second that the onTouch() is executed.  Events are sent to the sprite last added to the scene.  The order isn't really that important, but it is helpful to know.

    function TextField:onTouch(event)
        local tinytime = os.timer()*1000
        tinytime = math.floor((tinytime-math.floor(tinytime))*100)
        self:setText(tostring(tinytime))
    end

    for ii=1,4 do
        local textfield = TextField.new(nil,"Here "..tostring(ii))
        textfield:addEventListener(Event.MOUSE_DOWN, TextField.onTouch, textfield)
        textfield:setPosition(ii*40-20,ii*40-10)
        stage:addChild(textfield)
    end

The proper way to handle touch events is to check to see if the touch was inside of the sprite bounds by using hitTestPoint() and then use event:stopPropagation().  Try this example and see what it does.

    function TextField:onTouch(event)
        local tinytime = os.timer()*1000
        tinytime = math.floor((tinytime-math.floor(tinytime))*100)
        if self:hitTestPoint(event.x, event.y) then
            self:setText("Clicked "..tostring(tinytime))
            event:stopPropagation()
        else
            self:setText("Missed "..tostring(tinytime))
        end
    end

    for ii=1,4 do
        local textfield = TextField.new(nil,"Here "..tostring(ii))
        textfield:addEventListener(Event.MOUSE_DOWN, TextField.onTouch, textfield)
        textfield:setPosition(ii*40-20,ii*40-10)
        stage:addChild(textfield)
    end

Even with event:stopPropagation() many onTouch() event handlers execute.  So you shouldn't do anything in touch event handlers unless it is inside of a hitTestPoint().  In this case we show if it misses but you shouldn't do that normally.  Comment that part out to see what it does.

Toggle Button
-------------

If you wanted to turn your button into a toggle button you would want to remember if it is up or down and change the state when the button is pressed.

    function TextField:onTouch(event)
        if self:hitTestPoint(event.x, event.y) then
            if self.pushed then
                self:setText("Off")
                self.pushed = false
            else
                self:setText("On")
                self.pushed = true
            end
            event:stopPropagation()
        end
    end

    for ii=1,4 do
        local textfield = TextField.new(nil,"Off")
        textfield.pushed = false
        textfield:addEventListener(Event.MOUSE_DOWN, TextField.onTouch, textfield)
        textfield:setPosition(ii*40-20,ii*40-10)
        stage:addChild(textfield)
    end

Instant Multi-Tap
-----------

If you want to find a double tap, you need to remember the time the button was touched the first time.  The next time it is touched you need to compare the two touch times.  If the difference in time is small enough (about .2 to .5 seconds) you know it was a double tap.

However, how do you know on first touch if it is going to be a double tap or single tap?  There are two ways to do it.  You can either always do the single tap action (like selecting a character) and if the double tap occurs you do the next action (like select everything on the screen).  This method is easier and more has an instant response.  I'll describe the other method in the next section.

To find out if a tap is double and triple you just keep a counter of taps.  Since the difference between a double tap and a triple tap is so small, I'm actually including the code to do multiple taps.

    function TextField:onTouch(event)
        if self:hitTestPoint(event.x, event.y) then
            local lastTouchTime = self.touchTime
            self.touchTime = os.timer()
            if self.touchTime - lastTouchTime < self.maxDelay then
                self.touchCount = self.touchCount + 1
            else
                self.touchCount = 1
            end
            self:setText("Taps: "..tostring(self.touchCount).." times ("..tostring(self.touchTime - lastTouchTime)..")")
            if self.touchCount == 1 then
                -- single tap actions here
            elseif self.touchCount == 2 then
                -- double tap actions here
            elseif self.touchCount == 3 then
                -- triple tap actions here
                -- since we don't care about more than this we need to reset the counter
                self.touchCount = 0
            end
            event:stopPropagation()
        end
    end
    for ii=1,4 do
        local textfield = TextField.new(nil,"Here "..tostring(ii))
        textfield:addEventListener(Event.MOUSE_DOWN, TextField.onTouch, textfield)
        textfield:setPosition(ii*40-20,ii*40-10)
        textfield.touchTime = 0
        textfield.touchCount = 0
        textfield.maxDelay = 0.5
        stage:addChild(textfield)
    end

Delayed Multi-Tap
-----------

The other way to do multi-taps is every time there is a single tap you wait and after .5 seconds if a second tap doesn't occur then the single tap action is executed.  If while waiting a second tap occurs, you wait to see if a third tap occurs and if not, you execute the double tap action.

You need to use a delayed double tap when the single tap and the double tap behaviors are totally different.  For example, on an iPhone or other iOS device pressing the home button takes you to the home screen.  If you double press the home button the application switcher appears.  These behaviors are totally different so it wouldn't make sense to perform the actions instantly.  If you have an iOS device you can try this out and you will notice there is a delay when you press the home button because it's waiting to see if you press it again.

This is how you would implement a delayed multi-tap.

    function TextField:onTimer(event)
        self:setText("Taps: "..tostring(self.touchCount).." times ("..tostring(self.touchTime )..")")
        if self.touchCount == 1 then
            -- single tap actions here
        elseif self.touchCount == 2 then
            -- double tap actions here
        elseif self.touchCount == 3 then
            -- triple tap actions here
        end
    end
    function TextField:onTouch(event)
        if self:hitTestPoint(event.x, event.y) then
            local lastTouchTime = self.touchTime
            self.touchTime = os.timer()
            if self.touchTime - lastTouchTime < self.maxDelay then
                self.touchCount = self.touchCount + 1
            else
                self.touchCount = 1
            end
            if self.touchCount == 3 then
                -- since we don't care about more than this we need to reset the counter and run the timer event handler
                self.timer:stop()
                self:onTimer(event)
                self.touchCount = 0
            else
                self.timer:start()
            end
            event:stopPropagation()
        end
    end
    for ii=1,4 do
        local textfield = TextField.new(nil,"Here "..tostring(ii))
        textfield:addEventListener(Event.MOUSE_DOWN, TextField.onTouch, textfield)
        textfield:setPosition(ii*40-20,ii*40-10)
        textfield.touchTime = 0
        textfield.touchCount = 0
        textfield.maxDelay = 0.5
        textfield.timer = Timer.new(500, 1)
        textfield.timer:addEventListener(Event.TIMER, textfield.onTimer, textfield)
        stage:addChild(textfield)
    end

This is a lot of code for a simple button.  But this is what it takes.  The good thing is that once you have the code, you don't need to modify it too much.  Right now this code is mostly for demonstrations purposes.  Later on we will look at an all purpose button that is very easy to use.

Press and Hold
--------------

Press and hold is very similar to a delayed double tap.  In press and hold you need to create a timer every time a tap occurs. There are 2 things that can happen.  Either the finger is lifted and the timer is canceled (so it wont execute), or the timer fires and we know the user has been holding the finger down.  To find out if the finger is lifted you listen for Event.MOUSE_UP.

    function TextField:onTimer(event)
        self:setText("Held at: "..tostring(os.timer()))
    end
    function TextField:onTouchUp(event)
        if self:hitTestPoint(event.x, event.y) then
            self.timer:stop()
            self:setText("Up at: "..tostring(os.timer()))
            event:stopPropagation()
        end
    end
    function TextField:onTouchDown(event)
        if self:hitTestPoint(event.x, event.y) then
            self.timer:start()
            self:setText("Tapped at: "..tostring(os.timer()))
            event:stopPropagation()
        end
    end
    for ii=1,4 do
        local textfield = TextField.new(nil,"Here "..tostring(ii))
        textfield:addEventListener(Event.MOUSE_DOWN, TextField.onTouchDown, textfield)
        textfield:addEventListener(Event.MOUSE_UP, TextField.onTouchUp, textfield)
        textfield:setPosition(ii*40-20,ii*40-10)
        textfield.touchTime = 0
        textfield.holdTime = 2.0
        textfield.timer = Timer.new(2000, 1)
        textfield.timer:addEventListener(Event.TIMER, textfield.onTimer, textfield)
        stage:addChild(textfield)
    end

Button with Graphics
---------------

This example comes with Gideros Studio.  Find "Examples/Graphics/Button" and open that project. This button is much more like the graphical buttons you see in iOS or Android.  This example actually puts all of the button logic in a single file named "button.lua".  Earlier in the lesson I mentioned that we will find an easier way to use buttons and this is how.  We don't even need to know how button.lua works.  In our main.lua file, we just use this code to use a button (I've removed the click counter code).

    local up = Bitmap.new(Texture.new("button_up.png"))
    local down = Bitmap.new(Texture.new("button_down.png"))

    -- create the button
    local button = Button.new(up, down)

    -- register to "click" event
    button:addEventListener("click",
        function()
            -- our event handler
        end)

    button:setPosition(40, 150)
    stage:addChild(button)

This example shows several things.  First, we now have an easy to use button.  The button doesn't actually do anything until you lift your finger up from the button.  The purpose of this is so that if you press a button and you decide you touched the wrong button, you can move your finger off and the button wont do anything.

Second, our event handler looks a lot different than any event handler before.  It turns out that any time a function is expected, like `button:addEventListener("click", function)` we can replace "function" with `function() code goes here end`

Third, we are listening for the event "click".  Where did this event name come from?  If you look in button.lua you will notice in the function `Button:onMouseUp(event)` you will see this code: `self:dispatchEvent(Event.new("click"))`.  That code generates an event and that is what makes the button work!  This is the first time we've seen anything actually generate an event, and it is actually that easy.  The reason for doing this is because it makes it easy for one object to let something else know that something happened.  In this case it is a button being pressed, but when we are making games we would also want to use it to notify of all sorts of events, like your character died, or you won the game!

Drag Me Example
------

We've looked at buttons a great deal.  What about moving a sprite with your finger?  Let's look at another Gideros Studio example project.  Open "Graphics/Drag Me/main.lua" and go to the bottom of the file and look for the for loop that creates 5 shapes with event handlers.

After the code creates each shape it listens for `Event.MOUSE_DOWN`, `Event.MOUSE_MOVE`, and `Event.MOUSE_UP`.  In the mouse down event handler `onMouseDown()` it executes `self:hitTestPoint()` to make sure that the finger was pressed down inside of the sprite.  If true it sets a variable named isFocus to true.  We also save the current location of the finger to variables named x0 and y0.

    self.isFocus = true

    self.x0 = event.x
    self.y0 = event.y

Then inside of the touches moved event handler, `onTouchesMove()`, unlike the mouse down event handler it doesn't use the hitTestPoint method but it checks to see if isFocus is true.  The reason for this is because if the finger moves outside of the sprite hit test bounds it wants the sprite to move instead of do nothing.  But it still needs to make sure it doesn't move every sprite, so it still needs to check something to make sure we have the right sprite.  That's what isFocus is for.

Now, there are two ways to move a sprite with our finger.  The first way is to just set the sprite's position to the position of the finder.  The other way is to find out how far the finger moves and to move the sprite the same amount.  This example uses the second method.

To find how far the finger has moved we first save the location of the finger when it first touched the screen in the mouse down event handler (x0 and y0).  In the mouse moved event handler we find the how far the finger moves, the delta or change, by subtracting the first finger location (x0 and y0) with the current finger position (event.x and event.y).  Then we add the delta to the current sprite location.  That's how far the finger has moved!  Then, in case we want to keep moving our finger, we update x0 and y0 with the current location so the next time the finger moves it will use this new position.

    local dx = event.x - self.x0
    local dy = event.y - self.y0

    self:setX(self:getX() + dx)
    self:setY(self:getY() + dy)

    self.x0 = event.x
    self.y0 = event.y

Then in the mouse up hander `onMouseUp()` we release focus.

    self.isFocus = false

That's what we need to do to move a sprite.  There's one more addition we can make to this code.  You might notice that if you put one sprite on top of another that one always stays on top.  You can change the order quickly by removing the sprite and then adding it back.  These three lines of code will do exactly that if you add it to the onMouseDown() event handler.  Try it out.

        local parent = self:getParent()
        self:removeFromParent()
        parent:addChild(self)

Touch Explorer Example - Multiple Touches
-------------------

If you already haven't, and if you can, run the Drag Me example on a mobile device right now.  It should behave exactly like it does on the desktop.  But on a device you will notice something very important, you can only drag one rectangle at a time.  How is that possible?

It turns out that Event.MOUSE_DOWN, Event.MOUSE_MOVE, and Event.MOUSE_UP only accept one touch, the first touch.  That's why they are named "MOUSE" events, because they behave like a desktop mouse, which only allows one pointer.  However, on a mobile device, sometimes that isn't good enough, you want to know the location of all touches.

To see how multi-touches are handled open up the Gideros "Hardware/Touch Explorer" example and run that project on a mobile device if you can.  You will notice that nothing displays until you press your finger on the screen and a colored dot with a number on it moves where ever you move your finger.  If you put a second finger down a second dot with a 2 will appear beneath it.  All dots will follow each finger when moved.  If you lift the first finger the dot under the second finger will still say 2.  So it remembers which finder is which.

Let's figure out how this code works.  Open the find file "Hardware/Touch Explorer/main.lua" and look at it really quick.  You'll see it adds a text field, declares some functions, creates the bitmaps, then declares more functions.  Don't look at any of the function declarations, skip them all and get to the bottom.  At the bottom you see that we add 4 event listeners.

    stage:addEventListener(Event.TOUCHES_BEGIN, onTouchesBegin)
    stage:addEventListener(Event.TOUCHES_MOVE, onTouchesMove)
    stage:addEventListener(Event.TOUCHES_END, onTouchesEnd)
    stage:addEventListener(Event.TOUCHES_CANCEL, onTouchesCancel)

All 4 of these event listeners need to be added in order to handle multiple touches.  And you need to have 4 functions to handle the events as well.

Now look at `onTouchesBegin()`.  The important code is `event.touch.id`.  Every event has a touch and each one of those has an id.  The id stores a number from 1 to 5 representing a particular touch.  The first touch will be 1, the second 2, the third 3, etc.,.  If you put 3 fingers down and then lift the first finger then the id's of 2 and 3 will not change.  The next touch down will be next lowest number, in this case 1.  Either way, the important thing to remember is that the touch id is how it keeps track of which touch is which.

The Drag Me example calculated how far a finger moved and moved the sprite the same amount.  This Touch Explorer example uses the other way.  Touch Explorer just finds the location of the finger and moves the center of the dot to the finger position.

Accelerometer Example
------

This example will only run on a real device.

The example in Hardware/Accelerometer shows filtering and basic usage of the accelerometer.  Filtering is required because the raw values of the accelerometer is very chaotic.  To figure out where something like gravity is, you need to add up all of the values and take the average of the values.  If you want to find out if a shake is happening, you need to do the exact opposite.

Here is another accelerometer example showing you the raw values and it has some code that allows you to control a sprite's position with the accelerometer.

    require "accelerometer"

    accelerometer:start()

    local dotO = TextField.new(nil, "O")
    stage:addChild(dotO)

    local dotX = TextField.new(nil, "X")
    stage:addChild(dotX)

    local filter = 0.1 -- the filtering constant, 1.0 means no filtering, lower values mean more filtering
    local fx, fy, fz = 0, 0, 0

    local x_accel = TextField.new(nil, "")
    local y_accel = TextField.new(nil, "")
    local z_accel = TextField.new(nil, "")
    local fx_accel = TextField.new(nil, "")
    local fy_accel = TextField.new(nil, "")
    local fz_accel = TextField.new(nil, "")
    x_accel:setPosition(10, 20)
    y_accel:setPosition(10, 40)
    z_accel:setPosition(10, 60)
    fx_accel:setPosition(10, 80)
    fy_accel:setPosition(10, 100)
    fz_accel:setPosition(10, 120)
    stage:addChild(x_accel)
    stage:addChild(y_accel)
    stage:addChild(z_accel)
    stage:addChild(fx_accel)
    stage:addChild(fy_accel)
    stage:addChild(fz_accel)

    local dotX_x = 240
    local dotX_y = 160

    local line = Shape.new()
    line:setFillStyle(Shape.NONE)
    line:setLineStyle(1,0x000000)
    stage:addChild(line)

    local function onEnterFrame()
        -- get accelerometer values
        local x, y, z = accelerometer:getAcceleration()
        x_accel:setText(" x "..tostring(x))
        y_accel:setText(" y "..tostring(y))
        z_accel:setText(" z "..tostring(z))

        -- do the low-pass filtering
        fx = x * filter + fx * (1 - filter)
        fy = y * filter + fy * (1 - filter)
        fz = z * filter + fz * (1 - filter)
        fx_accel:setText("fx "..tostring(fx))
        fy_accel:setText("fy "..tostring(fy))
        fz_accel:setText("fz "..tostring(fz))

        local orientation = application:getOrientation()
        if orientation == Application.PORTRAIT or orientation == Application.PORTRAIT_UPSIDE_DOWN then
            screen_x = fx
            screen_y = fy
        else
            screen_x = fy
            screen_y = fx
        end

        local dotO_x = 160 + screen_x * 160
        local dotO_y = 240 + screen_y * 240
        dotO:setPosition(dotO_x,dotO_y)

        dotX_x = dotX_x - screen_x * 3
        dotX_y = dotX_y - screen_y * 3
        if dotX_x < 0 then
            dotX_x = 480
        end
        if dotX_x > 480 then
            dotX_x = 0
        end
        if dotX_y < 0 then
            dotX_y = 320
        end
        if dotX_y > 320 then
            dotX_y = 0
        end

        dotX:setPosition(dotX_x,dotX_y)
        line:clear()
        line:setFillStyle(Shape.NONE)
        line:setLineStyle(1,0x000000)
        line:beginPath(Shape.NON_ZERO)
        line:moveTo(240,160)
        line:lineTo(dotO_x, dotO_y)
        line:endPath()

    end

    stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

TNT Virtual Pad - Joystick
----------

[TNT Virtual Pad](http://www.tntengine.com/) is a 3rd party solution that allows you to easily create a joystick, and it is free.  In your Gideros project you want to add the virtual pad images and the tntvpad library files.  Be sure to right click on the library files and select "Exclude for Execution".  Be sure to look at the examples that come with TNT Virtual Pad.  Since the virtual pad can be configured to do many things you want to look at the documentation as well.  The images for the virtual pad must be a texture pack.

Because TNT Virtual Pad uses touch events and not mouse events this will only work on a real device.

This code will run and load an animation.  In this example my virtual pad images are saved into a file called Virtual Pad.  I created this using the template images that come with TNT Virtual Pad and Gideros Texture Packer.  I also included it into my project.

    local function is32bit()
        return string.dump(is32bit):byte(9) == 4
    end
    if is32bit() then
        require("tntanimator32")
    else
        require("tntanimator64")
    end

    -- setup Virutal Pad
    local vPad = CTNTVirtualPad.new(stage, "VirtualPad",  PAD.STICK_SINGLE, PAD.BUTTONS_ONE, 20,0)
    vPad:setJoyStyle(PAD.COMPO_LEFTPAD, PAD.STYLE_FOLLOW)
    vPad:setJoyAsAnalog(PAD.COMPO_LEFTPAD, false)
    vPad:start()

    function leftJoy(e)
        print( "Power: "..e.data.power.." Angle: "..e.data.angle )
    end

    function buttonEvent(e)
        print( "Button "..e.data.state )
    end

    vPad:addEventListener(PAD.LEFTPAD_EVENT, leftJoy, self)
    vPad:addEventListener(PAD.BUTTON1_EVENT, buttonEvent, self)

Events
----------

We've now shown a lot of events.  Here are all of the different types of events we can listen for.  We've seen the first few.

    Event.TIMER

    Event.MOUSE_DOWN
    Event.MOUSE_MOVE
    Event.MOUSE_UP

    Event.TOUCHES_BEGIN
    Event.TOUCHES_MOVE
    Event.TOUCHES_END
    Event.TOUCHES_CANCEL

    Event.ENTER_FRAME

We haven't seen these events.  They are less important but it is important to know they exist.

    Event.APPLICATION_EXIT
    Event.APPLICATION_RESUME
    Event.APPLICATION_START
    Event.APPLICATION_SUSPEND

    Event.ADDED_TO_STAGE
    Event.REMOVED_FROM_STAGE

    Event.HEADING_UPDATE
    Event.LOCATION_UPDATE

    Event.COMPLETE
    Event.PROGRESS
    Event.ERROR

    Event.BEGIN_CONTACT
    Event.END_CONTACT
    Event.POST_SOLVE
    Event.PRE_SOLVE

    Event.REQUEST_PRODUCTS_COMPLETE
    Event.RESTORE_TRANSACTIONS_COMPLETE
    Event.TRANSACTION

We wont discuss it now, but you can even create your own events.
