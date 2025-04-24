package MARC::Validator::Plugin::Field260;

use base qw(MARC::Validator::Abstract);
use strict;
use warnings;

our $VERSION = 0.01;

sub name {
	my $self = shift;

	return 'field_260';
}

sub process {
	my ($self, $marc_record) = @_;

	my $struct_hr = $self->{'struct'}->{'checks'};

	my $cnb = $marc_record->field('015')->subfield('a');

	my @field_260 = $marc_record->field('260');
	foreach my $field_260 (@field_260) {
		my @field_260_c = $field_260->subfield('c');
		foreach my $field_260_c (@field_260_c) {
			if ($field_260_c =~ m/^\(\d+\)$/ms) {
				$struct_hr->{'not_valid'}->{$cnb} = {
					'error' => 'Bad year in parenthesis in MARC field 260 $c.',
					'params' => {
						'Value' => $field_260_c,
					},
				};
			}
		}
	}

	return;
}

sub _init {
	my $self = shift;

	$self->{'struct'}->{'module_name'} = __PACKAGE__;
	$self->{'struct'}->{'module_version'} = $VERSION;

	$self->{'struct'}->{'checks'}->{'not_valid'} = {};

	return;
}

1;

__END__
