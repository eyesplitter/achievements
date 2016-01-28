package Achievements::Tools::Image;
use 5.12.0;
use File::Path qw(make_path remove_tree);
use Digest::MD5 qw(md5_hex);

use base 'Exporter';
our @EXPORT_OK = qw(upload);

sub upload {
  my ($upload) = @_;
  return "Upload fail. Calling without parameters" unless $upload;
  my $error;
  
  my $path = '/pics/';
  make_path "public$path" unless (-d "public$path");
  my $upload_max_size = 20 * 1024 * 1024;
  my $img_type = $upload->headers->content_type;
  my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);

  $error = 'Upload fail. File is not specified.' unless ($upload->filename); 
  $error = 'Upload fail. Image size is too large.' if ($upload->size > $upload_max_size); 
  $error = 'Upload fail. Wrong file type.' unless ($valid_types{$img_type}); 
  return $error if ($error);

  my $exts = {'image/gif' => 'gif', 'image/jpeg' => 'jpg', 'image/png' => 'png'};
  my $ext = $exts->{$img_type};

  my $filename = md5_hex($upload->filename.time());
  $upload->move_to(sprintf("public%s%s.%s",$path,$filename,$ext));
  return $path.$filename.'.'.$ext;
}

1;
