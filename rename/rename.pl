#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use File::Copy;
use PDF::API2;

my $basedir = "pdf";
my %processed;

mkdir $basedir;


open my $fh, "<name.txt";

while (my $rec = <$fh>) {
    $rec =~ /name: (\S+) \| gradeName: (\S+) \| Item # (\S+)/;
    my %info;
    
    @info{qw(name gradeName number)} = ($1,$2,$3);
    $info{name} =~ s/-/ /g;

    my $baseNumber;
    $info{number} =~ /(.*)_e/;
    $baseNumber = $1;
    $info{baseNumber} = $baseNumber;

    if (exists $processed{$baseNumber}) {
        copyBook(\%info);
    }
    else {
        processBook(\%info);
    }
    


    
}

sub copyBook{
    say "copying";

}

sub processBook{
    my $info = shift;
    
    say "processing $info->{baseNumber}";
    

    my $newName = newName($info);
    my $namepattern = "$info->{baseNumber}_e*.pdf";
    
    my @pdffiles = glob($namepattern);
    @pdffiles = sort {$a cmp $b} @pdffiles;

    return unless @pdffiles;
    

    my $newpdf = PDF::API2->new();
    foreach my $pdf (@pdffiles) {
        say "merging $pdf";
        
        my $oldpdf = PDF::API2->open($pdf);
        for my $pnumber (1 .. $oldpdf->pages()) {
            $newpdf->importpage($oldpdf,$pnumber,0);
        }
    }
    $newpdf->saveas($newName);
    $processed{$info->{baseNumber}} = $newName;
    say "$info->{baseNumber}: $newName processed" ;
    
}

sub newName {
    my $info = shift;
    my $newdir = "$basedir/$info->{gradeName}";

    unless (-e $newdir) {
        mkdir $newdir;
    }
    my $name = $info->{name};
    my $newName = "$newdir/$name.pdf";
    $info->{newName} = $newName;
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
