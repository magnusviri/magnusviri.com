---
layout:     default
title:      "Mobile Game Programming Lesson 4"
date:       2012-06-21
editdate:   2020-05-11
categories: Graveyard
disqus_id:  mobile-game-programming-lesson-4.html
render_with_liquid: false
---

## Images, Sounds, Examples, Documentation

We've looked at several examples already showing simple games.  We've talked about the basic structure of a game, we've looked at some basic programming concepts, and we've talked about numbers, math, and strings. We are going to finish our look at data by looking at images and sound.  With images and sound games are a lot funner!

When you download Gideros there is a folder named "Examples" in the Gideros folder.  We are also going to look at this example code. Download the code if you do not have it. We are also going to start looking at the Lua and Gideros documentation.

While looking at these things we will discuss Lua's tables, classes, and for loops.

Images
--------

Creating and displaying an image is easy.  First, you have to add the image to your project in Gideros Studio. Next, you use this code to load the image and store it in memory.  Gideros calls a loaded image a "texture" so I'll use that word from here on out.

Note, "Texture" is part of the Gideros API (Application Programming Interface).  It can not be used as a variable name.  Lua is case sensitive, so "texture" is not the same as "Texture", so "texture" can actually be a variable name.  The same is true with "Bitmap" and "bitmap".

    local birdTexture = Texture.new("bird.png")
    local birdBitmap = Bitmap.new(birdTexture)
    stage:addChild(birdBitmap)

