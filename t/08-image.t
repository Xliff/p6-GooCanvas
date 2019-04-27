use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;

use GTK::Compat::Pixbuf;

use GTK::Application;
use GTK::Box;
use GTK::ScrolledWindow;

use Goo::Canvas;
use Goo::Image;
use Goo::Rect;

constant N_COLS  = 5;
constant N_ROWS  = 20;
constant PADDING = 10;

sub create_canvas_scalability {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  my $demo_img = 'toroid.png';
  $demo_img = "t/{$demo_img}" unless $demo_img.IO.e;
  die 'SORRY! The demo image file cannot be found!'
    unless $demo_img.IO.e;

  my $pixbuf  = GTK::Compat::Pixbuf.new_from_file($demo_img);
  my ($width, $height) = ($pixbuf.width + 3, $pixbuf.height + 1);

  my $canvas = Goo::Canvas.new;
  my $root = $canvas.get_root_item;
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
    .fill-color = $r % 2 ?? 'mediumseagreen' !! 'steelblue' with
      Goo::Rect.new($root, $x, $y, $width, $height);
    Goo::Image.new($root, $pixbuf, $x, $y);
  }

  $vbox;
}

sub MAIN {
  my $app = GTK::Application.new( title => 'org.genex.goo.pixmap' );

  $app.activate.tap({
    $app.window.add(create_canvas_scalability);
    $app.window.show_all;
  });

  $app.run;
}
