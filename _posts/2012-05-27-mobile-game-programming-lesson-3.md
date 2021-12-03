---
layout:     default
title:      "Mobile Game Programming Lesson 3"
date:       2012-05-27
editdate:   2020-05-11
categories: Gideros
disqus_id:  mobile-game-programming-lesson-3.html
render_with_liquid: false
---

## Words

In the last lesson we looked at how numbers work in a computer program.  Programs have lots of numbers but far more words.  This lesson will discuss how letters and words are used.

There are several uses for words.  The first usage of a word is as a command to the computer.  Those commands can take many different forms.  I wont discuss those in this lesson because the rest of the book is basically going to discuss them.  The second usage is text that is displayed to the computer user, and those are called strings.  The last usage is as a comment to the computer programmer, you.  I'll discuss strings and comments in this lesson.

Strings
------------------

To create strings you use 2 single or double quotes to surround some text.  If any text is in quotes, the computer will not execute it.  If it is outside of quotes, the computer will execute it as a command.

The quotes are not part of the string.  You can think of a string as dialog in a book, for example, she excitedly said, "My aren't we happy today!"  Here are some examples of strings.

    "This is a string of characters, not a string of pearls."
    "The computer does care about the contents of strings, only people do."
    "Strings aren't just letters but numb3r5 and 5ymb0|5 t00!"
    'Strings can begin and end with a single quote too.'

In Lua, there is no difference between single and double quotes (in some languages they are different).  If you start a string with a double quote, it must end with a double quote, and vise-versa.  Using a double quote is most common so stick with double quotes.

You may also create multi-line strings using 2 square braces.

    [[
    A long time ago,
    In an ant hill,
    Far far away...
    ]]

Errors
---------

If you do not use quotes or the braces, you do not have a string, you have an error!  In the next example, the computer thinks it is being told to do things, but it wont have any idea what those things mean and it will error instead.

    this is an error because there are no quotes or double brackets!!!!

If you run this code you will get this error.

    newfile.lua:1: '=' expected near 'is'

This error doesn't really make any sense because the computer doesn't know you wanted a string, so it tries it's best to read the text as if it were commands, and it tells you what it thinks should happen based on what it thinks.  That is how errors messages usually work. The computer doesn't really know what you are trying to do. It only knows how to speak it's language, and it will tell you when it firsts finds something that doesn't make any sense.  In this case, by the time it got to the second word, "is", it didn't know what was going on.

Comments
-------------

Code talks to the computer.  Strings talk to the users.  Comments talk to you, the programmer.  That is, nearly all programmers forget and comments are reminders.  Many projects can take months, sometimes years to complete.  Most programmers do not remember why they did something after a few months and so comments help explain things.

Any time you have difficulty writing something, you should comment why you did it and any thing that you think could be helpful to yourself when you read it in the future.  Don't write comments to other people.  As a beginner it's hard to predict who will read your code and if the comments will help them or not.  Just focus the comments for yourself.

There are two types of comments.  A single line comment begins with "--" and ends at the end of the line.  A single line comment can come after commands, but no commands can come after the 2 hyphens.  A block comment begins with "--[[" and ends with "]]".

    -- This is a single line comment.  It is ignored by the computer.
    message = "Hello world!" -- This is a comment that comes after a command.
    --[[
    This is a multiline comment.
    This way multiple lines are ignored.
    ]]

You can use comments to comment out real code.  That way if you decide you don't want something to run, but you don't want to delete it totally, you just comment it out.

    -- message = "This line begins with 2 hyphens, so it wont ever run!"
    --[[
    message = "This is inside of a block comment, so it wont ever run!"
    ]]
    message = "This really runs."

Quotes Inside of Quoted Strings
-------------------------------------

Now back to strings.  Quotes signal the end of the string.  If you want to put quotes inside of a string, you have to do a little more work.  First, you can use one type of quote to include the other type.

    "   '   " -- Ok
    '   "   ' -- Ok

These strings are not ok, they will produce an error.

    "   "   " -- Error!
    '   '   ' -- Error!

