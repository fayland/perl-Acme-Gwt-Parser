package Acme::Gwt::Parser::Deserializer::Array;

use Moo;

sub gwt_deserialize {
	my ($self, $reader) = @_;

	my @obj;
	my $size = $reader->read_int();
	foreach (1 .. $size) {
		push @obj, $reader->read_object();
	}

	return \@obj;
}

1;