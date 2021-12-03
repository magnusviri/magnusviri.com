---
layout:     default
title:      "Gideros iCade Plugin"
date:       2012-05-10
editdate:   2020-05-11
categories: Graveyard
disqus_id:  gideros-icade-plugin.html
---

This is an iCade plugin for Gideros

Forum discussion

- [KeyInput Plugin-was iCade plugin](http://giderosmobile.com/forum/discussion/758/keyinput-plugin-was-icade-plugin)
- [iCade Plugin](http://giderosmobile.com/forum/discussion/741/icade-plugin)
- [TNT Virtual Pad](http://giderosmobile.com/forum/discussion/869/tnt-virtual-pad-video-preview#Item_25)

[Download iCade.zip](../blog/iCade.zip) (last updated May 10th, 2012).

I've modified my iCade plugin to work interchangably with TNT Virtual Pad. I added the following code to the bottom of TNT VP's example2 project and that's all it takes to add iCade support to a project using TNT Virtual Pad.

    require "icade"
    icade = iCade.new()
    icade:start()

    icade:addEventListener(ICADE.LEFTPAD_EVENT, leftJoy, self)
    icade:addEventListener(ICADE.BUTTON7_EVENT, fire, self)
    icade:addEventListener(ICADE.BUTTON8_EVENT, protection, self)

There is no connection between the iCade behavior and what the TNT Virtual Pad looks like. The TNT Virtual Pad will dim automatically and I think that's probably the best way to handle it.

This iCade plugin produces events with data that looks exactly like TNT Virtual Pad events.  The iCade events are named differently though, because I don't want to trigger events twice.

When using the TNT Virtual Pad and the iCade at the same time (one hand on the joystick, one finger on the screen), the joystick values add up, which can produce some unintended side effects (moving twice as fast or canceling out the movement). Shooting can be achieved twice as fast as well.

This is how I'm deciding to avoid simultaneous input from the Virtual Pad and iCade.  I added an iCade table field to all iCade generated events.  If the event is a Virtual Pad event I record the os.time() and wont evaluate any iCade events if a Virtual Pad event happened in the last second.

This is the modified example 2.

    local timeVirtualPadLastUsed
    local function preventVirtualPadICadeSimultaneousUsage(e)
        if e.data.icade == true then
            -- It's the iCade, make sure the virtual pad wasn't used in the last second
            if os.difftime( os.time(), timeVirtualPadLastUsed ) >= 1 then
                return true
            else
                return false
            end
        else
            -- It's the virtual pad
            timeVirtualPadLastUsed = os.time()
            return true
        end
    end
    local function leftJoy(e)
        if preventVirtualPadICadeSimultaneousUsage(e) then
            if e.data.power > 0.2 then
                textfield:setText("Power: "..tostring(e.data.power).." Angle: "..tostring(e.data.angle))
                biPlane:move(e.data.angle, (e.data.power*150)*e.data.deltaTime)
            end
        end
    end
    local function fire(e)
        if preventVirtualPadICadeSimultaneousUsage(e) then
            if e.data.state == PAD.STATE_BEGIN then
                local fire = CLASS_fire.new(biPlane.xPos, biPlane.yPos-20)
                stage:addChild(fire)
            end
        end
    end
    local function protection(e)
        if preventVirtualPadICadeSimultaneousUsage(e) then
            if e.data.state == PAD.STATE_DOWN then
                biPlane.protection:setVisible(true)
            else
                biPlane.protection:setVisible(false)
            end
        else
            -- reset everything to defaults to since an iCade button release will now be ignored and could leave the protection on forever
            biPlane.protection:setVisible(false)
        end
    end

Obviously there is no iCade right pad and it supports 8 buttons and right now it isn't really configurable. I don't believe there is even anything to configure...

I did notice some stuttering with my plugin (didn't happen with plugin removed) so maybe I need to optimize it a bit.

One other annoyance is that when the iCade is connected to the iOS device the keyboard shows then hides. I am not sure how to get around that.
