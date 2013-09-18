package Acme::Gwt::Parser::Deserializer::String;

use Moo;

sub gwt_deserialize {
	my ($self, $reader) = @_;

	return $reader->read_string();
}

1;