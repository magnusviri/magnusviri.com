---
layout:     default
title:      "Gideros UIKit Plugin API"
date:       2012-05-10
editdate:   2020-05-11
categories: Gideros
disqus_id:  gideros-uikit-plugin-api.html
---

This is an API for the [Gideros](http://giderosmobile.com) [UIKit Plugin](https://github.com/carolight/MHUIKit) written by [Michael Hartlef](http://www.whiteskygames.com)

Forum discussion

- [How do you make the screen scroll up when keyboard covers textfield](http://giderosmobile.com/forum/discussion/754/mhuikit-how-do-you-make-the-screen-scroll-up-when-keyboard-covers-textfield)
- [UIKit Plugin Example](http://giderosmobile.com/forum/discussion/578/uikit-plugin-example)
- [Gideros UIKit Plugin API](http://giderosmobile.com/forum/discussion/723/gideros-uikit-plugin-api)

To use the plugin:

Copy uikit.mm to Xcode project "plugins" directory and then add to Xcode project.

In the lua file:

    require "ui"

The following is a somewhat hodgepodge collection of the classes, inheritance, and function names with the return values listed in C and the Lua parameters that are expected..

Global functions:

    int hideStatusBar(bool show)
    int addToRootView(view v)
    int removeFromRootView(view v)
    NSArray luaTableToArray(table t)

View : GEventDispatcherProxy

    new()
    void addView(view childView)
    void removeFromParent()
    void setPosition(int x, int y)
    void setSize(int width, int height)

Button : View

    new()
    void setTitle(string title)
    void setTitleColor(float r, float g, float b)
    void setBGColor(float r, float g, float b)
    void setFont(string fontname, float s)
    void setImage(string imagefile)
    void setBGImage(string imagefile)

    Generated event: "onButtonClick"

Label : View

    new()
    void setText(string text)
    void setTextColor(float r, float g, float b)
    void setBGColor(float r, float g, float b)
    void setFont(string fontname, float s)

AlertView : GEventDispatcherProxy

    new(string title, string message, string button)
    void show()
    void addButton(string title)

    Generated event: "complete"

Switch : View

    new()
    void setState(bool state)
    bool getState()

    Generated event: "onSwitchClick"

Slider : View

    new(float min, float max)
    void setValue(float value)
    int getValue()
    void setThumbImage(string imagefile)

    Generated event: "onSliderChange"

TextField2 : View

    void create(string text)
    void setText(string text)
    string getText()
    void setTextColor(float r, float g, float b)
    void setBGColor(float r, float g, float b)
    void showKeyboard()

    Generated events: "onTextFieldEdit", "onTextFieldReturn"

WebView : View

    new(string url)
    void loadLocalFile(string filename)

    Generated events: "onWebViewNavigation"

PickerView : View

    new(table items)
    virtual int getRowCount()
    virtual void setRow(int row)
    virtual int getPickedRow()
    virtual string getPickedItem()

    Generated event: "onPickerRows"

Toolbar : View

    new()
    void addButton()
    void addTextButton(string caption)
    void add(view xview)
    //void setValue(float value)
    //void setThumbImage(string imagefile)

    Generated event: "onToolbarClick"

ScrollView : View

    new(float x, float y, float w, float h, float cw, float ch)
    void add(view v)

    Generated event: onScrollViewClick

TableView : View

    new()
    void setData(NSArray data) -- use luaTableToArray()
    void setCellText(string text)
    setPosition(x, y)
    setSize(width, height)

    Generated events: "cellForRowAtIndexPath", "didSelectRowAtIndexPath"
    event table includes the additional field: "Row" (event.Row)
