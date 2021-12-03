---
layout:     default
title:      "Mobile Game Programming Lesson 1"
date:       2012-05-24
editdate:   2020-05-11
categories: Graveyard
disqus_id:  mobile-game-programming-lesson-1.html
render_with_liquid: false
---

What is a program?
--------------------

We build computers to be able to do a variety of tasks.  One of the first way to program the computers was with punch cards.  In the early days of computers they build a devices that could read the holes in punch cards.  Punch cards were stiff pieces of paper with rows and columns where you could poke a hole.  Each hole would tell the computer a different thing.  You put the card into the reader and it would read the commands and perform them, then when it was done it would print out the results and it was finished and it would wait for the next card.

Today we don't use punch cards, but most programming is in that style, that is, we give the computer a set of instructions.  The computer follows the instructions just like if it were following a recipe to make food, step by step.  This is called imperative programming.

Program building blocks
------------------------------

Programming is built from a basic set of instructions, like building blocks.  You will see these elements in almost all programs.  First, you have data: numbers, words, images, sounds, etc.  Let's talk about the game Tic Tac Toe.  In that game, you have a 3 x 3 grid of squares.  Each square has 3 possible states, blank, an X, or an O.  That is data.

The next building block are variables.  The variable is basically a name that allows you to set or get something.  It's the gateway to a computer's memory.  For example, if I describe the color blue, you are able to think of what the color blue looks like.  Blue is the name that stores our memory of what it looks like.  Chocolate is another name that is linked to a memory we have.  We do this naturally and everything has names and we rarely think about it.

On the other hand, computers forget all the time.  In fact, the memory in a computer is so limited you actually want it to forget and to forget often, otherwise you'd fill it up and you wouldn't be able to tell it anything new.  We forget often too.  I don't really remember what I ate for dinner 2 weeks ago.

To compare this with a game again, I could give the Tic Tac Toe data a name, for example, I could call it the game board.  When I ask what is on the game board I can see the squares with X, O, and blanks.  I could also change the game board and put an X or an O on a square.

For us, "game board" is obvious.  But seriously, a computer doesn't know a Tic Tac Toe game board from any other game board.  It has to be told everything, every time you want to do something.  Computers are still very basic.

The next building block are questions.  Your computer programs have building blocks for asking questions.  When asking a question in a computer program, you have to indicate what the computer will do depending on the answer to the question.  For example, in Tic Tac Toe, after each turn, the main question is did anyone win?  If someone has won or it is a tie you need to start over.  If nobody has won, you need to go back and give the next player a move.

Which brings us to loops.  Repetition is everywhere in life and it is in computers also.  In a game of Tic Tac Toe, player 1 draws an X on the game board, player 2 draws an O, and that is repeated until one of the players wins or all 9 squares are filled.  That's a loop.

Our first program
--------------------

We can now write out, in regular language, the steps to play Tic Tac Toe.

    1. Draw 2 vertical lines and 2 horizontal lines so it makes a 3 x 3 grid
    2. Have player 1 draw an X
    3. Check to see if player 1 won or if it is a tie
    4. Have player 2 draw an O
    5. Check to see if player 2 won or if it is a tie
    6. Loop back to 2

With these instructions, as soon as a player wins or there is a tie, the program ends.  When a program ends, it ends completely.  So if we want to keep playing, we have to add a step to loop the whole thing.

    7. Loop back to 1

To be honest, no computer today would understand those instructions, they aren't specific enough.  Let's rewrite it more like how a computer would understand.  This still isn't a real program, but this is how a computer would like to see it.

    repeat
        draw 2 vertical lines and 2 horizontal lines so it makes a 3 x 3 grid
        repeat
            have player 1 draw an X
            check to see if player 1 won or if it is a tie
            have player 2 draw an O
            check to see if player 2 won or if it is a tie
        end
    end

We indent the code between the "repeat" and "end" because it helps us identify the beginning and end of our loops.  The indentation is balanced, that is, for every "repeat" there is an "end" that marks where it ends.

Event driven programming
--------------------

The game above is an imperative game.  That is, it starts at the top, lists a bunch of steps, and then quits when it reaches the bottom.  We had to add a loop around the whole thing to keep it from quitting the moment the game was over.

