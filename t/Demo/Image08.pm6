use v6.c;

use Goo::Raw::Types;

use GDK::Pixbuf;
use GTK::Application;
use GTK::Box;
use GTK::ScrolledWindow;

use Goo::Canvas;

use Goo::Model::Group;

constant N_COLS  = 5;
constant N_ROWS  = 20;
constant PADDING = 10;

my %globals;

sub create_canvas_scalability {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  my $demo_img = 'toroid.png';
  $demo_img = "t/{$demo_img}" unless $demo_img.IO.e;
  die 'SORRY! The demo image file cannot be found!'
    unless $demo_img.IO.e;

  my $pixbuf  = GDK::Pixbuf.new_from_file($demo_img);
  my ($width, $height) = ($pixbuf.width + 3, $pixbuf.height + 1);

  my $canvas = Goo::Canvas.new;
  my $root = %globals<model-mode> ??
    Goo::Model::Group.new !! $canvas.get_root_item;
  $canvas.root-item-model = $root if %globals<model-mode>;
  $canvas.set_size_request(600, 450);

  my $sw = GTK::ScrolledWindow.new;
  $sw.shadow_type = GTK_SHADOW_IN;
  $sw.valign  = $sw.halign  = GTK_ALIGN_FILL;
  $sw.hexpand = $sw.vexpand = True;
  $sw.set_size_request(700, 450);
  $sw.add($canvas);
  $vbox.pack_start($sw);

  for ^N_COLS X ^N_ROWS -> ($c, $r) {
    my ($x, $y) = ( $c * ($width + PADDING), $r * ($height + PADDING) );
    # Original used fill-color on the Goo::Image, which does nothing.
    # A little creative interpretation adds a nice pop! :)
    my $rect = %globals<rect-obj>.new($root, $x, $y, $width, $height);
    $rect.fill-color = $r % 2 ?? 'mediumseagreen' !! 'steelblue';

    %globals<image-obj>.new($root, $pixbuf, $x, $y);
  }

  $vbox;
}

sub setupObjects ($image-obj, $rect-obj) is export {
  %globals<image-obj rect-obj> = ($image-obj, $rect-obj);
  %globals<model-mode>         = $image-obj.^name.contains('::Model');
}

sub Image_08_MAIN ($image-obj, $rect-obj) is export {
  my $app = GTK::Application.new( title => 'org.genex.goo.pixmap' );

  setupObjects($image-obj, $rect-obj);

  $app.activate.tap( -> *@a {
    $app.window.add(create_canvas_scalability);
    $app.window.show_all;
  });

  $app;
}
