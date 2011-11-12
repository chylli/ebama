#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use feature 'say';

use Encode qw(encode decode);

use LWP::Simple;
use HTML::LinkExtor;
use Data::Dumper;
use HTML::TreeBuilder;
use URI::Escape;

my $file = shift || die "need a html file to get 115 links\n";



my @urls ;
my $download = 1;

sub cb {
    my ($tag, %attr) = @_;
    if ($tag eq 'a' && $attr{href} && $attr{href} =~ /115.com/) {
        push @urls, $attr{href};
    }
}


my $p = HTML::LinkExtor->new(\&cb);
$p->parse_file($file);


for my $u (@urls) {
    say "processing $u";
    

    if ($download == 0) {
        if ($u =~ 'e6a7to82#') {
            $download = 1;
        }
        say "dont download $u";
        
        next;
    }
    #print "\n\ndoing $u...\n";
    
    my $content = get $u;#decode('UTF-8', get $u);
    #say "utf8 : " . utf8::is_utf8($content);
    
    unless (defined($content)) {
        warn "cannot get $u\n";
        next;
    }
    my $itemTree = HTML::TreeBuilder->new_from_content($content);

#    $itemTree->dump;

    my @urlInfos = $itemTree->look_down(
        "_tag" => "a",
        "class" => "btn",
        "href" => qr/down_group/,
                                 );
    foreach (@urlInfos) {
        my ($a) = $_->content_list;
        #say Dumper($a);
        
        #say encode("utf-8",$a);
        

        
        
        #print Dumper($_->attr("_content"));
        
    }
    my ($unicomurl) = grep {my ($a) = $_->content_list; $a =~ /联通/} @urlInfos;
    unless ($unicomurl) {
        $unicomurl = $urlInfos[0];
    }
    #$unicomurl->dump;
    say encode("utf-8",($unicomurl->content_list)[0]);
    my $urlstring = $unicomurl->attr("href");
    $urlstring =~ /file=(.*)$/;
    my $outfile = $1;
    $outfile = uri_unescape($outfile);
    
    `wget -c -O $outfile "$urlstring"`;
    $itemTree->destroy;
    
}


