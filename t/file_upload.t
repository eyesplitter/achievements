use 5.12.0;
use Test::More;
use Mojo::Asset::File;
use Mojo::Upload;
use Achievements::Tools::Image qw(upload);


my $header = Mojo::Headers->new;
my $file = Mojo::Asset::File->new;
my $upload = Mojo::Upload->new;
my $file_large = Mojo::Asset::File->new;
$file_large->add_chunk('1' x 21 x 1024 x 1024);

like upload(), qr/^Upload fail/, 'empty params';

$upload->filename('mysuperpic.png')->headers($header->content_type('image/png'))->asset($file->add_chunk('foo'));
my $path = upload($upload);
like upload($upload), qr/[a-zA-Z0-9]{32}\.png$/, 'file valid';
is -e "public$path", 1, 'file created';

$upload->filename('');
like upload($upload), qr/^Upload fail/, 'file name error';

$upload->filename('mysuperpic2.png')->headers($header->content_type('text/plain'));
like upload($upload), qr/^Upload fail/, 'file type error';

$upload->headers($header->content_type('image/png'))->asset($file_large);
like upload($upload), qr/^Upload fail/, 'file size error';

unlink "public$path";

done_testing();