If you need to use both types of quotes in a string, then you can use the backslash right before the quote.

    "   \"   " -- Ok
    '   \'   ' -- Ok

Escaping Backslash with Backslash
------------------------------------------------------

The backslash is called the escape character.  The escape character basically tells the computer you are escaping out of the string of characters and the next character has a special meaning.  In the case of escaping a quote character, you are telling the computer not to end the string but that the quote is part of the string.

There are other things you could tell the computer.  For example, because backslash means escape, if you really wanted a backslash, you need to escape it with a backslash!

    "A backslash: \\." -- A backslash: \.

Combining Strings
----------------------

You can combine two strings by using two dots.  This is called concatenation.

    message = "Hello " .. "Scaredy Pants" .. ", welcome to the dungeon!  Mwahahahaha!"

The above code create this string

    Hello Scaredy Pants, welcome to the dungeon!  Mwahahahaha!

Notice that I must have spaces and commas in the string.  Compare it with this example.

    message = "Hello" .. "Scaredy Pants" .. "welcome to the dungeon!  Mwahahahaha!"

The above code creates the following string, which is not a computer error, so it will run without crashing, but it is certainly an error.

    HelloScaredy Pantswelcome to the dungeon!  Mwahahahaha!

The Difference between "10" and 10
--------------------------------------------------

"10" is a string.  10 is a number.  When you want to add 2 numbers you use a +.  When you want to combine strings together you use "..".

    "10 .. 10"
    "10" .. "10"
    "10 + 10"
    10 + 10

The above code creates the following values.

    10 .. 10 (string)
    1010 (string)
    10 + 10 (string)
    20 (number)

Converting Between Strings and Numbers
------------------------------------------------

There are 2 ways to convert a string to a number or a number to a string.  I think this example speaks for itself.

    tonumber("10")
    tostring(10)

Also, if you use ".." with 2 numbers that will automatically convert it to a string.  And if you use + with 2 strings, it will attempt to convert the string to a number.

    10 .. 10 -- 1010 (string)
    "10" + "10" -- 20 (number)
    "hi mom!" + 10 -- Error: attempt to perform arithmetic on a string value

The text "hi mom!" can not be converted to a number because there are no digits in that string.

The String Library
-----------------------

There are a bunch of things you can do with strings.  Here are some of the commands that work with strings in the Lua string library.

    string.byte
    string.char
    string.dump
    string.find
    string.format
    string.gmatch
    string.gsub
    string.len
    string.lower
    string.match
    string.rep
    string.reverse
    string.sub
    string.upper

Using these commands you can do things like search a string, replace characters in the string with other characters, change the case, reverse the order, and more.  I'm not going to discuss how to use these commands here.  This goal of this book isn't to teach you everything about Lua or programming, but how to program a computer game.  So you shouldn't even try to learn what any of these commands do until you need to do string stuff.  When you need to learn, look online at the Lua documentation or some other tutorial.

Which Way Game
--------------------

However, I am going to give you an example of a game that uses the string library quite a bit to do some interesting things.  In this game, you have to go right or left.  There is a message telling you which way is the correct way.  However, the message is garbled!  You have to try to unscramble the message enough to know which way to go.

