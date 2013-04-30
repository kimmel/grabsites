grab-sites
==========

Grab multiple websites with wget for archiving.

First install the dependencies from CPAN.

  cpan autodie utf8::all

Next create a file named 'site_list' and add urls one per line to fetch.

Now set the file permissions and run.

  chmod +x get.pl
  ./get.pl

