use Mojo::Base -strict;
use Test::More;

use Mojo::Server;
use Mojo::Pg;

my $server = Mojo::Server->new;
my $app = $server->load_app('./script/achievements');

my $pg = Mojo::Pg->new($app->config->{db});
ok $pg->db->ping, 'connected';
my $options = {AutoCommit => 1, AutoInactiveDestroy => 1, PrintError => 0, RaiseError => 1};
is_deeply $pg->options, $options, 'right options';
is_deeply $pg->db->query('select 1 as one, 2 as two, 3 as three')->hash,
  {one => 1, two => 2, three => 3}, 'right structure';

done_testing();