See if you can find the code that garbles the characters and comment it out by putting "--[[" and "]]" around it.  I bet the game is a lot easier if you comment out that code.

    function scrambleWord(word)
        local chars = {}
        for ii=1,string.len(word),1 do
            chars[ii] = string.sub(word,ii,ii)
        end
        local newWord = ""
        for ii=1,table.getn(chars),1 do
            newWord = newWord..table.remove(chars, math.random(table.getn(chars)))
        end
        return newWord
    end

    function newChoice()

        -- Randome direction
        direction = math.random(2)

        -- Random phrase
        local positiveChoice
        local choiceTable
        if math.random(2) == 1 then
            positiveChoice = true
            choiceTable = positive
        else
            positiveChoice = false
            choiceTable = negative
        end

        -- Add the direction to the text
        local directionText
        if ( direction == 1 and positiveChoice ) or
            ( direction == 2 and not positiveChoice ) then
            directionText = "left"
        else
            directionText = "right"
        end
        local choiceIndex = math.random(table.getn(choiceTable)) -- random
        local text = choiceTable[choiceIndex] -- get the phrase
        text = string.gsub(text, "x", directionText) -- subtitute x with the direction
        prescrambledText = text

        if true then
            -- Find words, scramble them
            local newText = ""
            for word in string.gfind(text, "([^ ]+)") do -- split into words
                newText = newText.." "..scrambleWord(word) -- scramble
            end
            text = string.gsub(newText, "^ (.-)$", "%1") -- remove the first space
        else
            -- Captialize
            local _, _, firstChar, remainingChars = string.find(text, "(.)(.*)")
            text = string.upper(firstChar)..remainingChars
        end

        messageField:setText(text)
    end

    function buttonPressed(button, event)
        if button:hitTestPoint(event.x, event.y) then
            if direction == button.direction then
                statusField:setText("You made it!")
            else
                application:vibrate()
                statusField:setText("OUCH! "..prescrambledText)
            end
            newChoice()
            event:stopPropagation()
        end
    end

    BoxTextField = Core.class(Shape)
    function BoxTextField:init(text,...)
        self.textfield = TextField.new(nil, text)
        self:addChild(self.textfield)
        local textfieldX
        local textfieldY
        if arg.n > 0 then
            self.width = arg[1]
            textfieldX = (self.width-self.textfield:getWidth())/2
        else
            self.width = self.textfield:getWidth()
            textfieldX = 0
        end
        if arg.n > 1 then
            self.height = arg[2]
            textfieldY = (self.height+self.textfield:getHeight())/2
        else
            self.height = self.textfield:getHeight()
            textfieldY = self.height
        end
        self.textfield:setPosition( textfieldX, textfieldY )
        if arg.n > 2 then
            self:setBackgroundColor(arg[3])
        end
    end

    function BoxTextField:setBackgroundColor(color)
        self:setFillStyle(Shape.SOLID, color, 1.0)
        self:beginPath(Shape.NON_ZERO)
        self:moveTo(0, 0)
        self:lineTo(0, self.height)
        self:lineTo(self.width, self.height)
        self:lineTo(self.width, 0)
        self:lineTo(0, 0)
        self:closePath()
        self:endPath()
    end

    math.randomseed( os.time() )

    positive = {
        "x welcomes you",
        "proceed x",
        "try to go x",
        "head towards x",
        "x is the correct way",
        "better go x",
        "you should go x",
        "x is the best way",
        "x is the right way",
        "choose the x",
    }
    negative = {
        "beware of x",
        "don't go x",
        "try not to go x",
        "avoid x",
        "stay away from x",
        "x is forbidden",
        "x is the wrong way",
        "x is the worst way",
        "x would be wrong",
        "flee the x",
    }
    direction = 1
    prescrambledText = ""

    titleField = TextField.new(nil, "Which way?")
    titleField:setPosition(10,30)
    stage:addChild(titleField)

    messageField = TextField.new(nil, "")
    messageField:setPosition(10,50)
    stage:addChild(messageField)

    statusField = TextField.new(nil, "")
    statusField:setPosition(10,70)
    stage:addChild(statusField)

    leftButton = BoxTextField.new("Go Left", 140, 80)
    stage:addChild(leftButton)
    leftButton:setBackgroundColor(0xaaaaaa)
    leftButton:setPosition(10, 200)
    leftButton:addEventListener(Event.MOUSE_DOWN, buttonPressed, leftButton)
    leftButton.direction = 1

    rightButton = BoxTextField.new("Go Right", 140, 80)
    stage:addChild(rightButton)
    rightButton:setBackgroundColor(0xaaaaaa)
    rightButton:setPosition(160+10, 200)
    rightButton:addEventListener(Event.MOUSE_DOWN, buttonPressed, rightButton)
    rightButton.direction = 2

    newChoice()
