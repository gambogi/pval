use Dancer;
use Dancer::Config;
use Pval;

my $app = sub {
    my $env = shift;
	set environment => 'production';
	Dancer::Config::load;
    my $request = Dancer::Request->new(env => $env);
    Dancer->dance($request);
};
