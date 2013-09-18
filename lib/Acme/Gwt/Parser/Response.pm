package Acme::Gwt::Parser::Response;

use Moo;
use Acme::Gwt::Parser::Response::Reader;

has 'raw_response' => (is => 'ro', required => 1);

sub content {
	my ($self) = @_;

	my $raw_response = $self->raw_response;
	$raw_response =~ s{^//OK}{};

	return Acme::Gwt::Parser::Response::Reader->new(json_body => $raw_response)->read_object();
}

1;