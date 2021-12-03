---
layout:     default
title:      "UITableViewController with sections that need to be easily moved (design stage)"
date:       2010-10-13
editdate:   2020-05-11
categories: Graveyard
disqus_id:  uitableviewcontroller-with-sections-that-need-to-be-easily-moved-design-stage.html
render_with_liquid: false
---

I have a subclass of a UITableView that basically is a "detail" view for some object. It has lots of different size cells that need to be generated on the fly based on the data in the cell. I found some good examples on the web how to resize a UITableViewCell, but I wasn't (and still am not) sure what order the cells are going to be in.

The way Apple's template is set up, you basically have several methods and the NSIndexPath that says what type of cell is desired. That's easy to handle, I just put it all in a big switch statement.

But what if I wanted swap section 1 with section 3? Sure, I could just copy/paste the code in the switch statement, which is what I've always done before. The problem with this is that to resize a UITableViewCell you need to have code in several locations.

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

and

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

The problem got worse because I decided to use the section title to identify each cell. Maybe I shouldn't be doing this, but whatever.

    - (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section

And even worse, some sections had more than one cell.

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

That's 4 methods that set the order of everything using switch statements. I knew that down the road I'd regret using a switch statement. So what I did was moved all of the settings out of those methods and each section had a method that returned the desired data for that section only. So here is my versions of those 4 methods.

    #define FONT_SIZE 17.0f
    #define CELL_CONTENT_WIDTH 320.0f
    #define CELL_CONTENT_MARGIN 10.0f

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return [[self desiredData:@"numberOfRowsInSection" forSection:section forRow:-1] intValue];
    }

    - (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
    {
        return [self desiredData:@"titleForHeaderInSection" forSection:section forRow:-1];
    }

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        NSString *text = [self desiredData:@"text" forSection:[indexPath section] forRow:[indexPath row]];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        float height = size.height + [[self desiredData:@"additionalHeight" forSection:[indexPath section] forRow:[indexPath row]] floatValue];
        return MAX(height, 44.0f) + (CELL_CONTENT_MARGIN * 2);
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *CellIdentifier = @"Cell";
        UILabel* label = nil;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
            label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [label setTag:1];
            [[cell contentView] addSubview:label];
            [[cell contentView] addSubview:favoriteButton];
        }
        if ( !label )
            label = (UILabel*)[cell viewWithTag:1];

        // Configure the cell.
        [[cell textLabel] setText:[self desiredData:@"label" forSection:[indexPath section] forRow:[indexPath row]]];
        [cell setAccessoryType:[[self desiredData:@"accessoryType" forSection:[indexPath section] forRow:-1] intValue]];
        [cell setSelectionStyle:[[self desiredData:@"selectionStyle" forSection:[indexPath section] forRow:-1] intValue]];

        // Label
        NSString *text = [self desiredData:@"text" forSection:[indexPath section] forRow:[indexPath row]];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        float height = MAX(size.height, 44.0f);
        [label setText:text];
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), height)];

        return cell;
    }

All of that is generic (and a lot of it was taken from other people's posts). This next method is the "gate keeper" that determines the real order.

    typedef enum {
        BlaSection,
        YaSection,
        QwerSection,
        AsdfSection
    } TableViewSections;

    - (id)desiredData:(NSString*)typeOfInfo forSection:(NSUInteger)section forRow:(NSUInteger)row
    {
        switch (section) {
            case BlaSection:
                return [self blaDataOfType:typeOfInfo forRow:row]; break;
            case YaSection:
                return [self yaDataOfType:typeOfInfo forRow:row]; break;
            case QwerSection:
                return [self qwerDataOfType:typeOfInfo forRow:row]; break;
            case AsdfSection:
                return [self asdfDataOfType:typeOfInfo forRow:row]; break;
            default:
                return nil; break;
        }
    }

Then each section determines the data with a method dedicated to it.

    - (id)blaDataOfType:(NSString*)typeOfInfo forRow:(NSUInteger)row
    {
        if ( [typeOfInfo isEqualToString:@"numberOfRowsInSection"] )
            return [NSNumber numberWithInt:1];
        else if ( [typeOfInfo isEqualToString:@"titleForHeaderInSection"] )
            return @"Bla;
        else if ( [typeOfInfo isEqualToString:@"text"] )
            return @"This is the resized text;
        else if ( [typeOfInfo isEqualToString:@"label"] )
            return @"This text is not resized and is bold (the default) label text";
        else if ( [typeOfInfo isEqualToString:@"accessoryType"] )
            return [NSNumber numberWithInt:UITableViewCellAccessoryNone];
        else if ( [typeOfInfo isEqualToString:@"selectionStyle"] )
            return [NSNumber numberWithInt:UITableViewCellSelectionStyleNone];
        else if ( [typeOfInfo isEqualToString:@"additionalHeight"] )
            return [NSNumber numberWithFloat:44.0]; // This is if I want the cell to be taller than the text
        return nil;
    }

Anyway, I think it's cool. I hope someone likes it. Sorry, I don't have an example project.

[Edit 2012-01-25: I don't know that doing this has worked out so great for me.  But the one thing that I've bumped into over and over, whether using SQL, Cocoa, Perl, whatever, is that being able to rapidly change stuff is CRITICAL. Using something like this makes it easier to change the order and add and remove stuff, but it isn't exactly obvious how to do it, so the obscurity is a drawback and I'm not sure if it makes it worth doing this at all. But yeah I'll probably keep doing it.]
