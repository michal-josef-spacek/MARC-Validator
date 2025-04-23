package MARC::Validator::Plugin::Field008;

use base qw(MARC::Validator::Abstract);
use strict;
use warnings;

use English;
use Error::Pure::Utils qw(err_msg_hr);
use MARC::Leader;
use MARC::Field008;

our $VERSION = 0.01;

sub name {
	my $self = shift;

	return 'field_008';
}

sub process {
	my ($self, $marc_record) = @_;

	my $leader_string = $marc_record->leader;
	my $leader = MARC::Leader->new(
		'verbose' => $self->{'verbose'},
	)->parse($leader_string);

	my $cnb = $marc_record->field('015')->subfield('a');

	my $field_008_string = $marc_record->field('008')->as_string;
	my $field_008 = eval {
		MARC::Field008->new(
			'leader' => $leader,
			'verbose' => $self->{'verbose'},
		)->parse($field_008_string);
	};
	if ($EVAL_ERROR) {
		my $err = $EVAL_ERROR;
		chomp $err;
		my $err_msg_hr = err_msg_hr();
		$self->{'struct'}->{'field_008'}->{'not_valid'}->{$cnb} = {
			'error' => $err,
			'params' => $err_msg_hr,
		};
	}

	# XXX Check
	if ($field_008->type_of_date ne 's' && $field_008->date1 eq $field_008->date2) {
		$self->{'struct'}->{'field_008'}->{'not_valid'}->{$cnb} = {
			'error' => 'Field 008 date 1 is same as date 2',
		};
	}

	return;
}

sub _init {
	my $self = shift;

	$self->{'struct'}->{'module_name'} = __PACKAGE__;
	$self->{'struct'}->{'module_version'} = $VERSION;

	$self->{'struct'}->{'field_008'}->{'not_valid'} = {};

	return;
}

1;

__END__
