#!/usr/bin/perl
# md-to-steam.pl (c) spycrab0, 2017
# A script for converting GitHub Markdown to the format used by the Steam Workshop
# Licensed under a MIT License. See LICENSE

# TODO:
# Add link support
# Add image support
# Add file option
# Add quiet option
# Add nested list (indented list) support

use strict;
use warnings;
use v5.10;

my $list = 0;

while (<>)
{
    # Check whether were in a list or not and write the list begin and end tags
    if ($list = m/^( )*\*/)
    {
        say "[list]" if (not $list);
    }
    else
    {
        say "[/list]" if ($list);
    }

    s/^ *\*/[\*]/; # List items
    s/^#+ (.*)/\[h1\]$1\[\/h1\]/; # Headings
    s/(?!\[)\*(.*?)\*/\[b\]$1\[\/b\]/; # Bold text
    s/(?!\[)\/(.*?)\//\[i\]$1\[\/i\]/; # Italic text

    print;
}

say "[/list]" if ($list); # End the list, if open

# Print acknowledgement (remove this if you want to, I don't care)
print "\n[i]Generated by md_to_steam.pl from Github Markdown[/i]\n"; 
