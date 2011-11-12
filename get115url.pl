#!/usr/bin/perl -w
use strict;
use warnings;

use LWP::Simple;
use HTML::LinkExtor;
$| = 1;

my @urls ;
my @urls2;
my $download = 1;

sub cb {
    my ($tag, %attr) = @_;
    if ($tag eq 'a' && $attr{href} && $attr{href} =~ /115.com/) {
        push @urls, $attr{href};
    }
}

sub cb2 {
    my ($tag, %attr) = @_;
    if ($tag eq 'a' && $attr{href} && $attr{href} =~ /down_group/ ) {
        push @urls2, $attr{href};
    }

}

my $p = HTML::LinkExtor->new(\&cb);
$p->parse_file("a.html");


for my $u (@urls) {
    print "processing $u\n";
    

    if ($download == 0) {
        if ($u =~ 'e6a7to82#') {
            $download = 1;
        }
        print "dont download $u\n";
        
        next;
    }
    #print "\n\ndoing $u...\n";
    
    my $content = get ($u);

    unless (defined($content)) {
        warn "cannot get $u\n";
        next;
    }
    my $p2 = HTML::LinkExtor->new(\&cb2);
    $p2->parse($content);
    #print $urls2[0],"\n";
    $urls2[0] =~ /file=(.*)$/;
    my $file = $1;

    print "downloading $file\n";
#    sleep 35;
    `wget -c -O $file "$urls2[0]"`;

    @urls2 = ();
    
}