Texture.new() is a command that loads the image file from the file system (in the case of mobile devices, this isn't a disk but flash memory) and puts it in RAM.  It's better to put images in RAM because RAM is much faster to access than flash memory.  Texture.new() puts the image in memory so we want a variable so we can find the image.  In the example above we are using birdTexture to point to the image.

Bitmap.new() is a command that takes the variable that tells us where the image is at and it gives us a wrapper around it so we can do interesting things with it.  The main purpose of the bitmap is to add it to the stage.  You don't add a texture to the stage, you add the bitmap to the stage.  The reason for this is because you may want to add the same image multiple times.  Well, you don't want to load the image into memory multiple times, you only need to load it once. So you create one texture, but you can create many bitmaps that point to the texture and you save a lot of memory.

Tables
--------

Before we dive into a lengthy look at images and bitmaps, I need to explain what a table is.  A Lua table is a thing that stores stuff.  A Lua table is created by using squiggly braces, "{}".

    table = {}

Then we can add things to the table by using dots, like this.

    table.something = 1
    print(table.something)

We've actually used tables many times already.  In the Tic Tac Toe game we used a table to store the game board boxes.  In the Which Way game we used tables to store the messages saying which way to go.  In that game we actually created and added things to the table at the same time.

    positive = {
        "x welcomes you",
        "proceed x",
        "try to go x",
        -- etc
    }

In this case the strings are a list of items and they are accessed by using square braces with the number that you want to get at.  The first item is [1].  The second item is [2].  In some programming languages (like C) the first item is 0.  But in Lua it is 1.  That's just a friendly warning about your future if you pursue programming.

    print( positive[1] ) -- prints "x welcomes you"

A table is part of the Lua language.  If you want to learn more about the table you go to this URL.

[http://www.lua.org/pil/2.5.html](http://www.lua.org/pil/2.5.html)

How about you go there now to learn a little about a table directly from the source.  Just about everything you want to know (and maybe a lot you don't want to know) about tables is on that webpage.

In the last chapter we used the Lua string library commands string.gfind(), string.gsub(), and string.sub().  We also used table.getn() and table.remove().  We also used math.random().  These commands are all stored in tables.  That is, "string", "table", and "math" are tables.  If you want to learn about these you go to the Lua Standard Library documentation.

- Math: [http://www.lua.org/pil/18.html](http://www.lua.org/pil/18.html)
- Tables: [http://www.lua.org/pil/19.html](http://www.lua.org/pil/19.html) (be sure to use the arrows to view all of the table related pages)
- Strings: [http://www.lua.org/pil/20.html](http://www.lua.org/pil/20.html)

Classes
----------

Now, about this new() command.  We've seen it a few times already.  We've seen Shape.new(), TextField.new() and in the last chapter we actually had BoxTextField.new().  Now we have Texture.new() and Bitmap.new().  In every case, new() creates something in memory just like a number or string and we use a variable to point to it.  But unlike a number or string, the things new() creates in memory have more bells and whistles.  We call these things objects.

Shape, TextField, Texture, and Bitmap are called classes.  To understand what they mean by classes, think of airplanes.  They are categorized by class, for example, a biplane, a single propeller plane, a glider, or a jet.  The class is the blue prints, the new() command is the warehouse that builds the plane, and the thing that comes out of it is something that takes up space in a hanger.  So a class like Texture is the blueprint of our object.  The new() command creates a new Texture object for us.  And we use a variable to remember where our Texture object is.  An object is also called an instance, because well, it exists.

Shape, TextField, Texture, and Bitmap are part of the Gideros Application Programming Interface (API).  That means that Gideros decides what these things are, not Lua.  So if you want to look up the documentation for a Bitmap you need to go to this URL.

[http://www.giderosmobile.com/documentation/reference_manual.html#Bitmap](http://www.giderosmobile.com/documentation/reference_manual.html#Bitmap).

However, BoxTextField is not defined by Gideros.  In the last chapter, we actually created the blueprints for BoxTextField ourselves with the following code.

    BoxTextField = Core.class(Shape)
    function BoxTextField:init(text,...)
        -- cut...
    end

It is important to examine the similarities and differences between using a table and an object.  You will notice that to use the random function from the math library (which is a table) we use a dot.

    print( math.random() )

To create an object we use the form SomeName.new().  Between the class name and new() we have a dot, which is the same as when we call a table library command.  When modifying a variable in an object you use a dot, just like you would with a table.  From chapter 1 we used the following code to create and modify an object, all with dots.

    board = Shape.new()
    board.width = 300
    board.height = 300
    board.lineWidth = 3
    board.color = 0x000000

The main difference between a table library and an object is when you want to execute commands.  In a table library you use a dot, like math.random().  When you want to execute an object command, you use a colon instead of a dot, like board:moveTo().

Let's look at the Shape class and see everything that a Shape object can do.

[http://www.giderosmobile.com/documentation/reference_manual.html#Shape](http://www.giderosmobile.com/documentation/reference_manual.html#Shape)

It has a lot of commands.  Here is the list.

    Shape.new()
    Shape:setFillStyle(type, ...)
    Shape:setLineStyle(width, color, alpha)
    Shape:beginPath(winding)
    Shape:moveTo(x, y)
    Shape:lineTo(x, y)
    Shape:endPath()
    Shape:closePath()
    Shape:clear()

Also notice this text in the API documentation: "Shape > Sprite".  That means that Shape can do everything that a Sprite can do.  In fact, we say that a Shape is a Sprite.  Bitmaps are listed as "Bitmap > Sprite".  That means Bitmaps are Sprites also.  And the Sprite documentation has "Sprite > EventDispatcher".  Yup, that means that a Sprite can do everything that an EventDispatcher can do and that means that a Sprite is an EventDispatcher.

This is a lot of stuff!  I don't expect you to learn the whole Lua standard libraries or the Gideros API in a week, it's impossible.  Instead, you need to know how to find them and how to read them and most importantly, how to understand them.  Since both the Lua documentation and the Gideros Reference Manual were written for people who pretty much know how to program already, it will be hard to understand everything they say at first.  To get past this, you need to learn to skip things you don't understand and ask questions when you are stuck.

Jumping Ball Example
-----------

To get further acquainted with textures and bitmaps, let's look at some examples that come with Gideros Studio.  First let's look at Jumping Ball.  Please look at it now, it is located in the folder "Gideros Studio/Examples/Graphics/Jumping Ball".  Within Gideros Studio choose "Open File" and navigate to that path and open "Jumping Ball.gproj".  Then run it.

The very first thing it does is load a background image and put it on the stage.

    local background = Bitmap.new(Texture.new("field.png"))
    stage:addChild(background)

Remember that everything in parenthesis happen first.  Texture.new() happens before Bitmap.new().  Notice it doesn't store the location of the texture in a variable but instead just gives the location to the Bitmap.new() command.  That's because the background texture isn't going to be used for anything else.

Well, the bitmap isn't used for anything else either, so why not pass that directly to the stage:addChild() command like this?

    stage:addChild(Bitmap.new(Texture.new("field.png")))

You could actually do this.  It is a little harder to look at, but it's perfectly valid.

Then you see this code.

    local ball = Bitmap.new(Texture.new("ball.png"))

    -- in Gideros, every created object is an ordinary Lua table
    -- therefore, we can store our custom fields in this table
    ball.xdirection = 1
    ball.ydirection = 1
    ball.xspeed = 2.5
    ball.yspeed = 4.3

    -- add the ball sprite to the stage
    stage:addChild(ball)

Normally when we modify an object variable it is because it changes the object behavior.  For example, if we had a person object we might set their first name and age and that will affect how the object behaves.  To find out what things we can modify we would look at the API documentation.

In the above code it refers to ball.xdirection. If we looked at the documentation for Bitmap we wouldn't find an explanation for xdirection.  A Bitmap is a Sprite also so maybe it is there, but the Sprite class doesn't have xdirection either.  A Sprite is an EventDispatcher but it doesn't have xdirection either.

What the heck is xdirection?  It is a variable that we are creating.  We can add variables to our objects just like we add them to a table.  In this case, we are adding xdirection, ydirection, xspeed, and yspeed.

The rest of the Jumping Ball example is the onEnterFrame() function that moves the ball and when it reaches the edge of the screen it bounces it in the other direction.  The last line sets up the program so it calls onEnterFrame() every time the frame (the screen) is drawn.

    stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

Jumping Balls (plural) Example
---------------------------

The Jumping Balls (plural) example is almost identical to the Jumping Ball example with one big difference.  We turn the Ball into it's own class.

The Ball class (the blueprint) is defined in the ball.lua file.  By putting this code in a different file we can use the ball in any game very easily.  Instead of copying and pasting the code from the main file, we just copy that ball.lua file to another game.  If we organize our Ball class right then there wont be anything in it that refers to anything else in the game.  That makes it really easy to just move it from project to project.

Also notice that event listeners do not need to be in the main.lua file.  They can be in any file.  But for the event listener to work, it still needs to be executed.  In this case we add the event listener in Ball:init().  When does Ball:init() get called?  You wont find any examples with init() being callled.  The answer is when you call Ball.new(), Ball:init() will be called for you.  So when you call Ball.new() the event listener will be added.

Here is our blueprint code for the Ball class.  These are the minimum things we need to create a class.

    Ball = Core.class(Sprite)

    function Ball:init(texture)
        local bitmap = Bitmap.new(Texture.new(texture))
        self:addChild(bitmap)
        -- etc...
    end

The code that creates the ball objects is in main.lua and looks like this.

    local ball1 = Ball.new("ball1.png")
    local ball2 = Ball.new("ball2.png")
    -- etc...

    -- and add ball sprites to the stage
    stage:addChild(ball1)
    stage:addChild(ball2)
    -- etc...

Why did we turn Ball into its own class?  If you look at the Jumping Ball example, to create more than one ball you would have to duplicate the code for the single ball once for each extra ball.  Duplicated code is undesirable and leads to many problems.  We can avoid the duplication by using a class to contain the code for our ball.

For loops
-----------

We've seen for loops before but never talked about them.  Let's look at them now.  Here is an example loop.

    for i=0,2 do
        print( i )
    end

Let's unroll this loop.  If we wrote the lines in that loop one at a time, it would look like this.

    i = 0
        print( i )
    i = i + 1
        print( i )
    i = i + 1
        print( i )

It will print 0, 1, and then 2.

A for loop starts with the first number, in this case 0, executes the code inside of it, in this case print( i ), and when it reaches the end of the loop, it starts over but it adds one to the counter.  It will keep counting up until it reaches the second number, in this case 2.

When you have 2 loops inside of each other it looks like this.

    for i=0,2 do
        for j=0,2 do
            print( i .. " " .. j )
        end
    end

Let's unroll this loop.  I'm indenting based on the loop (i is the first indentation, j is the second indentation).

    i = 0
        j = 0
            print( i .. " " .. j )
        j = j + 1
            print( i .. " " .. j )
        j = j + 1
            print( i .. " " .. j )
    i = i + 1
        j = 0
            print( i .. " " .. j )
        j = j + 1
            print( i .. " " .. j )
        j = j + 1
            print( i .. " " .. j )
    i = i + 1
        j = 0
            print( i .. " " .. j )
        j = j + 1
            print( i .. " " .. j )
        j = j + 1
            print( i .. " " .. j )

Notice that j starts over every time i increases.  It prints "0 0", "0 1", "0 2", "1 0", "1 1", "1 2", "2 0", "2 1", and "2 2".

The next example uses a for loop just like this one.

Hierarchy Example
--------

The hierarchy example shows how Sprites can be added to Sprites. When a Sprite object is added to another they become child and parent.  Wherever the parent goes, the child will be locked to the same position as the parent.  So when you use setPosition() on the parent, the child will move with the parent.  When you use setPosition() to the child, the parent will not move.

The position of the child is based on the parent as well.  A good way to view this is if you put a cat on a rug and move the rug around the room.  Assuming the cat is a very lazy cat, it will stay on the same place on the rug even though you are moving the rug.

The rug's position on the floor is based on the floor.  0, 0 would be the top left of the floor.  When you put the cat on the rug, the cat's position is based on the rug.  0, 0 is the top left corner of the rug.  The rug can be anywhere, but if the cat is at 0, 0, no matter where you move the rug the cat will stay at the top left corner of the rug.

Now back to the example.  At first it creates the textures objects.

    dot1tex = Texture.new("dot-1.png")
    dot2tex = Texture.new("dot-2.png")
    group1tex = Texture.new("group-1.png")
    group2tex = Texture.new("group-2.png")

Then it creates a sprite object.

    group1 = Sprite.new()

Then it creates a bitmap with one of the textures and adds it to the group1 sprite.

    group1:addChild(Bitmap.new(group1tex))

Then it performs a for loop like we looked at in the previous section and creates and adds more bitmaps to the sprite.

    for i=0,3 do
        for j=0,3 do
            local dot = Bitmap.new(dot1tex)
            dot:setPosition(i * 45 + 10, j * 45 + 60)
            group1:addChild(dot)
        end
    end

The tricky part here is reading the loop.  I'm going to unroll what the i and j values would look like in the setPosition().

    dot:setPosition(0 * 45 + 10, 0 * 45 + 60)
    dot:setPosition(0 * 45 + 10, 1 * 45 + 60)
    dot:setPosition(0 * 45 + 10, 2 * 45 + 60)
    dot:setPosition(0 * 45 + 10, 3 * 45 + 60)
    dot:setPosition(1 * 45 + 10, 0 * 45 + 60)
    dot:setPosition(1 * 45 + 10, 1 * 45 + 60)
    dot:setPosition(1 * 45 + 10, 2 * 45 + 60)
    dot:setPosition(1 * 45 + 10, 3 * 45 + 60)
    dot:setPosition(2 * 45 + 10, 0 * 45 + 60)
    dot:setPosition(2 * 45 + 10, 1 * 45 + 60)
    dot:setPosition(2 * 45 + 10, 2 * 45 + 60)
    dot:setPosition(2 * 45 + 10, 3 * 45 + 60)
    dot:setPosition(3 * 45 + 10, 0 * 45 + 60)
    dot:setPosition(3 * 45 + 10, 1 * 45 + 60)
    dot:setPosition(3 * 45 + 10, 2 * 45 + 60)
    dot:setPosition(3 * 45 + 10, 3 * 45 + 60)

By performing the math it looks like this.

    dot:setPosition(10, 60)
    dot:setPosition(10, 105)
    dot:setPosition(10, 150)
    dot:setPosition(10, 195)
    dot:setPosition(55, 60)
    dot:setPosition(55, 105)
    dot:setPosition(55, 150)
    dot:setPosition(55, 195)
    dot:setPosition(100, 60)
    dot:setPosition(100, 105)
    dot:setPosition(100, 150)
    dot:setPosition(100, 195)
    dot:setPosition(145, 60)
    dot:setPosition(145, 105)
    dot:setPosition(145, 150)
    dot:setPosition(145, 195)

All of these positions are relative to the parent sprite.  Then we set the main sprite position and add it to the stage.

    group1:setPosition(10, 10)
    stage:addChild(group1)

Notice the parent sprite is added at 10, 10.  The position of the first bitmap is 10, 60 relative to the parent sprite.  The parent sprite is at 10, 10 relative to the stage.  If I were to move the parent sprite, all the children sprites within it will move as well.

The full hierarchy example has 2 parent sprites.  The second parent does basically the same thing as the first one.  Go ahead, change the position of the parent sprites and see what happens.

Why use for loops?
--------------------

The above section we unrolled the for loops and the code was a lot easier to read.  How come we used the loop instead of just writing out the positions of the bitmaps?

So the section above was abbreviated, we left off 2 lines.  All 3 lines look like this.

    local dot = Bitmap.new(dot1tex)
    dot:setPosition(i * 45 + 10, j * 45 + 60)
    group1:addChild(dot)

If we had unrolled the whole thing properly we would've had to write those 3 lines 16 times, which was the number of times the inner most loop ran.  That's a total of 48 lines.  And what if we wanted to change the spacing from 45 to 50?  We'd have to change all of those numbers.  That's a lot of work.

In fact, go ahead and change the loop values and see what happens.  Change the `for i=0,3 do` to `for i=1,2 do`.  Change the `dot:setPosition(i * 45 + 10, j * 45 + 60)` to `dot:setPosition(i * 50 + 5, j * 50 + 50)`.  See what happens.

Using for loops requires you to use your imagination and do lots of yucky math in your head.  Not that math is yucky, but typically the math in for loops is very yucky.  In fact, it often helps to print out the math so that you see what is really happening.  For example, this would print out the same math.

    print(tostring(i * 45 + 10).." "..tostring(j * 45 + 60))

Fonts Example
--------

Take a look at the Font example.  There are 2 types of fonts.  The first is an image based font that has a text file that describes it.  Use Gideros Font Creator to make the 2 required files.  The .png image file contains all of the graphics for the font laid out in a grid.  The .txt file lets Gideros know where the characters are in the png file.  Make sure both of these files are part of your project if you use this type of font.

To use the font create a font object and then you can use it with TextField.new().  So far all our TextFields used "nil" as the first parameter and that uses the Gideros' built-in system font.  Take a look at the Fonts example if you haven't already  Here is the relevant code.

    local font2 = Font.new("arial.txt", "arial.png")

    local text1 = TextField.new(font1, "!!abcdefgh!!")

That's how easy it is to use an imaged based font!

The second type of font is based on the font standard called TrueType Font.  TrueType Fonts have the file extension ".ttf".

The difference between ttf fonts and image based fonts is that ttf fonts can be scaled very big and look good still.  When you scale image based fonts to be big you can see the pixels and they look bad.  The downside of ttf fonts is that they are more complicated to make.  In fact, you probably want to limit ttf fonts to ones made by others instead of trying to make your own.

To use a ttf font, include the ttf file in your project and use this code, which looks almost identical to the code above.

    local font1 = TTFont.new("arial.ttf", 14)

    local text1 = TextField.new(font1, "!!abcdefgh!!")

The Fonts example includes the arial.ttf file, but it doesn't use it in the main.lua file.  Change one of the lines to use the TTFont instead of Font class.  Vary the size of the font to see what it does.

Sounds
--------

Games must have sounds.  Sounds work very similarly to images, you load them into memory and then you play them.  You can load .wav files for short sounds or .mp3 files for song files.

    local sound = Sound.new("soundFile.mp3")
    sound:play()

You can optionally specify where the sounds starts in milliseconds and if you want to repeat it.

    sound:play(1000, 0)

If you want the sound to repeat forever, then use, use math.huge for the repeat value.

    sound:play(0, math.huge)

Audio Example
----------------

Let's look at an audio example.  Open up the example project located in "Gideros Studio/Examples/Audio/Audio Example".  In this example the audio code is in the soundbutton.lua file.  The relevant part is the following.

    local sound = Sound.new(soundfile)
    button:addEventListener("click", function() sound:play() end)

We will look at the button.lua file in the chapter 6 so don't worry about that for now.  But this is how easy it is to play sounds!

Music Player Example
---------------------

The music player example displays a play and pause button and a time indicator.  Unfortunately the time indicator doesn't allow us to drag to a certain spot in the song.  We could add it, but we haven't looked at how to get user input yet (we will in chapter 6).

Notice that `sound:play()` actually returns something that we can point to with a variable.  The main difference between this music player and the audio example above is that we remember the output of the `sound:play()` command.  By doing this we can pause the sound.  Here is the code that performs the pausing and playing.  Notice that we have to keep track of the sound, the channel the sound plays on, whether the sound is playing or not, and the last position of the song.

    local sound = Sound.new("Pitx_-_Black_Rainbow.mp3")

    -- and start playing
    local channel = sound:play()

    local playing = true

    local lastPosition = 0

    function onPlayClick()
        -- if not playing, start playing from the last position
        if playing == false then
            channel = sound:play(lastPosition)
            playing = true
        end
    end

    function onPauseClick()
        -- if playing, save the last position and stop the channel
        if playing == true then
            lastPosition = channel:getPosition()
            channel:stop()
            playing = false
        end
    end

The other interesting thing is how we update the position marker every second.  In this code we get the current position of the song with `channel:getPosition()` and then we divide it by the total length of the song with `sound:getLength()`.  This will give us a number between 0 and 1.  For example, if the current spot is 30 seconds and the song is 60 seconds then 30/60 is .5, or halfway.  We then we place the marker that distance along the bar (adjusting by -4 for the size of the marker).

    local function onTimer()
        local sec = math.floor(channel:getPosition() / 1000);
        time:setText(seconds2str(sec))

        local t = channel:getPosition() / sound:getLength()

        marker:setY(bar:getY() - 9)
        marker:setX(bar:getX() + t * bar:getWidth() - 4)
    end

Making Sound Effects
-------------------

The easiest way to make game sounds is with the great application [SFXR](http://www.drpetter.se/project_sfxr.html).  There is a Mac version called [CFXR](http://thirdcog.eu/apps/cfxr).  Here is a flash version that will run in a web browser: [http://www.bfxr.net/](http://www.bfxr.net/).

You can also get free sounds from [http://www.freesound.org/](http://www.freesound.org/).

Closing Remarks
-------------------

This lesson covered a lot of material.  We looked at how Gideros allows us to use images, fonts, and sounds and we looked at the Gideros documentation of these things.  We also looked at Lua's tables, classes, and for loops.  We also looked at several example projects.  This was a lot of information and far more detailed than the previous lessons.

Programming graphics can be a lot of fun because a fundamental part of computers is displaying visual feedback to users.  Sounds are also a lot of fun.  I've seen some applications that have nothing but sounds (hello, fart apps?).

Programming can be very boring and mind numbing sometimes.  Programming graphics has always been fun for me though.  It's almost always harder than I've expected, but in the end it has been worth it.
