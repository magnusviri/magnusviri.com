---
layout:     default
title:      Mobile Game Programming Lesson 2
date:       2012-05-26
editdate:   2020-05-11
categories: Gideros
disqus_id:  mobile-game-programming-lesson-2.html
---

## Numbers

In the last lesson we were zoomed out and talked about the larger picture of a game.  Now let's zoom in and examine how numbers work in a computer program.

Open up a new project and create a new file, name it main.lua.  Type the following into the file.

    textField1 = TextField.new(nil, "")
    textField1:setPosition(10,10)
    stage:addChild(textField1)

Copy that text and paste it 3 times.  Change the names in each one so that you have textField1, textField2, textField3, and textField4.  Then change the setPosition so that each one is at a different place.

This type of copy and pasting is very common when programming so get use to it.  It's also a source of many errors, so beware when doing it, don't zone out.  Pay attention and keep outside distractions to a minimum.  It's boring and listening to music helps me to not look for something else to do that is less tedious.  If you do something like this and then try to run your program but it doesn't work, you know where the problem probably is.

All of our examples in this lesson are going to use these textFields to display something on the screen so just leave this code at the top of the file.  Put the code in the examples below these 4 textfields.  It should look like this.

    textField1 = TextField.new(nil, "")
    textField1:setPosition(10,10)
    stage:addChild(textField1)

    textField2 = TextField.new(nil, "")
    textField2:setPosition(10,30)
    stage:addChild(textField2)

    textField3 = TextField.new(nil, "")
    textField3:setPosition(10,50)
    stage:addChild(textField3)

    textField4 = TextField.new(nil, "")
    textField4:setPosition(10,70)
    stage:addChild(textField4)

    -- example code goes here

## Math

Add this line below the code shown above.

    textField1:setText( 1 + 2 )

Save the program and run it.  You should see a 3 on the screen!  Not very interesting.

Let's see what other math we can do.  The only thing that is different from what you expect is that to multiply use * not x and to divide use /.

Replace the line above with these 4 lines, save it, and run it.

    textField1:setText( 2 * 3 )
    textField2:setText( 4 - 5 )
    textField3:setText( 6 / 7 )
    textField4:setText( 1.23 + 2.34 )

You should see these numbers on the screen.

    6
    -1
    0.85714285714286
    3.57

Try changing the numbers in the source code and rerun it until you understand what is going on.  This is a good way to figure out why things happen the way they do, just change a number and see what happens.

## Operator Precedence

Add, subtract, multiply, divide, they are called operators.  Precedence says which ones go first.  It isn't always left to right.  Sometimes things happen right to left.  These are the rules that determine what happens first.  And for now, there is only two rules you need to know.

Everything in parenthesis happen first.  Multiply and divide always happen before add and subtract.

    textField1:setText( 1 + 3 * 5 )
    textField2:setText( 2 / 4 + 1 )
    textField3:setText( 1.5 * 2 - 3 )

The above code could also be written with parenthesis to set what happens first (and in these cases, it changes nothing because the parenthesis surround the things that already happened first).

    textField1:setText( 1 + ( 3 * 5 ) )
    textField2:setText( ( 2 / 4 ) + 1 )
    textField3:setText( ( 1.5 * 2 ) - 3 )

The examples are the same and print these numbers.

    16
    1.5
    0

If you want to change the order of operations you put parenthesis around the other things you want to happen first.

    textField1:setText( ( 1 + 3 ) * 5 )
    textField2:setText( 2 / ( 4 + 1 ) )
    textField3:setText( 1.5 * ( 2 - 3 ) )

The above code prints the following, which is very different.

    20
    0.4
    -1.5

Whew, we are done with the math.  Sort of...

## Spaces

You will notice that all of these examples use spaces around the parenthesis, the numbers, and the math operators.  Most of the time the computer doesn't care where you put spaces.  But *you* should care.  Spaces determine how readable your code is.  Look at the next example and you decide which one is easier to read.

    textField1:setText(54.32*(13-6*2)/54.32)
    textField2:setText( 54.32 * ( 13 - 6 * 2 ) / 54.32  )

Space placement is a matter of preference and you should decide what is easiest to read and looks best.

## Activity

Write a program that prints the following.

* How many seconds in a minute.
* How many seconds in an hour.
* How many seconds in day.
* How many seconds in a week.
* How many days are in 31536000 seconds.

