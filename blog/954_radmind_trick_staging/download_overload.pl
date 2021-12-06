##!/usr/bin/perl -w

# If used as a command file:

#perl -pi -e's/^#//' /var/radmind/client/xhooks/download_overload.pl; mv /var/radmind/client/xhooks/download_overload.pl /usr/local/bin/download_overload.pl; chmod 755 /usr/local/bin/download_overload.pl
#/usr/local/bin/download_overload.pl -h radmind.example.com overload_name.T

################################################################################
# Copyright (c) 2010 University of Utah.
# All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appears in all copies and
# that both that copyright notice and this permission notice appear
# in supporting documentation, and that the name of The University
# of Utah not be used in advertising or publicity pertaining to
# distribution of the software without specific, written prior
# permission. This software is supplied as is without expressed or
# implied warranties of any kind.
################################################################################

die "Run me as root.\n" if $> ne 0;

# If you would like to use this script without having to install all of Xhooks
# just comment out the next 2 lines and set the variables right below it:

################################################################################
# download_overload.pl
#
# This script will download an overload out of context.  See the usage function
# below for more instructions.
#
# 1.0.8 2011.02.07 Added different method to find the radmind server, removed -c option, added -l (load balancing) and -p (port)
# 1.0.7 2010.09.09 Added -C option for lapply
# 1.0.6 2008.05.02 It now uses Xhooks paths and variables.
# 1.0.5 2006.09.25 Made it smarter so it wouldn't die if entman wasn't present (minimally tested)
#                  Can now specify the radmind server on the command line.
#                  Supports server auth mode (untested)
#                  specify checksum from command line--n still means no checksum (untested)
# 1.0.4 2005.07.12 Made it not delete anything.  Updated to be used in entman.
#                  Added support for multiple overloads.
# 1.0.3 2004.05.06 Switched to ulabmin radmind config file.
#                  Added n option.
#                  Added other stuff
# 1.0.2 2004.01.28 Fixed a few things.
# 1.0.1 2004.01.28 Added a flag to auto run ktcheck.
#       2004.01.28 Streamlined the transcript checking section.
#
################################################################################

use Getopt::Std;

####################################
# Get ARGs
#
getopts("a:Cfh:IklnNp:w:",\%options);

my $fsdiffpath;

if ( defined $FSDIFF_PATH ) {
  $fsdiffpath = $FSDIFF_PATH;
}
if ( defined $options{'a'} ) {
  $fsdiffpath = "/";
  chdir "/";
} else {
  $fsdiffpath = ".";
}

##
# Get the server
#
my $rserver;
my $rport;
my $auth_level;
my $error;

$rserver = $options{'h'} if defined $options{'h'};
$rport = $options{'p'} || "6222";
$auth_level = $options{'w'} || "0";

if ( ! defined $rserver or ! defined $rport or ! defined $auth_level ) {
  print "No radmind server can be found.  Use -h to manually specify a server or make sure the settings are readable.\n";
  usage();
}

##
# Get the other args
#
%radmind_options = (
  'server' => $rserver,
  'port' => $rport,
  'auth_level' => $auth_level
);

$radmind_options{'checksum'} = 0 if defined $options{'n'};
$radmind_options{'case_insensitive'} = 1 if defined $options{'I'};

###

my $lapply_options = "";
my $ktcheck_options = "";
my $fsdiff_options = "";
my $repo_options = "";

$ktcheck_options = ktcheck_args2( \%radmind_options );
$fsdiff_options = fsdiff_args2( \%radmind_options );
$lapply_options = lapply_args2( \%radmind_options );
$repo_options = repo_args2( \%radmind_options );

if ( defined $options{'C'} ) {
  # create missing intermediate directories.
  $lapply_options .= " -C";
}

if ( ! defined $RADMIND_FOLDER ) {
  $RADMIND_FOLDER = "/var/radmind/client";
}


####################################
# Other settings
#
$ignore_all_transcript = "admin_ignore_all.T";
$location_of_temp_transcript = "$RADMIND_FOLDER/temp_command.K";
# Generated from the above variables
$fsdiff_command = "/usr/local/bin/fsdiff -A $fsdiff_options -K $location_of_temp_transcript $fsdiffpath";
$lapply_command = "/usr/local/bin/lapply $lapply_options";

@transcripts = ();
foreach $i ( @ARGV ) {
  push @transcripts, get_overload_name( $i );
}

####################################
# Test stuff.

if ($#transcripts eq "-1") {
  usage();
}

if (! -w $RADMIND_FOLDER) {
  print "Can not write to $RADMIND_FOLDER. $!\n";
  usage();
}

