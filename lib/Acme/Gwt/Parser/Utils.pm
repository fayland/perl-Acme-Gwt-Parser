package Acme::Gwt::Parser::Utils;

use base 'Exporter';
use vars qw/@EXPORT_OK %class_maps/;
@EXPORT_OK = qw/java_class_to_perl/;

%class_maps = (
    "java.lang.String"      => "Acme::Gwt::Parser::Deserializer::String",
    "java.util.ArrayList"   => "Acme::Gwt::Parser::Deserializer::Array",
);

sub java_class_to_perl {
    my ($java_class) = @_;

    return $class_maps{$java_class};
}

1;