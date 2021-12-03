---
layout:     default
title:      "Click that mouse"
date:       2015-09-07
editdate:   2020-05-11
categories: Mac
disqus_id:  click-that-mouse.html
render_with_liquid: false
---

So I was playing some web based game that demanded I click my danged trackpad over and over.  I was lazy (and didn't want to ruin my trackpad) so I went and found some code to do it for me.  I had to clobber it together using various sources.

To use this, open Terminal and type this command in, but don't type return.  Position your mouse where you want it to click, then you can press return.  The command will click the mouse very quickly as long as the mouse is within 100 pixels of the starting point.

Be careful because you can lose control of your computer this way. In writing this, I lost control once and had to ssh in and kill the loginwindow because there were so many clicks saved up it was totally unresponsive.


    // File:
    // click.m
    //
    // Compile with:
    // gcc -o click click.m -framework ApplicationServices -framework Foundation
    //
    // Usage:
    // ./click
    // It will click over and over until the pointer is moved away.


    #import <Foundation/Foundation.h>
    #import <ApplicationServices/ApplicationServices.h>

    void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point)
    {
        CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
        CGEventSetType(theEvent, type);
        CGEventPost(kCGHIDEventTap, theEvent);
        CFRelease(theEvent);
    }

    void LeftClick(const CGPoint point)
    {
        PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
        PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
        PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, point);
    }

    int main(int argc, char *argv[]) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];

        CGPoint firstPoint;
        CGEventRef ourEvent = CGEventCreate(NULL);
        firstPoint = CGEventGetLocation(ourEvent);
        CFRelease(ourEvent);
        CGPoint currentPoint;

        while ( 1 ) {
            CGEventRef ourEvent = CGEventCreate(NULL);
            currentPoint = CGEventGetLocation(ourEvent);
            CFRelease(ourEvent);
            if ( firstPoint.x + 100 > currentPoint.x &&
                firstPoint.x - 100 < currentPoint.x &&
                firstPoint.y + 100 > currentPoint.y &&
                firstPoint.y - 100 < currentPoint.y
            ) {
                LeftClick(currentPoint);
            } else {
                usleep(15000);
            }
            usleep(5000);
        }

        [pool release];
        return 0;
    }
