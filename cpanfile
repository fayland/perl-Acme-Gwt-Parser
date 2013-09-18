requires 'perl', '5.008005';

requires 'Moo';
requires 'JSON';

on test => sub {
    requires 'Test::More', '0.88';
};