####################################
# Check for a situtation that will probably error out.
#if (chomp (`pwd`) ne "/" and $fsdiffpath eq "." and ! defined $options{'f'}) {
#  print "This Mac is using relative paths, is not creating missing folders,";
#  print " and is not located at the root of the volume.  Are you sure you want to continue?\n";
  # put something here.
#}

####################################
# Run ktcheck if needed.
if (defined $options{'k'}) { # run ktcheck
  print "Running ktcheck\n";
  print "/usr/local/bin/ktcheck -c sha1 $ktcheck_options\n";
  system "/usr/local/bin/ktcheck -c sha1 $ktcheck_options";
}

####################################
# Check for transcript and run ktcheck if needed.
foreach $transcript ( @transcripts ) {
  while (! -e "$RADMIND_FOLDER/$transcript") {
    print "Could not find $RADMIND_FOLDER/$transcript\n";
    print "If the command file on the server does not include the desired overload, you will not be able to download it.\n";
    if (! ask_y_n_question("Do you want me to run ktcheck and try to download the transcript?\n")) {
      print "Exiting.\n";
      exit 1;
    }
    print "Running ktcheck\n";
    print "/usr/local/bin/ktcheck -c sha1 $ktcheck_options\n";
    system "/usr/local/bin/ktcheck -c sha1 $ktcheck_options";
  }
}



####################################
# GO

##
# Create blank negative
system "/bin/echo \"d $fsdiffpath 0755 0 0\" > $RADMIND_FOLDER/$ignore_all_transcript";

##
# Create command file
unlink $location_of_temp_transcript if -e $location_of_temp_transcript;
foreach $transcript ( @transcripts ) {
  $_ = $transcript;
  if ( /.K$/ ) {
    system "/bin/echo \"k $transcript\" >> $location_of_temp_transcript";
  } else {
    system "/bin/echo \"p $transcript\" >> $location_of_temp_transcript";
  }
}
system "/bin/echo \"n $ignore_all_transcript\" >> $location_of_temp_transcript";

##
# Run fsdiff | lapply

if (defined $options{'f'}) { # create missing folders

  ##
  # run fsdiff
  print "$fsdiff_command | grep -v \"^-\"\n";
  open (COMMAND, "$fsdiff_command | grep -v \"^-\" | ");

  my $dirpath;

  $fsdiff_output_send_to_lapply = "";
  # Loop through the input (which should be fsdiff)
  # Taken straight from lapply_crutch with only STDIN modified to be <>
  while ( $input = <COMMAND>) {
    @info = split (' ', $input);
    $number = @info;
    if ($number > 2) {
      if ($info[1] ne "") {
        if ($info[0] eq "d") {
          $path = $info[1];
          $path =~ s/\\b/ /g;;
          $dirpath = $path;
        } else {
          if ($info[0] eq "-" || $info[0] eq "+") {
            $path = $info[2];
          } else {
            $path = $info[2];
          }
          $path =~ s/\\b/ /g;;

          @folders = split ('/', $path);
          $depth = @folders;
          $dirpath = "";
          for ($i = 0 ; $i < $depth - 1 ; $i++) {
            $dirpath .= $folders[$i]. "/";
          }
          chop $dirpath;
        }
        if ($dirpath ne "" and ! -e $dirpath) {
          if ( defined $options{'N'} ) {
            print "Would create directory $dirpath\n";
          } else {
            print "Creating directory $dirpath\n";
            system "/bin/mkdir -p \"$dirpath\"";
          }
        }
      }
    }
    $fsdiff_output_send_to_lapply .= $input;
  }
  close (COMMAND);

  if ( ! defined $options{'N'} ) {
    ##
    # run lapply
    print "$lapply_command\n";
    open (COMMAND, "| $lapply_command");
    print COMMAND $fsdiff_output_send_to_lapply;
    print STDOUT $fsdiff_output_send_to_lapply;
    close (COMMAND);
  }
} elsif ( defined $options{'N'} ) {
  print "$fsdiff_command | grep -v \"^-\"\n";
  system "$fsdiff_command | grep -v \"^-\"";
} else {
  print "$fsdiff_command | grep -v \"^-\" | $lapply_command\n";
  system "$fsdiff_command | grep -v \"^-\" | $lapply_command";
}

# if anything was downloaded to /Users/template, ask if you want to recreate the home folder caches!


exit 0;

################################################################################
# Verify overload exists and is valid
sub get_overload_name {
  my ($overload_name) = @_;
  if ( $overload_name eq "" ) {
    print "Please enter the overload name.\n";
    return -1;
  }
  return $overload_name
}

