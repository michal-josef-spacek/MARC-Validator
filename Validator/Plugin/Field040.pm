package MARC::Validator::Plugin::Field040;

use base qw(MARC::Validator::Abstract);
use strict;
use warnings;

use MARC::Leader;
use MARC::Validator::Utils qw(add_error);

our $VERSION = 0.06;

sub name {
	my $self = shift;

	return 'field_040';
}

sub process {
	my ($self, $marc_record) = @_;

	my $struct_hr = $self->{'struct'}->{'checks'};

	my $error_id = $self->{'cb_error_id'}->($marc_record);

	my $leader_string = $marc_record->leader;
	my $leader = MARC::Leader->new(
		'verbose' => $self->{'verbose'},
	)->parse($leader_string);

	my $field_040 = $marc_record->field('040');
	if (! defined $field_040) {
		add_error($error_id, $struct_hr, {
			'error' => "Field 040 isn't present.",
		});
		return;
	}
	my $desc_conventions = $field_040->subfield('e');

	if ($leader->descriptive_cataloging_form eq 'a'
		&& defined $desc_conventions
		&& $desc_conventions eq 'rda') {

		add_error($error_id, $struct_hr, {
			'error' => 'Leader descriptive cataloging form (a) is inconsistent with field 040e description conventions (rda).',
		});
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
