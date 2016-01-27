package Achievements;
use Mojo::Base 'Mojolicious';

sub startup {
  my $c = shift;

  my $r = $c->routes;

  $r->get('/' => sub { 
    my $c = shift; 
    $c->render(text => 'Hello Achievements');
  });
}

1;
