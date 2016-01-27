package Achievements;
use Mojo::Base 'Mojolicious';
use Cwd;
use Mojo::Pg;

has pg => sub {
  my $c = shift;
  state $pg = Mojo::Pg->new($c->config->{'db'});
  return $pg;
};

has home => sub {
    my $path = getcwd;
    return Mojo::Home->new(File::Spec->rel2abs($path));
};

has config_file => sub {
  my $self = shift;
  return $self->home->rel_file('api.conf');
};

sub load_config {
  my $app = shift;

  $app->plugin( JSONConfig => {
    file => $app->config_file
  });

  my $secrets = $app->config->{secrets}; 
  $app->secrets($secrets); 
}

sub startup {
  my $c = shift;

  $c->load_config;

  my $r = $c->routes;

  $r->get('/' => sub { 
    my $c = shift; 
    $c->render(text => 'Hello Achievements');
  });
}

1;
