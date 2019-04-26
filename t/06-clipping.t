use v6.c;

use Cairo;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use GTK::Application;
use GTK::Box;
use GTK::ScrolledWindow;

use Goo::Canvas;
use Goo::Ellipse;
use Goo::Rect;
use Goo::Table;
use Goo::Text;

sub on-button-press ($event, $id, $r) {
  my $be = cast(GdkEventButton, $event);

  say qq:to/SAY/.chomp;
{ $id } received 'button-press' signal at { $be.x }, { $be.y } (root: {
  $be.x_root }, { $be.y_root }
SAY

  $r.r = 1;
}

sub setup-button-press ($item, $text) {
  $item.button-press-event.tap(-> *@a {
    on-button-press( @a[2], $text, @a[*-1] )
  });
}

sub setup_canvas ($canvas) {
  my $root = $canvas.get_root_item;

  # Unclipped items
  with Goo::Ellipse.new($root, 0, 0, 50, 30) {
    .fill-color = 'blue'; .translate(100, 100); .rotate(30, 0, 0);
    setup-button-press( $_, 'Blue ellipse (unclipped)' );
  }

  with Goo::Rect.new($root, 200, 50, 100, 100) {
    .fill-color = 'red'; .clip-fill-rule = FILL_RULE_EVEN_ODD;
    setup-button-press( $_, 'Red rectangle (unclipped)' );
  }

  with Goo::Rect.new($root, 380, 50, 100, 100) {
    .fill-color = 'yellow';
    setup-button-press( $_, 'Yellow rectangle (unclipped)' );
  }

  with Goo::Text.new($root, 'Sample Text', 520, 100, -1, GOO_CANVAS_ANCHOR_NW) {
    setup-button-press( $_, 'Text (unclipped)' );
  }

  # Clipped items
  with Goo::Ellipse.new($root, 0, 0, 50, 30) {
    .fill-color = 'blue'; .clip-path = 'M 0 0 h 100 v 100 h -100 Z';
    .translate(100, 300); .rotate(30, 0, 0);
    setup-button-press( $_ , 'Blue ellipse' );
  }

  with Goo::Rect.new($root, 200, 250, 100, 100) {
    .fill-color = 'red'; .clip-path = 'M 250 300 h 100 v 100 h -100 Z';
    .clip-fill-rule = FILL_RULE_EVEN_ODD;
    setup-button-press( $_, 'Red rectangle' );
  }

  with Goo::Rect.new($root, 380, 250, 100, 100) {
    .fill-color = 'yellow'; .clip-path = 'M480,230 l40,100 l-80 0 z';
    setup-button-press( $_, 'Yellow rectangle' );
  }

  with Goo::Text.new($root, 'Sample Text', 520, 300, -1, GOO_CANVAS_ANCHOR_NW) {
    .clip-path = 'M535,300 h75 v40 h-75 z';
    setup-button-press( $_, 'Text' );
  }

  # Table with clipped items
  my $table = Goo::Table.new($root);
  $table.translate(200, 400);
  $table.rotate(30, 0, 0);

  with Goo::Ellipse.new($table, 0, 0, 50, 30) {
    .fill-color = 'blue'; .clip-path = 'M 0 0 h 100 v 100 h -100 Z';
    .translate(100, 300); .rotate(30, 0, 0);
    setup-button-press( $_, 'Blue ellipse' );
  }

  with Goo::Rect.new($table, 200, 250, 100, 100) {
    .fill-color = 'red'; .clip-path = 'M 250 300 h 100 v 100 h -100 Z';
    .clip-fill-rule = FILL_RULE_EVEN_ODD;
    $table.set_child_property($_, 'column', 1);
    setup-button-press( $_, 'Red rectangle' );
  }

  with Goo::Rect.new($table, 380, 250, 100, 100) {
    .fill-color = 'yellow'; .clip-path = 'M480,230 l40,100 l-80 0 z';
    $table.set_child_property($_, 'column', 2);
    setup-button-press( $_, 'Yellow rectangle' );
  }

  with Goo::Text.new(
    $table, 'Sample Text', 520, 300, -1, GOO_CANVAS_ANCHOR_NW
  ) {
    .clip-path = 'M535,300 h75 v40 h-75 z';
    $table.set_child_property($_, 'column', 3);
    setup-button-press( $_, 'Text' );
  }
}

sub create_clipping_page {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  with my $sw = GTK::ScrolledWindow.new {
    .shadow_type = GTK_SHADOW_IN; .halign = .valign = GTK_ALIGN_FILL;
    .hexpand = .vexpand = True;
    .set-size-request(600, 450);
    $vbox.pack_start($_);
  }

  with Goo::Canvas.new {
    .set_size_request(600, 450); .set_bounds(0, 0, 1000, 1000);
    $sw.add($_);
    setup_canvas($_);
  }

  $vbox;
}

sub MAIN {
  my $app = GTK::Application.new( title => 'org.genex.goo.clipping' );

  $app.activate.tap({
    $app.window.add(create_clipping_page);
    $app.window.show_all;
  });

  $app.run;
}