################################################################################
# Just asks 3 times if the user wants to quit or continue
sub ask_y_n_question {
  ($message) = @_;
  $tempy = 0;
  do {
    $tempy++;
    print "$message (y/n)? ";
    chop($iwanna = <STDIN>);
    if ( defined $iwanna ) {
      if ( $iwanna eq "y" or $iwanna eq "Y" ) {
        return 1;
      } elsif ( $iwanna eq "n" || $iwanna eq "N") {
        return 0;
      }
    } else {
      return 0;
    }
  } while ($tempy < 4);
  return 0;
}

sub ktcheck_args2 {
  my ( $radmind_options ) = @_;
  my $ktcheck_options = "";
  $ktcheck_options .= " -c sha1";
  $ktcheck_options .= " -h $$radmind_options{server}" if defined $$radmind_options{'server'};
  $ktcheck_options .= " -p $$radmind_options{port}" if defined $$radmind_options{'port'};
  $ktcheck_options .= " -w $$radmind_options{auth_level}" if defined $$radmind_options{'auth_level'};
  $ktcheck_options .= " -Z $$radmind_options{compression_level}" if defined $$radmind_options{'compression_level'};
  return $ktcheck_options;
}

sub fsdiff_args2 {
  my ( $radmind_options ) = @_;
  my $fsdiff_options = "";
  $fsdiff_options .= " -c sha1" if defined $$radmind_options{'checksum'};
  $fsdiff_options .= " -I" if defined $$radmind_options{'case_insensitive'};
  return $fsdiff_options;
}

sub lapply_args2 {
  my ( $radmind_options ) = @_;
  my $lapply_options = "";
  $lapply_options .= " -F";
  $lapply_options .= " -c sha1" if defined $$radmind_options{'checksum'};
  $lapply_options .= " -I" if defined $$radmind_options{'case_insensitive'};
  $lapply_options .= " -h $$radmind_options{server}" if defined $$radmind_options{'server'};
  $lapply_options .= " -p $$radmind_options{port}" if defined $$radmind_options{'port'};
  $lapply_options .= " -w $$radmind_options{auth_level}" if defined $$radmind_options{'auth_level'};
  $lapply_options .= " -Z $$radmind_options{compression_level}" if defined $$radmind_options{'compression_level'};
  return $lapply_options;
}

sub repo_args2 {
  my ( $radmind_options ) = @_;
  my $repo_options = "";
  $repo_options .= " -h $$radmind_options{server}" if defined $$radmind_options{'server'};
  $repo_options .= " -p $$radmind_options{port}" if defined $$radmind_options{'port'};
  $repo_options .= " -w $$radmind_options{auth_level}" if defined $$radmind_options{'auth_level'};
  $repo_options .= " -Z $$radmind_options{compression_level}" if defined $$radmind_options{'compression_level'};
  return $repo_options;
}

################################################################################
sub usage {
  my $myname = `basename $0`;
  chomp $myname;
  print STDERR << "EOF";
Usage: $myname [-aCfkInNl] [-c checksum_type] [-h server [-p port] [-w auth level]] <transcript or command file> [<transcript or command file>...]

examples:

	$myname some_app.T
	$myname -h radmind.bombschool.edu how_to.T how_not_to.T

-a Use absolute paths instead of relative (relative is default).
   Absolute paths were an afterthought.  Maybe they work, maybe not...
-C Create missing intermediate directories
-f Create all directories before doing anything (use -C to only create missing directories)
-h Specify the radmind server
-I Case insensititive
-k Run ktcheck without asking (use with ARD and Send Unix command).
-l Load balanced. If more than one radmind server is specified in the xhooks config, this option will
    choose the radmind server by doing a modulo on the ip of the computer, so if you have 2 radmind servers
    even IP's will go to the first, odd IP's to the second (even mod 2 is index 0, odd mod 2 is index 1).
-n Don't use checksum.
-N Don't run lapply.
-p Specify the port (this requires -h to also be set)
-w Specify the auth level (this requires -h to also be set)

This script downloads all transcripts or command files specified.  The last transcript has
precedence.  This script will not delete files (all - lines are removed).  It will replace
files replacing any customized files with versions from the server.

If your transcript specifies folders that don't exist, use the -C flag to create
them.

Relative paths are cool.  You can switch your transcripts to use them on the client
(if you use absolute paths) and then you can download overloads to any folder you
want (the cwd).

This script works by creating a custom command file with a negative transcript that ignores
everything except for the transcripts or command files you specify.  When fsdiff runs with
the custom command file it ignores everything but the listed transcipts.  This lets you
download transcripts at will.

(Instructions last updated 2010.09.09)

EOF
    exit 1;
}
