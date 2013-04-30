#!/usr/bin/env perl

use v5.10;
use warnings;
use autodie qw( :all );
use utf8::all;

my $runtime = time;

open my $input, '<', 'site_list';
my @sources = <$input>;
close $input;

my $user_agent = 'Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)';

foreach my $site (@sources) {
    chomp $site;
    my $warc_name = $site;
    $warc_name =~ s/^http:\/\///xms;
    $warc_name =~ s/^https:\/\///xms;
    $warc_name =~ s/\/$//xms;
    $warc_name =~ s/\//_/gxms;

    my $result
        = qx{wget -e robots=off --mirror --page-requisites --waitretry 5 --timeout 60 --tries 5 --wait 1 --warc-header "operator: Archive Team" --warc-cdx --warc-file="$warc_name" -U "$user_agent" "$site"};
}

$runtime = time - $runtime;
say "\n\nTime elapsed: $runtime seconds";
