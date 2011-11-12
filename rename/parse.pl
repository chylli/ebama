#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use LWP::Simple;
use HTML::TreeBuilder;
use Data::Dumper;
$| = 1;


my $baseUrl = "http://teacherexpress.scholastic.com/grade/";

my $baseContent = get($baseUrl);
my $baseTree = HTML::TreeBuilder->new_from_content($baseContent);

#look for grade part
my @lookGrade = $baseTree->find("dt");
my $grade;
for my $t (@lookGrade) {
    my @t2 = $t->content_list();
    if (grep(/Grade/,@t2)){
        $grade = $t;
    }
}
die "no grade part" unless $grade;

my $gradeTop = $grade->right;
my @gradeLinks = $gradeTop->find('a');
my @grades;

for my $gradeLink (@gradeLinks) {
    my $gradeName = ($gradeLink->content_list)[0];
    my $gradeHref = $gradeLink->attr('href');
    push @grades, [$gradeName,$gradeHref];
}    
    
$baseTree->delete;    
    
map {processGrade(@{$_})} @grades;
#processGrade($grades[0]);
#processGrade("abc","http://teacherexpress.scholastic.com/grade?cat=75&p=88");


#processGrade($gradeName,$gradeHref);
sub processGrade{
    my ($gradeName,$link) = @_;
    #mkdir $grade;

    my $gradePage = get($link);
    my $gradeTree = HTML::TreeBuilder->new_from_content($gradePage);
    my $next = $gradeTree->look_down("_tag","a","class","next");
    my $nextHref;
    
    if ($next) {
        $nextHref = $next->attr("href");
    }
    parsePage($gradeName,$gradeTree);
    $gradeTree->delete;
    processGrade($gradeName,$nextHref) if $nextHref;

}

sub parsePage{
    my ($gradeName,$pageTree) = @_;
    my @items = $pageTree->look_down("class","product-image");
    my @links ;
    
    for (@items) {
       parseItem($gradeName,$_->attr('href'));
    }
}

sub parseItem{
    my ($gradeName,$link) = @_;
    my $itemPage = get($link);
    $itemPage =~ /(Item .*)$/m;
    my $itemInfo = $1;
    #my $grade = $2;
    $link =~ /([^\/]*)$/;
    my $name = $1;
    
    unless ($itemInfo) {
        warn "no item info : for $name\n";
        return;
    }
    
    say "name: $name | gradeName: $gradeName | $itemInfo";
    
    
    #$itemTree->dump();
    

}





