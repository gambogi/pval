use Dancer;
use Pval;

my $app = sub {
    my $env = shift;
    my $request = Dancer::Request->new(env => $env);
    Dancer->dance($request);
};
