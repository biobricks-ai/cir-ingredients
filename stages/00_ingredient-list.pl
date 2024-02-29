#!/usr/bin/env perl
# PODNAME: 00_ingredient-list.pl
# ABSTRACT: Fetch ingredient list

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

use CIR_Scraper::IngredientList;
use Text::CSV_XS qw(csv);
use Hash::Fold qw(flatten);
use Path::Tiny 0.125;
use List::UtilsBy qw( uniq_by );

sub main {
	my $ingredients = CIR_Scraper::IngredientList->new->fetch;
	my @flattened = map { flatten($_) }
		#uniq_by { $_->{'cir_ingredient'}{id} }
		$ingredients->@*;
	my $csv_file = path('work/out.csv');
	$csv_file->parent->mkdir;
	csv(
		in => \@flattened, out => "$csv_file",
		headers => [ qw(
			cir_ingredient.name
			cir_ingredient.id
			us_inci.name
		) ],
	);

	local $ENV{IPC_R_INPUT_CSV}          = "$csv_file";
	system(
		qw(R -e), <<~'R'
		  library(arrow)

		  input_data_file     <- Sys.getenv('IPC_R_INPUT_CSV')

		  print(paste('Reading from file', input_data_file))
		  read.csv(input_data_file,  stringsAsFactors = FALSE) |>
		    arrow::write_parquet("brick/ingredient_list.parquet")
		R
	);

	$csv_file->remove;
}

main unless caller;
