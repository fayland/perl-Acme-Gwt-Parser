#!/usr/bin/perl

use strict;
use warnings;
use Acme::Gwt::Parser::Response;
use Test::More;
use Data::Dumper;

my $resp = '//OK[4,2,3,2,2,1,["java.util.ArrayList/3821976829","java.lang.String/2004016611","Hello","World"],0,7]';

my $objects = Acme::Gwt::Parser::Response->new(raw_response => $resp)->content;
diag(Dumper(\$objects));

ok(1);
done_testing();

1;