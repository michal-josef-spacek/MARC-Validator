package MARC::Validator::Const;

use strict;
use utf8;
use warnings;

use Readonly;

Readonly::Hash our %FIELD_504 => (
	'cze' => qr{[rR]ejstřík},
);

our $VERSION = 0.12;

1;

__END__
