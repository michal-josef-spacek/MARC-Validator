use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::NoWarnings;

BEGIN {

	# Test.
	use_ok('MARC::Validator::Abstract');
}

# Test.
require_ok('MARC::Validator::Abstract');
