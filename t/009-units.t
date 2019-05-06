use v6.c;

use Cairo;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Enums;

use GTK::Adjustment;
use GTK::Application;
use GTK::Box;
use GTK::Label;
use GTK::Notebook;
use GTK::ScrolledWindow;
use GTK::SpinButton;

use Goo::Canvas;
use Goo::Image;
use Goo::Rect;
use Goo::Text;

my (%data, $app, $flower-pattern);

our subset ObjectOrPointer of Mu where * ~~ (
  GTK::Compat::Roles::Object,
  GTK::Roles::Pointers,
  GTK::Roles::Properties
).any;

sub get-data (ObjectOrPointer $i is copy, $k) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GTK::Compat::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k};
}
sub set-data (ObjectOrPointer $i is copy, $k, $v) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GTK::Compat::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k} = $v;
}

sub on_motion_notify ($item, $r) {
  CATCH { default { .message.say } }

  say qq:to/SAY/.chomp;
{ get-data($item, 'id') // '<Unknown>'
} item received 'motion-notify' signal;
SAY

  $r.r = 0;
}

sub setup_canvas ($canvas, $units, $unit_name) {
  my @data = (
    # Pixels
    [ 100, 100, 200,  20,   10, 200, 310,  24, 310, 100,  20,  20 ],
    # Points
    [ 100, 100, 200,  20,   10, 200, 310,  24, 310, 100,  20,  20 ],
    # Inches
    [ 1,     1,   3, 0.5, 0.16,   3,   4, 0.3, 4.2,   1, 0.5, 0.5 ],
    # mm
    [ 30,   30, 100,  10,    5,  80,  60,  10, 135,  30,  10,  10 ]
  );

  my @d = @( @data[$units.Int] );
  my $root = $canvas.get_root_item;
  with Goo::Rect.new( $root, |@d[^4] ) {
    .motion-notify-event.tap(-> *@a { on_motion_notify( $_, @a[*-1] ) });
    set-data($_, 'id', "{ $unit_name }-Rectangle");
  }

  my $t1 = Goo::Text.new(
    $root, "This box is { @d[2] }x{ @d[3] } { $unit_name }",
    @d[0] + @d[2] / 2, @d[1] + @d[3] / 2, -1, GOO_CANVAS_ANCHOR_CENTER
  );
  $t1.font = "Sans { @d[4] }px";

  my $t2 = Goo::Text.new(
    $root, "This font is { @d[7] } { $unit_name } high",
    |@d[5,6], -1, GOO_CANVAS_ANCHOR_CENTER
  );
  $t2.font = "Sans { @d[7] }px";

  my $i = Goo::Image.new( $root, GdkPixbuf, |@d[8,9] );
  $i.pattern = $flower-pattern;
  ($i.width, $i.height) = @d[10,11];
  $i.scale-to-fit = True;
}

my %canvas;
sub create_canvas($unit, $unit_name) {
  CATCH { default { .message.say; $app.exit } }

  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margin = 4;

  my $hbox = GTK::Box.new-hbox(4);
  $vbox.pack_start($hbox);

  %canvas{$unit} = Goo::Canvas.new;
  my $zoom_label = GTK::Label.new('Zoom:');
  $hbox.pack_start($zoom_label);

  my $adj = GTK::Adjustment.new(1, 0.05, 100, 0.05, 0.5, 0.5);
  my $sb  = GTK::SpinButton.new($adj, 0, 2);
  $sb.value-changed.tap({ %canvas{$unit}.scale = $adj.value });
  $sb.set_size_request(50, -1);
  $hbox.pack_start($sb);

  my $sw = GTK::ScrolledWindow.new;
  $sw.halign  = $sw.valign  = GTK_ALIGN_FILL;
  $sw.hexpand = $sw.vexpand = True;
  $vbox.pack_start($sw);

  %canvas{$unit}.set_size_request(600, 450);
  %canvas{$unit}.set_bounds(0, 0, 1000, 1000);
  %canvas{$unit}.units = $unit;
  %canvas{$unit}.anchor = GOO_CANVAS_ANCHOR_CENTER;
  $sw.set_size_request(600, 450);
  setup_canvas(%canvas{$unit}, $unit, $unit_name);
  $sw.add(%canvas{$unit});

  $vbox;
}

sub MAIN {
  $app = GTK::Application.new( title => 'org.genex.goo.scale' );

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.set_default_size(640, 480);

    my $notebook = GTK::Notebook.new;
    $app.window.add($notebook);

    my $flower-file = 'flower.png';
    $flower-file = "t/$flower-file" unless $flower-file.IO.e;
    die 'SORRY! Demo image file does not exist' unless $flower-file.IO.e;

    my $surface = Cairo::Image.open($flower-file);
    my ($fw, $fh) = ($surface.width, $surface.height);
    $flower-pattern = Cairo::Pattern::Surface.create($surface.surface);

    my @labels;
    for (GTK_UNIT_PIXELS, GTK_UNIT_POINTS, GTK_UNIT_INCH, GTK_UNIT_MM) {
      @labels.push: GTK::Label.new(
        my $name = do {
          when GTK_UNIT_PIXELS { 'Pixels'      }
          when GTK_UNIT_POINTS { 'Points'      }
          when GTK_UNIT_INCH   { 'Inches'      }
          when GTK_UNIT_MM     { 'Millimeters' }
        }
      );
      $notebook.append_page( create_canvas($_, $name), @labels[*-1] );
    }

    $app.window.show_all;
  });

  $app.run;
}
