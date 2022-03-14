---
layout:     default
title:      Gideros GameKit Plugin API
date:       2012-05-10
editdate:   2020-05-11
categories: Gideros
disqus_id:  gideros-gamekit-plugin-api.html
---

This is an API for the [Gideros](http://giderosmobile.com) GameKit Plugin

I gleaned this from the GameKit plugin. I've mostly left it as C++ code. It's very far from complete or very good.  Hopefully one day I figure this all out.

Forum discussion

- [GameKit API](http://giderosmobile.com/forum/discussion/727/gamekit-api)

class GameKit : public GEventDispatcherProxy

    BOOL isAvailable()
        // Checks to see if OS is 4.1 or newer (minimum requirement for GameKit)
    authenticate()
        // Connects to game center
        //    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:]
        // dispatches event "authenticateComplete"
    loadFriends()
        // dispatches event "loadFriendsComplete"
        //    [[GKLocalPlayer localPlayer] loadFriendsWithCompletionHandler:]
        // returns array of friends
    loadPlayers(NSArray* identifiers)
        // dispatches event "loadPlayersComplete"
        //    [GKPlayer loadPlayersForIdentifiers:withCompletionHandler:]
        // returns array of tables with these fields: playerID, alias, isFriend
    reportScore(int64_t value, NSString* category)
        // saves score to server
        //    GKScore* score = [[[GKScore alloc] initWithCategory:category] autorelease];
        //    score.value = value;
        //    [score reportScoreWithCompletionHandler:]
        // dispatches event "reportScoreComplete"
    showLeaderboard()
        // presents GKLeaderboardViewController
    showAchievements()
        // presents GKAchievementViewController
    loadAchievements()
        // dispatches event "loadAchievementsComplete"
        // [GKAchievement loadAchievementsWithCompletionHandler:]
        // returns array of tables with these fields: identifier, percentComplete, completed, hidden
    reportAchievement(NSString* identifier, double percentComplete)
        // saves achievement
        //    GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        //    achievement.percentComplete = percentComplete;
        //    [achievement reportAchievementWithCompletionHandler:]
    resetAchievements()
        // [GKAchievement resetAchievementsWithCompletionHandler:]
        // dispatches event "resetAchievementsComplete"
    loadAchievementDescriptions()
        //    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:]
        // dispatches event "loadAchievementDescriptionsComplete"
        // returns array of tables with these fields: identifier, title, achievedDescription, unachievedDescription, maximumPoints, hidden

If there is an error, the event will return a table with these field values: errorCode, errorDescription
