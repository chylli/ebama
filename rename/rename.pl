#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use File::Copy;

my $basedir = "test";

open my $fh, "<name.txt";
while (my $rec = <$fh>) {
    $rec =~ /name: (\S+) \| gradeName: (\S+) \| Item # (\S+)/;
    my ($name, $gradeName, $number) = ($1,$2,$3);
    $name =~ s/-/ /g;

    my $oldname = "$number.pdf";
    my $newdir = "$basedir/$gradeName";
    my $newname = "$newdir/$name.pdf";
    unless (-e $gradeName) {
        mkdir($newdir);
        
    }

    if (-e "$number.pdf") {
        copy($oldname,$newname);
        
    }
    #say "name: ($name), gradeName: ($gradeName), No: ($number)";
    
}
