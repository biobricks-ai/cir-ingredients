package CIR_Scraper::IngredientList;
# ABSTRACT: Ingredient list scraper

use Moo;
use WWW::Mechanize;
use Web::Scraper;

use feature qw(say signatures postderef);
no warnings qw(experimental::signatures experimental::postderef);

extends 'CIR_Scraper::Base';

has 'letter_uris' => ( is => 'ro', default => sub($self) {
	my @uris = map {
		my $letter = $_;
		my $uri = "https://online.personalcarecouncil.org/jsp/IngredInfoSearchResultPage.jsp?searchLetter=${letter}&CIRR=WO98JR3";
	} 'A'..'Z';
	\@uris;
});

has _scraper => ( is => 'ro', default => sub($self) {
	my $strip =  sub {
		s/\x{A0}/ /g; # &nbsp;
		s/^\s*|\s*$//g;
	};
	my $ingredients = scraper {
		process '//table[@width="500"]//tr[position()>1]', 'ingredients[]' => scraper {
			process_first '//td[@class =~ /ResultTable.*Row/]',
				'cir_ingredient', scraper {
				process_first '.', 'name' => [ 'TEXT', $strip ];
				process_first '//a', id => [
					'@href',
					sub { ( m/ \QCIRList.jsp?id=\E (?<id>\d+)/x )[0] } ];
			};
			process_first '//td[position()=2 and @class =~ /ResultTable.*Row/]',
				'us_inci', scraper {
				process_first '.', 'name' => [ 'TEXT', $strip, ];
			};
		};
	};
});

sub fetch($self) {
	my @ingredients;
	for my $uri ($self->letter_uris->@*) {
		say STDERR "Processing $uri";
		my $response = $self->_mech->get($uri);
		my $data = $self->_scraper->scrape($response);
		push @ingredients, $data->{ingredients}->@*;
	}
	\@ingredients;
}

1;