You may notice that this is actually not that easy.  How do you go about doing these things?  The real task here is converting an idea into steps that a computer can understand.

First, we want to print something, so we use `textField1:setText()`.  Second, we want the number of seconds in a minute.  That is easy enough.  So just put the answer in between the parenthesis.

To get the other numbers, you just need to put in the correct math functions in between the parenthesis.  For example, an hour is made up of minutes and seconds.  So to get the number of seconds, you need to multiply the number of minutes by the number of seconds.  Same goes for the day and week.  Just do lots of multiplications.

To find out how many days are in that big number, you need to divide by the correct numbers.  So first convert the number from seconds to minutes (divide by the number of seconds in a minute), then convert minutes to hours, and finally hours to days, all division.

The answers are at the end of this lesson.

## This example is not a game

So for this to be a good lesson I thought it appropriate to show you how to do your homework with a computer.  But don't cheat because if you do then you wont pass the tests.  This program will draw a graph of an equation.  The shape of the graph is determined by the code `yy = xx + 2`.

You may be asking why I'm naming the variable "yy" and "xx".  That's not 2 y's or 2 x's.  yy and xx are the names of the variables.  Well, how come I'm doing that?  This is a matter of preference, but personally I use the find command on the computer to search for variables all the time.  If you use a single letter variable, like "x" and "y", you find every time an x or y appears, which often isn't what you want.  So by repeating the letter it is easier to find when doing text searches.  That's the only reason I'm using xx and yy.

Copy and paste all of the following code into a new Gideros project.  Run it to see what it does.  After you run it, change the line `return xx + 2` to something like `return (xx + 2) * (xx - 2)` or `return (xx + 2) * (xx - 2) * xx` or even `return (xx + 2) * (xx - 2) * (xx + 1) * (xx - 1)`.  See what happens.

    -- Draw a Graph

    -- The all important function!

    function fy( xx )
        return xx + 2
    end

    -- This code draws the line

    function draw_line( line, width, height, scale )
        line:clear()
        line:setFillStyle(Shape.NONE)
        line:setLineStyle(1,0x0000ff)
        line:beginPath(Shape.NON_ZERO)
        for screen_x = 0,width,4 do
            local xx = screen_x - width / 2
            line:lineTo( screen_x, height / 2 - fy( xx/scale )* scale )
        end
        line:endPath()
    end

    -- Find out how big the screen is

    local width = application:getContentWidth()
    local height = application:getContentHeight()

    -- Set the number of pixels per whole number on the graph
    local scale = 30

    -- Draw the crosshair
    local axis = Shape.new()
    axis:setFillStyle(Shape.NONE)
    axis:setLineStyle(1,0x000000)
    axis:beginPath(Shape.NON_ZERO)
    axis:moveTo(0, height/2)
    axis:lineTo(width, height/2)
    axis:moveTo(width/2, 0)
    axis:lineTo(width/2, height)
    for xx = 0,width/2,scale do
        axis:moveTo(width/2+xx, height/2-3)
        axis:lineTo(width/2+xx, height/2+3)
        axis:moveTo(width/2-xx, height/2-3)
        axis:lineTo(width/2-xx, height/2+3)
    end
    for yy = 0,height/2,scale do
        axis:moveTo(width/2-3, height/2+yy)
        axis:lineTo(width/2+3, height/2+yy)
        axis:moveTo(width/2-3, height/2-yy)
        axis:lineTo(width/2+3, height/2-yy)
    end
    axis:closePath()
    axis:endPath()
    stage:addChild(axis)

    -- Create the line in memory (so we can modify it later)
    local line = Shape.new()
    stage:addChild(line)

    -- This draws the line
    draw_line( line, width, height, scale )

## Answers

Here are the answers for the activity earlier in the lesson.

    -- How many seconds in a minute
    textField1:setText( 60 )

    -- How many seconds in an hour (60 seconds * 60 minutes = 1 hour)
    textField1:setText( 60 * 60 )

    -- How many seconds in day (60 seconds * 60 minutes * 24 hours = 1 day)
    textField1:setText( 60 * 60 * 24 )

    -- How many seconds in a week (60 seconds * 60 minutes * 24 hours * 7 days = 1 week)
    textField1:setText( 60 * 60 * 24 * 7 )

    -- How many days are in 31536000 seconds (31536000 seconds / 60 seconds / 60 minutes / 24 hours = ?...)
    textField1:setText( 31536000 / 60 / 60 / 24 )
