---
layout:     default
title:      "shouldAutorotateToInterfaceOrientation on iPad with 2 view controllers"
date:       2010-10-07
editdate:   2020-05-11
categories: Graveyard
disqus_id:  shouldautorotatetointerfaceorientation-on-ipad-with-2-view-controllers.html
---

While making Pumpkin Face compatible with the iPad I found out that rotation messages are only sent to the first view controller of the first view added to the window. This post describes how to send rotation messages to multiple view controllers (which you shouldn't do anyway but whatever).

So in Pumpkin Face, our main app delegate looked something like this.

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        //...
        [window addSubview:gameScreenViewController.view];
        [window addSubview:titleScreenViewController.view];
             //...
    }

Even though we had `shouldAutorotateToInterfaceOrientation` (code below) in the both view controller .m files, the 2nd view controller that was added never rotated. In fact, if we changed the order, it was always the 2nd one that wouldn't rotate.

    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }

Our solution was to create a new UIViewController subclass and all it had was the above method. Then in our main app delegate, we add the view of this new view controller to the window and then add the title screen view controller and the game view controller to the new UIViewController subclass. So now it looked like this:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions (NSDictionary*)launchOptions
    {
        //...
        mainViewController = [[MainViewController alloc] init];
        [window addSubview:mainViewController.view];
        [mainViewController.view addSubview:canvasViewController.view];
        [mainViewController.view addSubview:titleViewController.view];
        //...
    }

And it works flawlessly. :)
