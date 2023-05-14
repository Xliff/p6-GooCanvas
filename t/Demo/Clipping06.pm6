use v6.c;

use Cairo;

use Goo::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::ScrolledWindow;

use Goo::Canvas;

use Goo::Model::Group;

my %globals;

sub on-button-press ($event, $id, $r) {
  my $be = cast(GdkEventButton, $event);

  say qq:to/SAY/.chomp;
    { $id } received 'button-press' signal at { $be.x }, { $be.y } (root: {
      $be.x_root }, { $be.y_root })
    SAY

  $r.r = 1;
}

sub setup-button-press ($item, $text) {
  $item.button-press-event.tap(-> *@a {
    on-button-press( @a[2], $text, @a[*-1] )
  });
}

sub setup_canvas ($canvas) {
  CATCH { default { .message.say } }

  my $root = %globals<model-mode> ??
    Goo::Model::Group.new !! $canvas.root_item;
  $canvas.root-item-model = $root if %globals<model-mode>;

  # Unclipped items
  with %globals<ellipse-obj>.new($root, 0, 0, 50, 30) {
    .fill-color = 'blue'; .translate(100, 100); .rotate(30, 0, 0);
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Blue ellipse (unclipped)'
    );
  }

  with %globals<rect-obj>.new($root, 200, 50, 100, 100) {
    .fill-color = 'red'; .clip-fill-rule = FILL_RULE_EVEN_ODD;
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Red rectangle (unclipped)'
    );
  }

  with %globals<rect-obj>.new($root, 380, 50, 100, 100) {
    .fill-color = 'yellow';
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Yellow rectangle (unclipped)'
    );
  }

  with %globals<text-obj>.new(
    $root,
    'Sample Text',
    520, 100, -1,
    GOO_CANVAS_ANCHOR_NW
  ) {
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Text (unclipped)'
    );
  }

  # Clipped items
  with %globals<ellipse-obj>.new($root, 0, 0, 50, 30) {
    .fill-color = 'blue'; .clip-path = 'M 0 0 h 100 v 100 h -100 Z';
    .translate(100, 300); .rotate(30, 0, 0);
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Blue ellipse'
    );
  }

  with %globals<rect-obj>.new($root, 200, 250, 100, 100) {
    .fill-color = 'red'; .clip-path = 'M 250 300 h 100 v 100 h -100 Z';
    .clip-fill-rule = FILL_RULE_EVEN_ODD;
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Red rectangle'
    );
  }

  with %globals<rect-obj>.new($root, 380, 250, 100, 100) {
    .fill-color = 'yellow'; .clip-path = 'M480,230 l40,100 l-80 0 z';
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Yellow rectangle'
    );
  }

  with %globals<text-obj>.new(
    $root,
    'Sample Text',
    520, 300, -1,
    GOO_CANVAS_ANCHOR_NW
  ) {
    .clip-path = 'M535,300 h75 v40 h-75 z';
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Text'
    );
  }

  # Table with clipped items
  my $table = %globals<table-obj>.new($root);
  $table.translate(200, 400);
  $table.rotate(30, 0, 0);

  with %globals<ellipse-obj>.new($table, 0, 0, 50, 30) {
    .fill-color = 'blue'; .clip-path = 'M 0 0 h 100 v 100 h -100 Z';
    .translate(100, 300); .rotate(30, 0, 0);
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Blue ellipse'
    );
  }

  with %globals<rect-obj>.new($table, 200, 250, 100, 100) {
    .fill-color = 'red'; .clip-path = 'M 250 300 h 100 v 100 h -100 Z';
    .clip-fill-rule = FILL_RULE_EVEN_ODD;
    $table.set_child_property($_, 'column', 1);
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Red rectangle'
    );
  }

  with %globals<rect-obj>.new($table, 380, 250, 100, 100) {
    .fill-color = 'yellow'; .clip-path = 'M480,230 l40,100 l-80 0 z';
    $table.set_child_property($_, 'column', 2);
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Yellow rectangle'
    );
  }

  with %globals<text-obj>.new(
    $table, 'Sample Text', 520, 300, -1, GOO_CANVAS_ANCHOR_NW
  ) {
    .clip-path = 'M535,300 h75 v40 h-75 z';
    $table.set_child_property($_, 'column', 3);
    setup-button-press(
      %globals<model-mode> ?? $canvas.get_item($_) !! $_,
      'Text'
    );
  }
}

sub create_clipping_page {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  with my $sw = GTK::ScrolledWindow.new {
    .shadow_type = GTK_SHADOW_IN; .halign = .valign = GTK_ALIGN_FILL;
    .hexpand = .vexpand = True;
    .set-size-request(800, 600);
    $vbox.pack_start($_);
  }

  with Goo::Canvas.new {
    .set_size_request(600, 450); .set_bounds(0, 0, 1000, 1000);
    $sw.add($_);
    setup_canvas($_);
  }

  $vbox;
}

sub setupObjects ($ellipse-obj, $rect-obj, $table-obj, $text-obj) is export {
  %globals<ellipse-obj   rect-obj   table-obj   text-obj> =
    (     $ellipse-obj, $rect-obj, $table-obj, $text-obj );
  %globals<model-mode> = $ellipse-obj.^name.contains('::Model');
}

sub Clipping_06_MAIN (
  $ellipse-obj,
  $rect-obj,
  $table-obj,
  $text-obj
) is export {
  my $app = GTK::Application.new( title => 'org.genex.goo.clipping' );

  setupObjects($ellipse-obj, $rect-obj, $table-obj, $text-obj);

  $app.activate.tap( -> *@a {
    $app.window.add(create_clipping_page);
    $app.window.show_all;
  });

  $app;
}
