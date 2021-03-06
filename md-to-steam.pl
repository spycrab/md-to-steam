#!/usr/bin/perl
# md-to-steam.pl (c) spycrab0, 2017
# A script for converting GitHub Markdown to the format used by the Steam Workshop
# Licensed under a MIT License. See LICENSE

# TODO:
# Add file input option
# Add quiet option

use strict;
use warnings;
use v5.10;

my ($ulist,$olist,$quote,$code) = (0,0,0,0);

while (<>)
{
    # both
    if (m/```.*?/)
    {
        if (not $code) { say '[code]'; }
        else           { say '[/code]'; }
        $code = !$code;
        next;
    }

    # end tags
    unless (m/^> /) { say '[/quote]' if ($quote); $quote = 0; }
    unless (m/^ *\* /)  { say '[/list]' if ($ulist);  $ulist = 0; }
    unless (m/^ *[0-9]+\. /) { say '[/olist]' if ($olist); $olist = 0; }

    # begin tags
    if (m/^ *\* /)
    {
        my $tab_len = length((split('\* ', $_))[0])/2+1;
        while ($ulist > $tab_len) { say '[/list]'; $ulist--; }
        while ($ulist < $tab_len) { say '[list]'; $ulist++; }
    }

    if (m/^ *[0-9]+\. /)
    {
        my $tab_len = length((split('[0-9]+\.', $_))[0])/2+1;
        while ($olist > $tab_len) { say '[/olist]'; $olist--; }
        while ($olist < $tab_len) { say '[olist]'; $olist++; }
    }

    if (m/^> /)
    {
        say '[quote]' if (not $quote);
        $quote = 1;
    }

    s/^ *\*/[\*]/; # List items
    s/^ *[0-9]+\. (.*)/[\*] $1/; # Ordered list items
    s/^> //; # Quote markers
    s/^#+ (.*)/\[h1\]$1\[\/h1\]/; # Headings
    s/(?!\[)[\*_][\*_](.*?)[\*_][\*_]/\[b\]$1\[\/b\]/; # Bold text
    s/(?!\[)[\*_](.*?)[\*_]/\[i\]$1\[\/i\]/; # Italic text
    s/(?!``)`(.*?)`/\[i\]$1\[\/i\]/; # There are no inline codetags in steam's markup so I use italic instead
    s/~~(.*?)~~/\[strike\]$1\[\/strike\]/; # Strike out
    s/\!\[(.*?)\]\((.*?)\)/\[img]$2\[\/img\]/; # Image
    s/(?!\!)\[(.*?)\]\((.*?)\)/\[url=$2\]$1\[\/url\]/; # Links
    
    print;
}

# Close open tags
say '[/list]' if ($ulist);
say '[/olist]' if ($olist);
say '[/quote]' if ($quote);

# Print acknowledgement (remove this if you want to, I don't care)
print "\n[i]Generated by md_to_steam.pl from Github Markdown[/i]\n"; 
