#!/usr/bin/perl

use CGI;
use CGI::Carp qw ( fatalsToBrowser );

my $query = new CGI;
my $disk = $query->param("disk");
$disk =~ s/^\s+|\s+$//g;
my $perf = $query->param("perf");
my $days = $query->param("days");

system ("/var/www/html/svcmon/find_target $perf$disk.gif $days");

print "Location: http://192.168.1.1/svcmon/result.html\n\n";
