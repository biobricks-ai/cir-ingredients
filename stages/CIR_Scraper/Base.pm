package CIR_Scraper::Base;
# ABSTRACT: Base scraper

use Moo;
use WWW::Mechanize;

use feature qw(say signatures postderef);
no warnings qw(experimental::signatures experimental::postderef);

has _mech => ( is => 'ro', default => sub($self) {
	my $mech = WWW::Mechanize->new(
		autocheck => 1,
		agent => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0',
	);
	$mech->add_header( Referer => 'https://www.cir-safety.org/' );

	$mech;
});

1;

1;
