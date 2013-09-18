package Acme::Gwt::Parser::Response::Reader;

use Moo;
use JSON;
use Class::Load 'load_class';
use Acme::Gwt::Parser::Utils qw/java_class_to_perl/;

has 'json_body' => (is => 'ro', required => 1);

has 'objects' => (is => 'rw', default => sub { [] });
has 'max_prior_string_location' => (is => 'rw', default => sub { 0 });
has 'string_table' => (is => 'rw');
has 'data' => (is => 'rw');

sub BUILD {
	my $self = shift;

	my $true_json = __demangle_json_body($self->json_body);
	my $x = decode_json($true_json);
	(undef, undef, my $string_table, my @data) = reverse(@{$x});

	$self->string_table($string_table);
	$self->data(\@data);
}

sub read_int {
	my $self = shift;

	return shift(@{$self->data});
}

sub read_string {
	my ($self, $position) = @_;

	$position ||= $self->read_int();

	if ($position > $self->max_prior_string_location + 1) {
		die "trying to read $position, which is too far ahead; max seen thus far is " . $self->max_prior_string_location . "!";
	}

	if ($position > $self->max_prior_string_location) {
		$self->max_prior_string_location( $self->max_prior_string_location + 1 );
	}

	my $val = $self->string_table->[ $position - 1 ];
	return $val;
}

sub read_object {
	my ($self) = @_;

	my $int = $self->read_int();
	if ($int < 0) {
		return $self->objects->[-1 - $int];
	} elsif ($int > 0) {
		my $java_class = $self->read_string($int);
		$java_class =~ s{/\d+$}{};
		my $perl_class = java_class_to_perl($java_class);
		if ($perl_class) {
			my @objects = @{ $self->objects };
			my $placeholder_position = scalar(@objects);
			push @objects, "PLACEHOLDER of type $java_class";

			load_class($perl_class) or die "Can't load $perl_class\n";
			my $obj = $perl_class->new->gwt_deserialize($self);
			$objects[$placeholder_position] = $obj;
			$self->objects(\@objects);

			return $obj;
		} else {
			die "unknown java class $java_class";
		}
	} else {
		return undef;
	}
}

sub __demangle_json_body {
	my ($faux_json) = @_;

	if ($faux_json =~ /^\[(.+),\[(.+)\],0,7\]$/) {
		my $data = $1; my $string_table = $2;
		$data =~ s/\'/\"/g;
		return "[$data,[$string_table],0,7]";
	} else {
		die "can't demangle";
	}
}

1;