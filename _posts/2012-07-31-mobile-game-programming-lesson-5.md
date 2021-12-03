---
layout:     default
title:      "Mobile Game Programming Lesson 5"
date:       2012-07-31
editdate:   2020-05-11
categories: Gideros
disqus_id:  mobile-game-programming-lesson-5.html
render_with_liquid: false
---

## Animation

In this lesson we will look at several different ways to animate.  The first method of animation we will look at uses multiple bitmaps to give our sprites the appearance of movement.  This is how motion pictures work.  To do this we will need to find or make some images.

The next method of animation is to move or change how visible the sprite is using gradual changes so that the sprites appear to have life-like motion and nice fade in and outs.

We are going to look at more example applications that come with Gideros Studio.

Bird Animation Example
-------------

The bird animation example shows us how to animate a sprite.  In this case, the animation is a series of images and each image is a frame of the animation.  When the images are shown after each other it appears that the sprite is animating.

The main.lua file specifies the images that will be a part of our sprites and creates the sprite objects and adds them to the stage.  The main code is in the bird.lua file, where the Bird class is created.  Let's talk a little bit more about creating a class.

In the main.lua file we create a new bird object with this code.

    local bird1 = Bird.new(frames1)

When Bird.new(frames1) is executed, it jumps to the bird.lua file to the code `function Bird:init(frameList)`. Inside of Bird:init() we create Bitmaps of the images and save them into self.frames.  Then we save the number of frames into self.nframes.  We keep track of which frame is shown in self.frame.  And we show that frame by adding the frame with addChild().  Then we add the bird sprite to the stage and give it a random speed and place it off screen to the right.

Every time the screen is rendered, onEnterFrame() is executed.  It has a counter, self.subframe.  When self.subframe is greater than 10, it resets that counter to 0 and it swaps the bitmap shown with the next one.  This is how it creates the illusion of animation, by swapping images quickly.  In this case, onEnterFrame is called 60 times a second, and we are waiting every 10 frames to advance frames, so the image will change 6 times a second.  There happen to be 3 images in the sequence, so it will repeat the sequence 2 times a second.  If you start the example and watch a clock, you will notice that the bird's wings move with each second.

Creating Bitmaps
----------------

In the previous example you noticed that we had to load a lot of images.  There are four methods for obtaining images.  The method you choose depends on the state of the images you want to use or if you used the "Gideros Texture Packer" tool to create a single image.

The Bird Animation loaded the images by using a table with the filenames and then loading them with a for loop.  This is probably the best method to use if you have a lot of separate images files.

    local frameList = {
        "frame_01.png",
        "frame_02.png",
        "frame_03.png",
        "frame_04.png"
    }
    local frameBitmaps = {}
    for ii = 1, #frameList do
        frameBitmaps[ii] = Bitmap.new(Texture.new(frameList[ii]))
        stage:addChild(frameBitmaps[ii])
    end

The next method involves loading multiple image files with the TexturePack class.  This code does the same thing as the above example.  Note that instead of keeping a frameBitmaps table, we have a TexturePack object (pointed to by the variable `pack`).

    local frameList = {
        "frame_01.png",
        "frame_02.png",
        "frame_03.png",
        "frame_04.png"
    }
    local pack = TexturePack.new(frameList)
    for ii = 1, #frameList do
        local region = pack:getTextureRegion(frameList[ii])
        local bitmap = Bitmap.new(Texture.new(region))
        stage:addChild(frameBitmaps[ii])
    end

The last two methods involves combining all of the images into one large image called a texture atlas.  This way we only have to load and store one image.  It's a larger image, but by using texture atlases there are performance improvements (games load faster).  A texture atlas is also known as texture map or sprite sheet.

The first method of using a texture atlas is to load a texture the way we have always loaded a texture but then to specify where the smaller images are located using pixel coordinates.  The first 2 numbers are the top corner and the last 2 numbers are the size.  In this example all of the images are 100x100 pixels so the last 2 parameters are 100, 100 for all of them.  The first 2 parameters are different and specify the top corner for each image.  It splits the texture atlas into 4 even squares.

    local texture = Texture.new("atlas.png")
    local regionList = {
        TextureRegion.new(texture, 0,   0,   100, 100),
        TextureRegion.new(texture, 100, 0,   100, 100),
        TextureRegion.new(texture, 100, 100, 100, 100),
        TextureRegion.new(texture, 0,   100, 100, 100)
    }
    for ii = 1, #regionList do
        local bitmap = Bitmap.new(regionList[ii])
        stage:addChild(bitmap)
    end

