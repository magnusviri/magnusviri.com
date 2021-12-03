---
layout:     default
title:      "Perl script that finds the seconds until the next day"
date:       2016-04-19
editdate:   2020-05-11
categories: Mac
disqus_id:  seconds-until-next-day.html
render_with_liquid: false
---

Here's a script I wrote that it turned out I didn't need.  I knew it'd get lost on my computer hard drive and maybe I'd want it someday.  This webpage has been a great way for me to find stuff in the future, so here it is.  It basically acts like an alarm clock (or cron job) by sleeping and then doing something at a given day and hour, then waits for that time again.  The day is for the day of the week (not month day).

    #!/usr/bin/perl -w

    use strict;
    use DateTime;

    my @dayOfWeek_hour_min = ( 2, 2, 0 ); # 1-7 [1=M 2=T 3=W 4=H 5=F 6=S 7=U], 0-23, 0-59

    while ( 1 ) {
        my $seconds = seconds_until( @dayOfWeek_hour_min );
        sleep $seconds;
        # DO SOMETHING
    }

    sub seconds_until {
        # This prints out the seconds until the next day-of-week, hour, minute.
        my ( $goal_day, $goal_hour, $goal_minute, $offset ) = @_;
        $offset ||= 0;
        my $now = DateTime->now;
        $now->set_time_zone( 'local' );
        my $today = $now->clone();
        $today->truncate( to => 'day' );
        my $days = ( 7 - $today->day_of_week + $goal_day ) % 7 + $offset;
        $today->set_time_zone( 'UTC' );
        my $next_day = $today->add( 'days' => $days, 'hours' => $goal_hour, 'minutes' => $goal_minute );
        $now->set_time_zone( 'UTC' );
        my $difference = $next_day->subtract_datetime($now);
        my $seconds = 0;
        $seconds += $difference->{'days'}*60*60*24 if $difference->{'days'};
        $seconds += $difference->{'hours'}*60*60 if $difference->{'hours'};
        $seconds += $difference->{'minutes'}*60 if $difference->{'minutes'};
        $seconds += $difference->{'seconds'} if $difference->{'seconds'};
        #print localtime(time+$seconds)."\n";
        return seconds_until( $goal_day, $goal_hour, $goal_minute, 7 ) if ( $seconds < 0 );
        return $seconds;
    }
