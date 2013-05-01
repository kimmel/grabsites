#!/usr/bin/env perl

# Copyright (c) 2013 Kirk Kimmel. All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the 3-clause BSD license. See LICENSE.txt.
#
# The newest version of this file can be found at:
#   https://github.com/kimmel/grabsites

use v5.10;
use warnings;
use autodie qw( :all );
use utf8::all;

my $runtime = time;

open my $input, '<', 'site_list';
my @lines = <$input>;
close $input;

my %seen = ();
my @sources = grep { !$seen{$_}++ } @lines;

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

__END__

#-----------------------------------------------------------------------------

=pod

=encoding utf8

=head1 NAME

C<grabsites.pl> - Download a list of sites with wget & warc support

head1 USAGE

grabsites.pl <item>

=head1 HOMEPAGE

https://github.com/kimmel/grabsites

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013 < Kirk Kimmel >. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the 3-clause BSD license. The full text of this license can be found online at
< http://opensource.org/licenses/BSD-3-Clause >

=cut