The last method to load a serious of images is probably the best method.  This method uses a texture atlas just like the previous example, but it requires you to use "Gideros Texture Packer" tool to create the texture atlas file and an accompanying text file that includes the locations of all of the smaller images.

    local frameList = {
        "frame_01.png",
        "frame_02.png",
        "frame_03.png",
        "frame_04.png"
    }
    local pack = TexturePack.new("frames.txt", "frames.png")
    for ii = 1, #frameList do
        local region = pack:getTextureRegion(frameList[ii])
        local bitmap = Bitmap.new(Texture.new(region))
        stage:addChild(frameBitmaps[ii])
    end

When you create a texture atlas with the "Gideros Texture Packer" tool it creates a large image with all of the smaller images and a text file that lists the names of the smaller files and where they are located in the big image.  So even though you've combined all of the smaller files you still need to remember their names, or you could just look at the text file.

The Gideros Studio "Texture Pack" example loads multiple images this way.  Try it out and see what it does.  It is a little character in a canoe.  Notice that when the paddle reaches the back of the canoe it does a very strange teleportation trick and appears on the opposite side of the canoe suddenly.  The animation isn't setup correctly.  Can you figure out how to fix it?  I'll give the answer in the next paragraph.  If you want to figure it out on your own, don't read on but try to figure it out first.

The example animation includes a list of bitmaps in a table and self.anim points to it.  That list includes frames 1 to 13.  You need to change that list so that after it gets to 13 it decreases down to 12, 11, 10, until it gets to 1.

If you aren't sure how to fix it then just start making changes.  Don't be afraid to experiment.  Change the numbers for the bitmaps and run it and see what happens.  For fun, you could change the order of the numbers so that the frames are completely of order and jump all over.  Or you could make the paddle do a wiggle motion by toggling between 2 frames over and over.

MovieClip Animations
--------------------

To create a complex animation like a character that walks in 4 directions (north, east, south, and west) with actions like standing, walking, running, jumping, and swinging a sword you will need frames for all directions and actions.  That can add up to a lot of frames and turn into some complex code.

The MovieClip class makes it easy to animate lots of frames.  The MovieClip class can store all of the frames of an animation and play it on its own.  You can store all of the different directions in the MovieClip and you can even tell it to loop so that when it reaches a certain frame it will jump to another image so you can have multiple loops in the same MovieClip.

