#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use File::Copy;
#use PDF::API2;

my $basedir = "pdf";
my %processed;

open(my $log,">renamemap.txt");

mkdir $basedir;


open my $fh, "<name.txt";

while (my $rec = <$fh>) {
    $rec =~ /name: (\S+) \| gradeName: (\S+) \| Item # (\S+)/;
    my %info;
    
    @info{qw(name gradeName number)} = ($1,$2,$3);
    $info{name} =~ s/-/ /g;

    copyBook(\%info);
    
}

sub copyBook{
    my $info = shift;
    
    my $oldname = "$info->{number}.pdf";
    my $newname = newName($info);
    



    if (-e $oldname) {
        say $log "$info->{number} -> $info->{name}";
        copy($oldname, $newname);
    }


}


sub newName {
    my $info = shift;
    my $newdir = "$basedir/$info->{gradeName}";

    unless (-e $newdir) {
        mkdir $newdir;
    }
    my $name = $info->{name};
    my $newName = $info->{number};

    #say "name: $name; Number: $info->{number}";
    

    $newName  =~ s/(.*)_e/$info->{name}_e/g;

    $newName = "$newdir/$newName.pdf";
    #say "newname: $newName";
    
    return $newName;
}

#    $name =~ s/-/ /g;
#    my $oldName = "$number.pdf";
#    my $newdir = "$basedir/$gradeName";
#    my $newname = "$newdir/$name.pdf";
#    unless (-e $gradeName) {
#        mkdir($newdir);
#    }
#
#    if (-e "$number.pdf") {
#        copy($oldname,$newname);
#        
#    }
#    #say "name: ($name), gradeName: ($gradeName), No: ($number)";
