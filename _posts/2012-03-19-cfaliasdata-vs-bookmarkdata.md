---
layout:     default
title:      CFAliasData vs BookmarkData
date:       2012-03-19
editdate:   2020-05-11
categories: MacAdmin
disqus_id:  cfaliasdata-vs-bookmarkdata.html
render_with_liquid: false
---

## CFAliasData

A long time ago I wrote a utility named dockit to help manage the dock.  I didn't know what I was doing then and I never did finish the project.  The main point of dockit was to generate pesky CFAliasData, which required some Carbon calls (FSPathMakeRef and FSNewAlias).

I eventually figured out that the dock plist didn't actually require CFAliasData but would create it from a simple path if it was present.  And finally a month or so ago finally started managing my dock with [dockutil](https://github.com/kcrawford/dockutil), written by Kyle Crawford.

That takes care of the dock, but what about the Sidebar?  ~/Library/Preferences/com.apple.sidebarlists.plist still uses alias data even in 10.7, and it does NOT have a path key.  I've just avoided managing it.  But yes, this issue has been present for a long time.

I finally cleaned up the dockit code so that all it does is print out the CFAliasData for whatever path is passed to it.  This code is not pretty, I understand it, but I got it from somewhere else, so I don't really understand it that well.  And I don't exactly know C or Carbon API's well. There is very likely a much better way to do this.  I would LOVE if someone could clean this code up.  I hate messy looking code.  But anyway, it works.

At the bottom of this article I'm putting the source code for AliasData.c.  Sorry there is no GitHub link or nothing, I am not really good at that stuff.

## Bookmarks

There is a new kid in town called BookmarkData (since 10.6).  I've bumped into it a few places but mainly in the LaunchPad preferences, which really aren't preferences, but a sqlite3 database.  Yes, I actually figured out how to manage LaunchPad with a perl script and it's not simple.  But as part of it, you need to create the BookmarkData.  This is much easier than creating AliasData because in a perl script you can call Cocoa code using the PerlObjCBridge.  It's really easy in fact.

    use Foundation;
    my $path = "/"
    if ( -e $path ) {
        my $myFileURL = NSURL->fileURLWithPath_( $path );
        my $bookmark_data = $myFileURL->bookmarkDataWithOptions_includingResourceValuesForKeys_relativeToURL_error_(1, 0, 0, 0);
        my $bookmark_hex = $bookmark_data->description()->UTF8String();
        $bookmark_hex =~ s/[<> ]//g;
        my $bookmark_binary = pack( 'H*', $bookmark_hex );
    }

That's way easier than AliasData!  The main API is  [bookmarkDataWithOptions:includingResourceValuesForKeys:relativeToURL:error:](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSURL_Class/Reference/Reference.html).  I pass that call a "1", and I think that's because I'm creating a "NSURLBookmarkCreationMinimalBookmark".  Here's the enum for that value.  I think 1 represents NSURLBookmarkCreationMinimalBookmark anyway.  It works for LaunchPad anyway.

    NSURLBookmarkCreationPreferFileIDResolution            = ( 1UL << 8 ),
    NSURLBookmarkCreationMinimalBookmark                   = ( 1UL << 9 ),
    NSURLBookmarkCreationSuitableForBookmarkFile           = ( 1UL << 10 ),
    NSURLBookmarkCreationWithSecurityScope                 = ( 1UL << 11 ),
    NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess  = ( 1UL << 12 )

AliasData.c
-----------