Here is some demo code showing how to load and use a MovieClip frame animation.  Load it and see what it does.

    AnimatedSprite = Core.class(Sprite)

    function AnimatedSprite:init(bitmaps, directions, frames, animation_speed)

        self.bitmaps = bitmaps
        self.directions = directions
        self.frames = frames
        self.animation_speed = animation_speed

        local movieclip_parts = {}
        local movieclip_actions = {}
        for ii = 0, self.directions-1 do
            for jj = 0, self.frames-1 do

                -- Store the bitmap and timing
                local frame = ii * self.frames + jj
                bitmap = self.bitmaps[frame + 1]
                local start_time = frame * self.animation_speed + 1
                local end_time = start_time + self.animation_speed - 1
                movieclip_parts[#movieclip_parts+1] = {start_time, end_time, bitmap}

            end

            -- Add the looping actions
            local start_time = ii * self.frames * self.animation_speed + 1
            local end_time = (ii+1) * self.frames * self.animation_speed
            movieclip_actions[#movieclip_actions+1] = {end_time, start_time}

        end

        self.movieclip = MovieClip.new(movieclip_parts)
        for ii = 1, #movieclip_actions do
            self.movieclip:setGotoAction(movieclip_actions[ii][1], movieclip_actions[ii][2])
        end
        self:addChild(self.movieclip)
        self.direction = 0
    end

    function AnimatedSprite:setDirection(d)
        self.direction = d % 8
        --local current_frame = self.movieclip:getFrame()%self.animation_speed*self.frames
        self.movieclip:gotoAndPlay(self.direction*self.animation_speed*self.frames+1) -- +current_frame
    end

    -- Create the bitmaps (this will change depending on your image source)
    function bitmapsFromTextureAtlas(filename, width, height, directions, frames)
        local texture = Texture.new(filename)
        local bitmaps = {}
        for yy = 0, directions-1 do
            for xx = 0, frames-1 do
                local region = TextureRegion.new(texture, width*xx, height*yy, width, height)
                local bitmap = Bitmap.new(region)
                bitmap:setAnchorPoint(.5, .5)
                bitmaps[#bitmaps+1] = bitmap
            end
        end
        return bitmaps
    end

    local bitmaps = bitmapsFromTextureAtlas("dragon.png", 75, 70, 8, 10) -- 750/10, 560/8

    -- Create the animated sprite, set its position, and add it to the stage
    sprite = AnimatedSprite.new(bitmaps, 8, 10, 4)
    sprite:setPosition(application:getContentWidth()/2, application:getContentHeight()/2)
    stage:addChild(sprite)

    -- Randomly change directions
    local function onTimer(event)
        sprite:setDirection(math.random(1,8))
    end
    local timer = Timer.new(600*math.random(1,4), 0)
    timer:addEventListener(Event.TIMER, onTimer)
    timer:start()

The first half is the code that manages the MovieClip for us, that is our AnimatedSprite definition.  We won't need to change much there.  The second half of the example starts with the comment `-- Create the bitmaps`.  We will want to customize everything from that point on in the future.

The first thing we will want to customize is how we obtain our bitmaps.  Earlier in this lesson we looked at all of the ways of creating bitmaps.  In this example we are getting the bitmaps from a texture atlas that wasn't created with "Gideros Texture Packer" so we have to specify the location of all of the smaller bitmaps.

The next part creates the animated sprite, sets its position, and adds it to the stage.  The last parameter of AnimatedSprite.new() determines how fast the animation is, in this case it is set to 4.  The application displays 60 frames per second. The number 4 represents how many of those frames each bitmap will stay on the screen.  If we changed the 4 to a 1 then each MovieClip frame will flash for a 60th of a second.  A value of 30 means each bitmap would display for a half a second.  60 would be an entire second.  Why don't you change the values and see how the animation changes.

The last section of the code example above randomly changes the direction after a random time.  We will eventually remove that code and replace it with user input.

TNT Animator Studio
-----------------------

[TNT Animator Studio](http://www.tntengine.com/) is a 3rd party solution that allows you to easily create animations, and it is free.  To use the app you need to have a texture pack that was created with Gideros Texture Packer.  Once you have a texture pack, you can load it with TNT Animator and then export out a .tan file.  In your Gideros project you want to add the file exported by TNT Animator (it will end with ".tan") and the tntanimator library files.  Be sure to right click on the library files and select "Exclude for Execution".  Be sure to look at the examples that come with TNT Animator.

This code will run and load an animation.

    local function is32bit()
        return string.dump(is32bit):byte(9) == 4
    end
    if is32bit() then
        require("tntanimator32")
    else
        require("tntanimator64")
    end

    -- Create the texture pack (Use Gideros Texture Packer to create this)
    local sprites = TexturePack.new("sprites.txt", "sprites.png")

    -- Create a TNT Animator Loader
    local spritesLoader = CTNTAnimatorLoader.new()
    spritesLoader:loadAnimations("sprites.tan", sprites, true)

    -- Create a TNT Animator
    local anim = CTNTAnimator.new(spritesLoader)

    anim:setAnimation("RUN_RIGHT") -- This name is defined in TNT Animator, it it isn't defined you will get an error!
    anim:addChildAnimation(anim)
    anim:playAnimation()
    anim:setPosition(160, 240)
    stage:addChild(anim)

MovieClip Tweening
-----------------------

The MovieClip class can do more than just manage your frame animations for you.  The MovieClip class also allows you to blend and move the bitmaps around in fancy ways using tweening.  Tweening is short for "inbetweening".  In animation you always have a starting and ending point for each motion.  The important frames are called keyframes.  Tweened frames are the frames between keyframes and they are usually figured out by some sort of automation.

The following MovieClip properties can be tweened.

    x
    y
    rotation
    scale
    scaleX
    scaleY
    alpha
    redMultiplier
    greenMultiplier
    blueMultiplier
    alphaMultiplier

That means any of those values can be automated so that they have a start value, an end value, and everything in between is tweened.  There are multiple ways those tweened values can be calculated.  For example, if you were tweening the position of a MovieClip it can either move at a constant rate, you can have it slowly speed up, slow down, or speed up and then slow down. The way that the tween values are calculated is called the easing function.

Most easing functions have an "in", an "out", and an "inOut" variety.  The "in" functions start slow and speed up, it is going "in" to the motion.  The "out" functions start fast and slow down.  The "inOut" functions speed up then slow down.

There are 11 easing types.  Instead of trying to describe them, run this sample code to see "linear" and the "inOut" varieties of the other 10.

    local t = {
        "linear", "inOutSine", "inOutQuadratic", "inOutCubic",
        "inOutQuartic", "inOutQuintic", "inOutExponential",
        "inOutCircular", "inOutBack", "inOutElastic", "inOutBounce",
    }
    for i,v in ipairs(t) do
        local textfield = TextField.new(nil, v)
        textfield:setTextColor(0xff00ff)
        local mc = MovieClip.new({{1, 120, textfield, {
            y = i*25,
            x = {50, 150, v},
        }}})
        mc:setGotoAction(120,1)
        stage:addChild(mc)
    end

7 easing types always move towards the goal: "sine", "quadratic", "cubic", "quartic", "quintic", "exponential", and "circular".  The difference between them is the speed of acceleration.  3 of them actually move towards and away from the goal: "back", "bounce", and "elastic".  The "linear" type moves towards the goal at a constant speed, it has no acceleration.

If you want to have some fun after the `x = {50, 150, v},` add these lines.

            rotation = {0, 360, v},
            redMultiplier = {1, 0, v},
            blueMultiplier = {0, 1, v},

The values you use to tween matter.  The x and y values are coordinates.  Rotation is degrees (0 to 360).  The scale, alpha, and multiplier values are all 0 to 1.  The color multipliers only work if that color is present in the original sprite.  So if the sprite is black, the color multipliers don't do anything.

One very fun thing to do is to find a sprite that is mostly one color and has highlights of another color and to tween the highlight color up and down, as if it were glowing.

GTween
---------

Tweening position isn't used as much for moving game characters since character movement is usually managed by user input.  Tweening objects like doors or game elements like buttons or the whole UI make much more sense and look very good.  Alpha is one of the items that can be tweened and by tweening alpha you can make a sprite fade in, so you will actually want to use that often.  However, you may not want to create a MovieClip object for that since you will only do it once or twice when a user uses your game.

GTween is lua file that you can include in your project to do the same things to sprites that aren't MovieClips. It uses the same set of easing functions but you have to name it with "easing.name".  It has a few more tricks up it's sleeve like options for delay, repeatCount, and reflect.  You can open the GTween example that comes with Gideros Studio to see how to use it.  The main code is below.

    local sprite = Bitmap.new(Texture.new("box.png"))
    stage:addChild(sprite)

    GTween.new(sprite, 2, {x = 240}, {delay = 0.2, ease = easing.outBounce, repeatCount = 2, reflect = true})

To understand more about tweening, read the [Tweener docs](http://hosted.zeh.com.br/tweener/docs/en-us/) (written for Flash, but still applies to GTween).  These docs also apply to MovieClip tweening.

Activity
--------

Now that you have the tools to create animatable sprites and some cool tweening effects you should go to the Gideros Mobile website and download the AssetLibrary and look in the "Sprites" and "Texture/spritelib_gpl" folders and see if you can turn any of them into animations.  I should give you a warning that this is a long and difficult process the first time you do it.  It isn't as easy as you think.

You could also go to the internet to get the images used in the AssetLibrary.  Here are the URL's:

- [http://www.widgetworx.com/widgetworx/resources/spritelib_gpl.zip](http://www.widgetworx.com/widgetworx/resources/spritelib_gpl.zip)
- [http://opengameart.org/content/fireball-spell](http://opengameart.org/content/fireball-spell)

You may also want to do a web search to find even more sprite sheets or search [opengameart.org](http://opengameart.org).

You should also experiment by tweening an object around the screen, either moving, rotating, scaling, changing color, appearing and disappearing, etc.

If you have an image editor you can also make your own images.  A good Mac image editor is [Pixen](http://pixenapp.com/).  You can also use the Gideros Texture Packer if you create a sequence of images.
