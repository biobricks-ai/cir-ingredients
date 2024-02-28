package CIR_Scraper::Report;
# ABSTRACT: Fetch individual ingredient reports

use Moo;
use WWW::Mechanize;
use Web::Scraper;

use feature qw(say signatures postderef);
no warnings qw(experimental::signatures experimental::postderef);

sub _ingredient_id_to_report_uri($self, $id) {
	return "https://online.personalcarecouncil.org/jsp/CIRList.jsp?id=${id}"
}

1;