Here's the source code for AliasData.c.  Last updated on 2012.03.19.

    /*
    gcc -arch i386 -O3 -o AliasData AliasData.c -framework Carbon
    */

    #   import <Carbon/Carbon.h>

    int makeDockItem(char *filepath, int start, int end)
    {
        int                     i;
        Boolean                 isAlias, isFolder;
        FSRef                   appFSRef;
        AliasHandle             myAliasH;
        OSStatus                anErr = noErr;
        SInt32                  value = 0;
        CFDataRef               tCFDataRef;
        CFDataRef               printMe;
        CFDictionaryRef         elementCFDictionaryRef;
        void*                   keys[1];
        void*                   values[1];
        CFStringRef             str;
        CFStringInlineBuffer    inlineBuffer;
        CFIndex                 cnt;
        CFIndex                 length;

        // Make sure it doesn't end with "/"
        for ( i = 0; filepath[ i ] != '\0'; i++ ) { }
        if (filepath[ i - 1 ] == '/') {
            filepath[ i - 1 ] = '\0';
        }

        // Make an FSRef for the file to be added
        anErr = FSPathMakeRef(filepath, &appFSRef, NULL);
        if (anErr == fnfErr) {
            fprintf(stderr, "File not found.\n");
            exit(1);
        } else if (anErr != noErr) {
            fprintf(stderr, "Trouble with the file. FSPathMakeRef error %d.\n", (int)anErr);
            exit(1);
        }

        // Make sure the file isn't an alias, and if it is resolve it.
        anErr = FSIsAliasFile (&appFSRef, &isAlias, &isFolder);
        if (anErr) {
            fprintf(stderr, "Error checking if the file is an alias or not.\n");
            exit(1);
        }
        if (isAlias) {
            anErr = FSResolveAliasFileWithMountFlags(&appFSRef, TRUE, &isFolder, &isAlias, kResolveAliasFileNoUI);
            if (anErr) {
                fprintf(stderr, "Alias could not resolved (FSResolveAliasFileWithMountFlags, the alias probably points to a non-mounted file system), will use the alias file.\n");
            }
        }

        //
        // Generate the xml stuff
        //

        // Create the _CFURLAliasData value for the new app
        if (noErr != (anErr = FSNewAlias(NULL,&appFSRef,&myAliasH)))
        {
            fprintf(stderr, "_CFURLAliasData could not be generated (FSNewAlias error: %ld).\n", anErr);
            return 0;
        }
        tCFDataRef = CFDataCreate(kCFAllocatorDefault,(UInt8*) *myAliasH,GetHandleSize((Handle) myAliasH));
        if (NULL == tCFDataRef)
        {
            fprintf(stderr, "_CFURLAliasData could not be generated (CFDataCreate failed, tCFDataRef == NULL).\n");
            return 0;
        }

        keys[0] = (void*) CFSTR("");
        values[0] = (void*) tCFDataRef;

        elementCFDictionaryRef = CFDictionaryCreate(kCFAllocatorDefault,(const void**) &keys,(const void**) &values,1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        if (NULL == elementCFDictionaryRef)
        {
            fprintf(stderr, "CFDictionaryCreate failed (elementCFDictionaryRef == NULL).\n");
            return 1;
        }

        // Print the sucker.
        printMe = CFPropertyListCreateXMLData(NULL, elementCFDictionaryRef);
        str = CFStringCreateFromExternalRepresentation(NULL, printMe, kCFStringEncodingUTF8);
        length = CFStringGetLength(str);
        CFStringInitInlineBuffer(str, &inlineBuffer, CFRangeMake(0, length));

        for (cnt = start; cnt < (length - end); cnt++) {
            UniChar ch = CFStringGetCharacterFromInlineBuffer(&inlineBuffer, cnt);
            printf ("%c", ch);
        }

        CFRelease(str);
        CFRelease(printMe);
        CFRelease(tCFDataRef);
        CFRelease(elementCFDictionaryRef);

        return 0;
    }

    int
    main(int argc, char *argv[])
    {
        int i;

        if ( argc < 2 ) {
            fprintf(stderr, "Usage: AliasData <path> [...<path>]\n");
            exit( 1 );
        }

        // Get the file to be added
        for (i = 1; i < argc; i++) {
            makeDockItem(argv[i], 192, 26); // This gets rid of the beginning and end of the Plist file.
        }
        return 0;
    }

## Using AliasData

I'm not going to write a full script to manage the sidebar, but I'll show how to load the current sidebar and add an item (without checking to see if it exists, I'm just doing this as an FYI).  I'll be using my [perlplist.pl](http://www.magnusviri.com/computers/perlplist.html) code to manage the plist file.  I even tested this a little and it works.  I couldn't run this script while logged in though.  I don't know what process is in charge of reading the sidebar prefs but killing Finder and the Dock didn't refresh the prefs.


    #!/usr/bin/perl

    $debug = 1;

    use Foundation;
    use lib "/usr/local/lib/";
    require "perlplist.pl";

    my $alisDataPath = "/usr/local/bin/AliasData";

    #
    my $item_to_add = $ARGV[0];
    if ( ! -e $item_to_add ) {
        die "$item_to_add doesn't exist.";
    }

    # Get the item name
    my $name = $item_to_add;
    $name =~ s/\/+$//; # Remove any trailing /'s
    $name =~ s/.*\///; # Remove everything up to the last /

    # Get the alias data
    my $aliasDataBase64 = `$alisDataPath \"$item_to_add\"`;
    $aliasDataBase64 =~ s/\s+//g;
    $aliasDataBin = cocoaDataFromBase64( $aliasDataBase64 );

    # Read the plist file
    my $filepath = defined $ARGV[1] ? $ARGV[1] : "/Users/test/Library/Preferences/com.apple.sidebarlists.plist";
    my $dict;
    if ( -e $filepath ) {
        $dict = loadDefaults( $filepath );
    } else {
        die "Can't open $filepath.";
    }

    # I got this data from com.apple.sidebarlists.plist
    my $generic_folder_icon = cocoaDataFromBase64('SW1nUgAAABwAAAAAU1lTTAAAABAAAAAAZmxkcg=='),

    # Make the entry
    my $item = NSMutableDictionary->dictionary();
    setPlistObject( $item, "Alias", $aliasDataBin );
    setPlistObject( $item, "Name", $name );
    setPlistObject( $item, "Icon", $generic_folder_icon );

    printObject( $item ) if $debug;

    # Find out how many items there are.
    my $favoritesNSArray = getPlistObject($dict, "favorites", "VolumesList");
    my $count = $favoritesNSArray->count;

    setPlistObject($dict, "favorites", "VolumesList", $count+1, $item );
    saveDefaults( $dict, $filepath );
