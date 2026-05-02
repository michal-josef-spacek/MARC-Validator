use strict;
use warnings;

use File::Object;
use MARC::File::XML (BinaryEncoding => 'utf8', RecordFormat => 'MARC21');
use MARC::Validator::Plugin::Field080;
use Test::More 'tests' => 12;
use Test::NoWarnings;

# Data dir.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = MARC::Validator::Plugin::Field080->new;
my $ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
is(scalar @{$ret->plugin_errors}, 0, 'No errors without init.');

# Test.
$obj = MARC::Validator::Plugin::Field080->new;
$obj->init;
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
is(scalar @{$ret->plugin_errors}, 0, 'No errors with init, without process.');

# Test.
$obj = MARC::Validator::Plugin::Field080->new(
	'record_id_def' => '015a',
);
$obj->init;
my $marc_record = MARC::File::XML->in($data_dir->file('cnb000396346-trailing_space_in_080a.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'field_080', 'Get name (field_080).');
my $errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb000396346', 'Get record id (cnb000396346).');
is($errors->[0]->errors->[0]->error, "Field 080a has trailing space.",
	"Get error (Field 080a has trailing space.).");
is($errors->[0]->errors->[0]->params->{'field_080_a'}, "677.062 +65.01] :687.1(082)",
	'Get error parameter (field_080_a => 677.062 +65.01] :687.1(082)).');
