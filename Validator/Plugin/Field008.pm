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

	my $struct_hr = $self->{'struct'}->{'checks'};

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
		$struct_hr->{'not_valid'}->{$cnb} = {
			'error' => $err,
			'params' => $err_msg_hr,
		};

	# Parsing of field 008 is valid, other checks.
	} else {
		# XXX Check
		if ($field_008->type_of_date eq 's' && $field_008->date1 eq $field_008->date2) {
			$struct_hr->{'not_valid'}->{$cnb} = {
				'error' => 'Field 008 date 1 is same as date 2',
			};
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
