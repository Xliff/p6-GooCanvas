use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Label;
use GTK::ScrolledWindow;

use Goo::Canvas;

use Goo::Model::Group;

unit package Demo::Table11;

my %globals;

sub create_item (
  $table,
  $width,
  $height,
  $row,
  $column,
  $rows,
  $columns,
  $x_expand,
  $x_shrink,
  $x_fill,
  $y_expand,
  $y_shrink,
  $y_fill
) {
  my $item = %globals<rect-obj>.new($table, 0, 0, $width, $height);
  (.stroke-color, .fill-color) = <black red> with $item;

  $table.set_child_properties($item,
    'row',      $row,      'column',   $column,   'rows',     $rows,
    'columns',  $columns,  'x-expand', $x_expand, 'y-expand', $y_expand,
    'x-shrink', $x_shrink, 'y-shrink', $y_shrink, 'x-fill',   $x_fill,
    'y-fill',   $y_fill
  );
  $item;
}

sub create_table ($opt, $parent, $x, $y, $w, $h, $l) {
  my $table = %globals<table-obj>.new($parent, $w, $h);
  $table.translate($x, $y);

  if $l {
    with $table {
      (.row-spacing, .column-spacing, .x-border-spacing, .y-border-spacing)
        = (2, 2, 1, 1);
      (.horz-grid-line-width, .vert-grid-line-width) = (1, 2);
      (.stroke-color, .fill-color) = <blue lightblue> if $opt == 1;
    }
  }

  my @o = (
    [ [0, 0, 1, 1], [0, 0, 2, 2] ],
    [ [1, 0, 1, 1], [0, 2, 1, 1] ],
    [ [2, 0, 1, 1], [1, 2, 1, 1] ],
    [ [0, 1, 1, 1], [0, 3, 2, 1] ],
    [ [1, 1, 1, 1], [2, 0, 1, 1] ],
    [ [2, 1, 1, 1], [2, 1, 1, 3] ],
    [ [0, 2, 1, 1], [3, 0, 1, 1] ],
    [ [1, 2, 1, 1], [3, 1, 1, 1] ],
    [ [2, 2, 1, 1], [3, 2, 1, 2] ]
  );

  my $oopt = -> $o { @o[$o][$opt - 1].flat };

  my ($i, @items) = ( 0 );
  @items.push: create_item($table, 17.3, 12.9, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 33.1, 17.2, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 41.6, 23.9, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table,  7.1,  5.7, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 13.5, 18.2, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 25.2, 22.1, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 11.3, 11.7, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 21.7, 18.8, |$oopt($i++), |(True xx 6) );
  @items.push: create_item($table, 22.2, 13.8, |$oopt($i++), |(True xx 6) );

  $i = 0;
  for @items {
    my $b = (
      %globals<model-mode> ?? %globals<canvas>.get_item($_) !! $_
    ).bounds;
    say "Item #{$i++}: { ($b.x1 - $x).fmt('%.2f') }, {
                         ($b.y1 - $y).fmt('%.2f') } - {
                         ($b.x2 - $x).fmt('%.2f') }, {
                         ($b.y2 - $y).fmt('%.2f') }";
  }
}

sub setup_canvas {
  my $root = %globals<model-mode> ??
    Goo::Model::Group.new !! %globals<canvas>.get_root_item;
  %globals<canvas>.root-item-model = $root if %globals<model-mode>;

  say "\nTable at default size...";
  create_table(1, $root, 50, 50, -1, -1, False);

  say "\nTable at reduced size...";
  create_table(1, $root, 250, 50, 30, 30, False);

  say "\nTable at enlarged size...";
  create_table(1, $root, 450, 50, 100, 100, False);

  say "\nTable with grid lines at default size...";
  create_table(1, $root, 50, 250, -1, -1, True);

  say "\nTable with grid lines at reduced size...";
  create_table(1, $root, 250, 250, 30, 30, True);

  say "\nTable with grid lines at enlarged size...";
  create_table(1, $root, 450, 250, 150, 150, True);

  say "Multispanning table with grid lines at default size...";
  create_table(2, $root, 50, 450, -1, -1, True);

  say "Multispanning table with grid lines at reduced size...";
  create_table(2, $root, 250, 450, 30, 30, True);

  say "Multispanning table with grid lines at enlarged size...";
  create_table(2, $root, 450, 450, 150, 150, True);
}

sub create_canvas ($text, :$int = False) {
  my $sw = GTK::ScrolledWindow.new;
  $sw.shadow-type = GTK_SHADOW_IN;
  $sw.halign  = $sw.valign  = GTK_ALIGN_FILL;
  $sw.hexpand = $sw.vexpand = True;

  %globals<canvas> = Goo::Canvas.new;
  %globals<canvas>.integer-layout = $int;
  %globals<canvas>.set_size_request(600, 250);
  %globals<canvas>.set_bounds(0, 0, 1000, 1000);
  $sw.set_size_request(600, 250);
  $sw.add(%globals<canvas>);

  say "\n\n{ $text }...";
  setup_canvas;

  $sw;
}

sub setupObjects($rect-obj, $table-obj) is export {
  %globals<rect-obj table-obj> = ($rect-obj, $table-obj);
  %globals<model-mode> = $rect-obj.^name.contains('::Model');
  %globals.gist.say;
}

sub Table_11_MAIN ($title, $rect-obj, $table-obj) is export {
  my $app = GTK::Application.new( :$title );

  setupObjects($rect-obj, $table-obj);

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.set_default_size(640, 600);

    my $vbox = GTK::Box.new-vbox(4);
    $app.window.add($vbox);

    # Top canvas
    my $label1 = GTK::Label.new('Normal Layout');
    $vbox.pack_start($label1);
    $vbox.pack_start( create_canvas('Normal Layout...') );

    # Bottom canvas
    my $label2 = GTK::Label.new('Integer Layout');
    $vbox.pack_start($label2);
    $vbox.pack_start( create_canvas('Integer Layout Canvas...', :int) );

    $app.window.show-all;
  });

  $app;
}