There is another style of programming that wont quit a program when it reaches the bottom and it's called event driven programming.  The way this style works is almost identical to imperative, it starts at the top and does all the steps until it reaches the bottom.  But there are 2 things that are different.  First, it wont quit when it reaches the bottom.  Second, you set aside code that doesn't run the first time but it waits until an event happens and then it runs it.

What type of events are we talking about?  On a mobile device, the main event we care about is when the screen is touched.

Let's rewrite Tic Tac Toe using event driven programming.

    start game
        (everything between "start game" and "end" isn't executed, it's saved for later
        draw 2 vertical lines and 2 horizontal lines so it makes a 3 x 3 grid
    end

    screen touched event
        (everything between "screen touched event" and "end" isn't executed, it's saved for later
        depending on the player, put an X or O on the square touched (if it is empty)
        if a player won or it is a tie then...
            start game (now run the code that we saved)
        end
    end

    start game (now run the code that we saved)

In this example, the "start game" section and the "screen touched event" sections are not run when the computer reads them.  They are stored in memory and "start game" and "screen touched event" is how the computer can go find those instructions in the future.

The last line of the program then tells the computer to run the "start game" code.  When it finishes that then the computer waits for the screen to be touched.  When we touch the screen it runs the "screen touched event".

Event driven programming works really well when we have to draw the screen and wait for the user to do things, like touch the screen.

Adding game board variable
--------------------

Lets create a game board variable that will allow us to store the state of the game board.  We do this by modifying the start game code.

    start game
        draw 2 vertical lines and 2 horizontal lines so it makes a 3 x 3 grid
        game board =
            _ _ _
            _ _ _
            _ _ _
    end

My first step is to draw the lines on the screen and then making the "game board" variable.  Drawing something on the screen is a totally different act than creating variables.  The lines I draw on the screen may create a visual board, but that doesn't mean anything to a computer.  I actually need to tell the computer that it needs to remember a 3 x 3 grid by making a variable.  In the above code, I used an underscore to represent that the computer needs to remember a 3x3 grid.

Which player is it?
---------------------------

We will keep track of which player touched the screen by just toggling the turn.  So the first touch is player 1. The second touch is player 2.  The next touch is player 1.  Etc.,.

    start game
        draw 2 vertical lines and 2 horizontal lines so it makes a 3 x 3 grid
        game board =
            _ _ _
            _ _ _
            _ _ _
        player = 1
    end

    screen touched event
        if player 1 then
            place an X if empty
            player = 2
        else
            place an O if empty
            player = 1
        end
        if a player won or it is a tie then
            start game
        end
    end

    start game

Notice that we set player = 1 in "start game".  Then when each player goes, we change player to the next player.  This is how we are toggling whose turn it is.

Checking for a win
------------

What else needs to be done?  What does "if a player won" mean?  To tell the computer how to check for a win we need to figure out how people do it. How do people do it?  Well, although you do it without thinking, if you stop and look at what you do, it is probably something like this.  First, you could look at the horizontal lines.

    ? ? ?
    - - -
    - - -

    - - -
    ? ? ?
    - - -

    - - -
    - - -
    ? ? ?

Then the vertical lines.


    ? - -
    ? - -
    ? - -

    - ? -
    - ? -
    - ? -

    - - ?
    - - ?
    - - ?

And finally the diagonals.

    ? - -
    - ? -
    - - ?

    - - ?
    - ? -
    ? - -

If any of those positions have all X's or O's, then someone won!  That's how a person checks for a win.  The computer has to do the same thing, but we need to tell the computer how to do it.  To do this in a program, you would have to name each square.  I'm going to use numbers.

    11    21    31
    12    22    32
    13    23    33

Or more specifically I'm going to name it using brackets and numbers.

    [1][1]  [2][1]  [3][1]
    [1][2]  [2][2]  [3][2]
    [1][3]  [2][3]  [3][3]

Then to check to see if there is a win, we write something like this.

    if board[1][1] is the same as board[2][1] and is the same as board[3][1] then
        we have a winner!
    elseif board[1][2] is the same as board[2][2] and is the same as board[3][2] then
        we have a winner!
    ...
    end

We'd have to write 8 of those if's to check every single spot, but since our board is nothing but numbers, why don't we just count from 1 to 3 and check in a loop, like the next example.

    for xx=1,3,1 do
        if boxes[xx][1].player == currentPlayer and boxes[xx][2].player == currentPlayer and boxes[xx][3].player == currentPlayer then
            win = 1
        end
    end

Now this is real computer code.  The computer can understand this.  I don't expect you to understand what all of this code does because I haven't explained any of it.  However, you understand what we are doing, and you might be able to figure out based on what we are doing what this code does.

If you don't understand the details, don't worry.  As a programmer, you will often need to focus in on something very detailed and ignore everything else.  And at other times, you need to zoom out and focus on the general layout of everything but ignore the details.  Right now we zoomed out so don't worry about those details.

Drawing on the screen
----------------

Now we are going to zoom in and focus on the details of drawing.  In any game we need to draw on the screen to interact with our user.  How would you draw a Tic Tac Toe game board in real life?  First, you get the paper!  That's right, our game has a piece of paper, except we are going to call it the stage.  We are calling it a stage because it is a place with actors and scenes, as if we are putting on a play.

Whenever we draw, we add something to the stage.  Everything we add is a child of the stage.  The stage can have many children, but each child only has one parent, the stage.  That's why we call it parent and child, it reprents a hierarchy.

So back to drawing.  How do you draw a line?  Well, after you have a piece of paper, you get a pen!  The same is true with programs!  We are going to create a pen, but it isn't really a pen, it's more like the ink on the paper and it is called a "Shape".  To create it we use `Shape.new()`.  This will actually create something in memory, and we want to remember it, so we need a variable.  How about "board"?

    board = Shape.new()

We now have the variable named `board` that points to our shape in the computer's memory and we will be able to find the shape in the computer's memory by using the `board` variable.

We need to tell the shape what it looks like, that is the first thing we do.  We are setting it to just draw a line (not fill the area between lines), and to draw a line 3 pixels wide with the color black (0x000000 is black).

    board:setFillStyle(Shape.NONE)
    board:setLineStyle(3,0x000000)

Now again, how do we draw a line after we have the paper and pen?  We put the pen on the paper and we start to move it.  If we want to draw a box, we start in one corner and move to each other corner.  Here is some real code that places the pen on the paper (moveTo) and moves the pen around (lineTo).

    board:beginPath(Shape.NON_ZERO)
    board:moveTo(50, 50)
    board:lineTo(50, 100)
    board:lineTo(100, 100)
    board:lineTo(100, 50)
    board:lineTo(50, 50)
    board:closePath()
    board:endPath()

That draws a box.  You might notice, this is a lot of code!  Yes, you are right.  Drawing takes a lot of code.

If we wanted to draw a Tic Tac Toe board, we would need to draw 4 lines, two that start from the top and move to the bottom, and 2 that start at the side and move to the other side.  Each time we pick up the pen we would use `moveTo()`.  Each time we drag the pen accross the paper we use `lineTo()`

Notice that when I use parenthesis, `()`, that is always telling the computer to do something.  Often you will put words inside of the parenthesis.  You do that because you are telling the computer _how_ to do something.  So for example, when I set the line style, I tell it to set the line style to 3 pixels and the color black with this code: `board:setLineStyle(3,0x000000)`.  If I wanted a 2 pixel line, I would just change it to this: `board:setLineStyle(2,0x000000)`.

Activity
-------------

For fun, why don't you spend some time drawing.  Open up Gideros Studio and create a new project. Create a new file and name it main.lua.  Double click the filename so you get the editor.  Type or copy and paste this code into the editor.

    board = Shape.new()
    board:setFillStyle(Shape.NONE)
    board:setLineStyle(3,0x000000)
    board:beginPath(Shape.NON_ZERO)
    board:moveTo(50, 50)
    board:lineTo(50, 100)
    board:lineTo(100, 100)
    board:lineTo(100, 50)
    board:lineTo(50, 50)
    board:closePath()
    board:endPath()
    stage:addChild(board)

Now click the icon that looks like a joystick to start the Gideros Player application.  Then click the triangle play button to run it.

Did it work? If you typed it in maybe you typed something in wrong.  Make sure you haven't spelled anything wrong.  Make sure that that you are using a zero and not capital O's.  Make sure you don't have spaces between board and the colon and the command after the colon.  Make sure that everything is capitalized exactly how you see it.

Here are some things you can do to change this up.

- Remove one of the lineTo commands and draw a triangle.
- Copy a board:lineTo() command and paste several lines.  Then change the numbers in each one to make a huge blob! Make sure the numbers are less than 320 and 480 (the width and height of the device).
- Change the color.  The "0x" must not change, but everything after that can be 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, a, b, c, d, e, or f, and you must have 6 of those digits.  Try "0x123456", or "0xffffff", or "0xfedcba". Note: a = 10, b = 11, c = 12, etc.,.
- Change the line width from 3 to something else like 20, or 1, or even 0.
- Change setFillStyle(Shape.NONE) to setFillStyle(Shape.SOLID)
- Change one of the lineTo commands in the middle to a moveTo.  Notice it doesn't draw a line to the moveTo.

Buttons
------------------------

We've done a bunch of drawing!  I love to draw, but we need a way to tell these computer things what to do by touching the screen. So let's add some buttons that will do something when they are touched.  To turn the entire screen into a button just add these lines to the bottom of our program.

    function onTouch()
        print "Hi"
    end

    stage:addEventListener(Event.MOUSE_DOWN, onTouch)



When you run this code, you need to touch the mobile device (or click the simulator window on the computer--don't touch the computer, we don't have touch screen computers yet).  After touching/clicking you will see a "Hi" show on the Gideros Studio window where we type our code in what is called the debug console.

Well, what if we wanted to print something on the mobile device screen instead?  Change the middle of the onTouch() function so that the program looks like the following.

    function onTouch()
        titleField = TextField.new(nil, "")
        titleField:setPosition(10,10)
        stage:addChild(titleField)
        titleField:setText("Hi")
    end

    stage:addEventListener(Event.MOUSE_DOWN, onTouch)

When you run this code, you need to touch the phone (or click in the simulator window) to see the "Hi" show.  If you wanted to have a little bit of fun, you could replace the `titleField:setPosition(10,10)` to `titleField:setPosition( math.random(320), math.random(320) )`. Try it.

Full game
------------------------

We've talked about the Tic Tac Toe game quite a bit and we've done some drawing and buttons and things.  How about we see an actual Tic Tac Toe game in action.  This isn't a really fancy looking game.  And I don't expect you to understand much if any of the details.  But you should be able to get a general idea of what is going on.

Copy and paste this code into your project and start it up!

    -- Tic Tac Toe
    function checkForWin()
        local boxes = board.boxes
        local win = 0
        -- Check the horizontal lines
        for xx=1,3,1 do
            if boxes[xx][1].player == currentPlayer and boxes[xx][2].player == currentPlayer and boxes[xx][3].player == currentPlayer then
                win = 1
            end
        end
        -- Check the vertical lines
        for yy=1,3,1 do
            if boxes[1][yy].player == currentPlayer and boxes[2][yy].player == currentPlayer and boxes[3][yy].player == currentPlayer then
                win = 1
            end
        end
        -- Check the diagonal lines
        if boxes[1][1].player == currentPlayer and boxes[2][2].player == currentPlayer and boxes[3][3].player == currentPlayer then
            win = 1
        end
        if boxes[3][1].player == currentPlayer and boxes[2][2].player == currentPlayer and boxes[1][3].player == currentPlayer then
            win = 1
        end

        if win == 1 then
            gameOver = 1
            titleField:setText("Player "..currentPlayer.." wins!")
        elseif numberOfTurns == 9 then
            gameOver = 1
            titleField:setText("Tie Game!")
        end

    end

    function boxTouched(box, event)
        if gameOver == 1 then
            -- Start the game over
            newGame()
            event:stopPropagation()
            return
        end

        if box:hitTestPoint(event.x, event.y) then
            if box.player == 0 then
                box.player = currentPlayer
                numberOfTurns = numberOfTurns + 1
                checkForWin()

                local width = board.width
                local height = board.height

                if currentPlayer == 1 then
                    -- draw x
                    box:setLineStyle(board.lineWidth,0xff0000)
                    box:beginPath(Shape.NON_ZERO)
                    box:moveTo(0,0)
                    box:lineTo(width/3, height/3)
                    box:moveTo(width/3,0)
                    box:lineTo(0, height/3)
                    box:closePath()
                    box:endPath()
                    if gameOver == 0 then
                        currentPlayer = 2
                        titleField:setText("Player O's turn.")
                    end
                else
                    -- draw o
                    box:setLineStyle(board.lineWidth,0x0000ff)
                    box:beginPath(Shape.NON_ZERO)
                    box:moveTo( width/6, 0 )
                    box:lineTo( width/3, height/6 )
                    box:lineTo( width/6, height/3 )
                    box:lineTo( 0, height/6 )
                    box:lineTo( width/6, 0 )
                    box:closePath()
                    box:endPath()
                    if gameOver == 0 then
                        currentPlayer = 1
                        titleField:setText("Player X's turn.")
                    end
                end
            end
            event:stopPropagation()
        end
    end

    function newGame()
        currentPlayer = 1
        gameOver = 0
        numberOfTurns = 0
        titleField:setText("Player X's turn.")

        local width = board.width
        local width13 = width/3
        local width23 = width13*2
        local height = board.height
        local height13 = height/3
        local height23 = height13*2
        local color = board.color
        local lineWidth = board.lineWidth

        -- Criss cross
        board:clear()
        board:setFillStyle(Shape.NONE)
        board:setLineStyle(lineWidth,color)
        board:beginPath(Shape.NON_ZERO)
        board:moveTo(width13, 0)
        board:lineTo(width13, height)
        board:moveTo(width23, 0)
        board:lineTo(width23, height)
        board:moveTo(0, height13)
        board:lineTo(width, height13)
        board:moveTo(0, height23)
        board:lineTo(width, height23)
        board:closePath()
        board:endPath()

        -- Buttons
        for xx=0,2 do
            for yy=0,2 do
                local box = board.boxes[xx+1][yy+1]
                box:clear()
                box:setFillStyle(Shape.NONE)
                box:setLineStyle(0)
                box:beginPath(Shape.NON_ZERO)
                box:moveTo(width13,0)
                box:lineTo(0, height13)
                box:closePath()
                box:endPath()
                box:setPosition(width13*xx,height13*yy)
                box.player = 0
            end
        end

    end

    -- The message field

    local titleFieldX = 10
    local titleFieldY = 10
    titleField = TextField.new(nil, "")
    titleField:setPosition(titleFieldX,titleFieldY)
    stage:addChild(titleField)

    -- Create the board

    board = Shape.new()
    board.width = 300
    board.height = 300
    board.lineWidth = 3
    board.color = 0x000000
    board:setPosition(10,20)
    stage:addChild(board)
    board.boxes = {}
    for xx=1,3,1 do
        board.boxes[xx] = {}
        for yy=1,3,1 do
            local box = Shape.new()
            box:addEventListener(Event.MOUSE_DOWN, boxTouched, box)
            board.boxes[xx][yy] = box
            board:addChild(box)
        end
    end

    currentPlayer = 1
    gameOver = 0
    numberOfTurns = 0

    newGame()

Final words
------------------------

You might notice that this is an awful lot of code.  You are right!  Telling a computer what to do is almost like telling a baby what to do.  Not only does a baby need everything explained, but it takes a long time to figure out how to tell the baby what to do!  It takes a long time to figure out how to tell a computer what to do because half of the time it doesn't understand anything you are saying!

It's pretty rare for a programmer to write something from scratch from top to bottom.  Most programmers start with a skeleton of a program that barely does anything and they slowly fill in the details.  Remember I said you have to zoom in and out?  Well, you start zoomed out with just a general idea of what to do and you slowly zoom in and fill in the details until you have a working game.

This lesson started out by thinking about the game from scratch.  And slowly we added details like how to check to see if there was a win.  Then we talked about drawing the board.  Then I skipped a bunch of details right to the finished game.

The rest of this book will try to teach you how to come up with a basic idea for a game and slowly fill in the details so that you can make your own games from scratch!  It's a lot of work, but guess what, game programmers do this because they love to program and they love making games.  Creating games is not the same as playing games.  You will certainly get to play games along the way, but the fun is a different type of fun.  If you stick with it, your reward will come.
