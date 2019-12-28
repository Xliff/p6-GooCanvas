use v6.c;

use Pango::Raw::Types;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::Label;
use GTK::ScrolledWindow;

use Goo::Canvas;

use Goo::Model::Group;

enum DemoItemType (
  DEMO_RECT_ITEM   => 0,
  DEMO_TEXT_ITEM   => 1,
  DEMO_TEXT_ITEM_2 => 2,
  DEMO_TEXT_ITEM_3 => 3,
  DEMO_WIDGET_ITEM => 4
);

# Aren't these already a part of GObject? If not, they REALLY SHOULD BE!
my (%data, %globals);

our subset ObjectOrPointer of Mu where * ~~ (
  GLib::Roles::Object,
  GTK::Roles::Pointers,
  GTK::Roles::Properties
).any;

sub get-data (ObjectOrPointer $i is copy, $k) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GLib::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k};
}
sub set-data (ObjectOrPointer $i is copy, $k, $v) {
  return unless $i.defined;
  $i = %globals<canvas>.get_item($i) if %globals<model-mode>;
  $i .= GObject
    if $i ~~ (GLib::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k} = $v;
}

sub button-press ($item, $evt, $r) {
  CATCH { default { .message.say; } }

  my $event = cast(GdkEventButton, $evt);

  say qq:to/SAY/.chomp;
{ get-data($item, 'id') // '<unknown>' } received 'button-press' signal at {
  $event.x_root }, { $event.y_root }
SAY

  $r.r = 1;
}

sub create_demo_item (
  $table,
  $demo_item_type,
  $row,
  $column,
  $rows,
  $columns,
  $text,
  $width,
  $xalign,
  $yalign,
  $text_alignment
) {
  my $item;

  given $demo_item_type {
    when DEMO_RECT_ITEM {
      $item = %globals<rect-obj>.new($table, 0, 0, 38, 19);
      $item.fill-color = 'red';
    }
    when DEMO_TEXT_ITEM | DEMO_TEXT_ITEM_2 | DEMO_TEXT_ITEM_3 {
      $item = %globals<text-obj>.new($table, $text, 0, 0, $width, GOO_CANVAS_ANCHOR_NW);
      $item.alignment = $text_alignment;
    }
    when DEMO_WIDGET_ITEM {
      my $widget = GTK::Button.new_with_label($text);
      $item = %globals<widget-obj>.new($table, $widget, 0, 0, -1, -1);
      $widget.clicked.tap({ say "Button '$text' pressed!" });
    }
  }

  $table.set_child_property($item, 'row',      $row);
  $table.set_child_property($item, 'column',   $column);
  $table.set_child_property($item, 'rows',     $rows);
  $table.set_child_property($item, 'columns',  $columns);
  $table.set_child_property($item, 'x-expand', True);
  $table.set_child_property($item, 'y-expand', True);
  $table.set_child_property($item, 'x-align',  $xalign);
  $table.set_child_property($item, 'y-align',  $yalign);

  my $new_row = $table.get_child_property($item, 'row');
  warn "Got bad row setting: { $new_row } should be: { $row }"
    unless $new_row == $row;

  set-data($item, 'id', $text);

  # Insure we are woring with a CanvasItem, not a canvasItemModel when
  # dealing with events.
  $item = %globals<canvas>.get_item($item) if %globals<model-mode>;
  $item.button-press-event.tap(-> *@a { button-press($item, |@a[2, *-1]) });
}

sub create_table (
  $parent,
	$row,
	$column,
	$embedding_level,
	$x,
	$y,
	$rotation,
	$scale,
	$demo_item_type,
	$show_grid_lines
) {
  my $table = %globals<table-obj>.new($parent);
  ($table.row-spacing, $table.column-spacing) = 4 xx 2;
  ($table.horz-grid-line-width, $table.vert-grid-line-width) = 1 xx 2
    if $show_grid_lines;
  $table.translate($x, $y);
  $table.rotate($rotation, 0, 0);
  $table.scale($scale, $scale);

  unless $row == -1 {
    $parent.set_child_properties($table, 'row',      $row);
    $parent.set_child_properties($table, 'column',   $column);
    $parent.set_child_properties($table, 'x-expand', True);
    $parent.set_child_properties($table, 'x-fill',   True);
  }

  if $embedding_level {
    my $level = $embedding_level - 1;
    my @p = ($level, 50, 50, 0, 0.7, $demo_item_type, $show_grid_lines);
    create_table($table, 0, 0, |@p);
    for (0, 45, 90, 135, 180, 225, 270, 315, 360) {
      @p[3, 4] = ($_, 1);
      @p[4] = 0.7 if $_ == 0;
      @p[4] = 1.5 if $_ == 180;
      @p[4] = 2   if $_ == 360;
      create_table($table, $_ div 135, (($_ + 135) % 135) div 45, |@p);
    }
  } elsif $demo_item_type == DEMO_TEXT_ITEM_2 {
    create_demo_item(
      $table, $demo_item_type, 0, 0, 1, 1,
			"(0.0,0.0)\nleft\naligned",
			-1, 0, 0, PANGO_ALIGN_LEFT
    );
    create_demo_item(
      $table, $demo_item_type, 0, 1, 1, 1,
			"(0.5,0.0)\ncenter\naligned",
			-1, 0.5, 0, PANGO_ALIGN_CENTER
    );
    create_demo_item(
      $table, $demo_item_type, 0, 2, 1, 1,
			"(1.0,0.0)\nright\naligned",
			-1, 1, 0, PANGO_ALIGN_RIGHT
    );

    # The layout width shouldn't really make any difference in this test.
    create_demo_item(
      $table, $demo_item_type, 1, 0, 1, 1,
      "(0.5,0.5)\ncenter\naligned",
      50, 0.5, 0.5, PANGO_ALIGN_CENTER
    );
    create_demo_item(
      $table, $demo_item_type, 1, 1, 1, 1,
      "(0.0,1.0)\nright\naligned",
      100, 0, 1.0, PANGO_ALIGN_RIGHT
    );
    create_demo_item(
      $table, $demo_item_type, 1, 2, 1, 1,
      "(0.0,0.5)\nleft\naligned",
      200, 0, 0.5, PANGO_ALIGN_LEFT
    );

    create_demo_item(
      $table, $demo_item_type, 2, 0, 1, 1,
			"(1.0,1.0)\ncenter\naligned",
			-1, 1, 1, PANGO_ALIGN_CENTER
    );
    create_demo_item(
      $table, $demo_item_type, 2, 1, 1, 1,
			"(1,0.5)\nright\naligned",
			-1, 1.0, 0.5, PANGO_ALIGN_RIGHT
    );
    create_demo_item(
      $table, $demo_item_type, 2, 2, 1, 1,
			"(0.0,0.0)\nleft\naligned",
			-1, 0, 0, PANGO_ALIGN_LEFT
    );
  } elsif $demo_item_type == DEMO_TEXT_ITEM_3 {
    create_demo_item(
      $table, $demo_item_type, 0, 0, 1, 1,
      'width 50 align 0.0, 0.0 text left aligned',
      50, 0, 0, PANGO_ALIGN_LEFT
    );
    create_demo_item(
      $table, $demo_item_type, 0, 1, 1, 1,
      'width 100 align 0.5, 0.0 text center aligned',
      100, 0.5, 0, PANGO_ALIGN_CENTER
    );
    create_demo_item(
      $table, $demo_item_type, 0, 2, 1, 1,
      'width 150 align 1.0, 0.0 text right aligned',
      150, 1, 0, PANGO_ALIGN_RIGHT
    );

    create_demo_item(
      $table, $demo_item_type, 1, 0, 1, 1,
      'width 50 align 0.5, 0.5 text center aligned',
      50, 0.5, 0.5, PANGO_ALIGN_CENTER
    );
    create_demo_item(
      $table, $demo_item_type, 1, 1, 1, 1,
      'width 100 align 0.0, 1.0 text right aligned',
      100, 0, 1.0, PANGO_ALIGN_RIGHT
    );
    create_demo_item($table, $demo_item_type, 1, 2, 1, 1,
      'width 200 align 0.0, 0.5 text left aligned',
      200, 0, 0.5, PANGO_ALIGN_LEFT
    );

    create_demo_item($table, $demo_item_type, 2, 0, 1, 1,
      'width 50 align 1.0, 1.0 text center aligned',
      50, 1, 1, PANGO_ALIGN_CENTER
    );
    create_demo_item($table, $demo_item_type, 2, 1, 1, 1,
      'width 100 align 1, 0.5 text right aligned',
      100, 1.0, 0.5, PANGO_ALIGN_RIGHT
    );
    create_demo_item($table, $demo_item_type, 2, 2, 1, 1,
      'width 50 align 0.0, 0.0 text left aligned',
      50, 0, 0, PANGO_ALIGN_LEFT
    );
  } else {
    for ^3 X ^3 -> ($y, $x) {
      create_demo_item(
        $table, $demo_item_type, $x, $y, 1, 1, "({ $x },{ $y })",
        -1, 0, 0.5, PANGO_ALIGN_LEFT
      );
    }
  }

  $table;
}

sub create_demo_table ($root, $x, $y, $w, $h) {
  my $table = %globals<table-obj>.new($root);
  (.row-spacing, .column-spacing, .width, .height) = (4, 4, $w, $h)
    with $table;
  $table.translate($x, $y);

  my $square = %globals<rect-obj>.new($table, 0, 0, 50, 50);
  $square.fill-color = 'red';
  set-data($square, 'id', 'Red square');
  $table.set-child-properties($square,
    'row', 0, 'column', 0, 'x-shrink', True
  );

  my $circle = %globals<ellipse-obj>.new($table, 0, 0, 25, 25);
  $circle.fill-color = 'blue';
  set-data($circle, 'id', 'Blue circle');

  $table.set-child-properties($circle,
    'row', 0, 'column', 1, 'x-shrink', True
  );

  my $triangle = %globals<polyline-obj>.new($table, True, 3, 25, 0, 0, 50, 50, 50);
  $triangle.fill-color = 'yellow';
  set-data($triangle, 'id', 'Yellow triangle');

  $table.set-child-properties($triangle,
    'row', 0, 'column', 2, 'x-shrink', True
  );

  for $square, $circle, $triangle {
    my $i = %globals<canvas>.get_item($_) if %globals<model-mode>;
    $i.button-press-event.tap(-> *@a { button-press($i, |@a[2, *-1]) })
  }

}

sub create_width_for_height_table (
  $root,
  $x,
  $y,
  $width,
  $height,
  $rotation
) {
  my $t = qq:to/TEXT/.chomp;
  This is a long paragraph will have to be split over a few lines so we can{''
  } see if its allocated height changes when its allocated width is changed
  TEXT

  my $table = %globals<table-obj>.new($root);
  (.width, .height) = ($width, $height) with $table;
  $table.translate($x, $y);
  $table.rotate($rotation, 0, 0);

  my $item = %globals<rect-obj>.new($table, 0, 0, $width - 10, 10);
  $item.fill-color = 'red';
  $table.set-child-properties($item,
    'row', 0, 'column', 0, 'x-shrink', True
  );

  $item = %globals<text-obj>.new($table, $t, 0, 0, -1, GOO_CANVAS_ANCHOR_NW);
  $table.set-child-properties($item,
    'row',      1,    'column',   0,     'x-expand', True, 'x-fill', True,
    'x-shrink', True, 'y-expand', True,  'y-fill',   True
  );
  set-data($item, 'id', 'Text Item');

  # Rather than reuse $item and confuse thing, we use a new lexical to
  # clarify the fact that this MAY be a different thing.
  my $i = %globals<model-mode> ?? %globals<canvas>.get_item($item) !! $item;
  $i.button-press-event.tap(-> *@a { button-press($i, |@a[2, *-1]) });

  $item = %globals<rect-obj>.new($table, 0, 0, $width - 2, 10);
  $item.fill-color = 'red';
  $table.set-child-properties($item, 'row', 2, 'column', 0, 'x-shrink', True);
}

sub create_table_page {
  my ($table, $root);

  my $vbox = GTK::Box.new-hbox(4);
  $vbox.margins = 4;

  my $sw = GTK::ScrolledWindow.new;
  $sw.shadow_type = GTK_SHADOW_IN;
  $sw.halign  = $sw.valign  = GTK_ALIGN_FILL;
  $sw.hexpand = $sw.vexpand = True;
  $vbox.pack_start($sw);

  %globals<canvas> = Goo::Canvas.new;
  %globals<canvas>.set_size_request(600, 450);
  %globals<canvas>.set_bounds(0, 0, 1000, 3000);
  $sw.set_size_request(600, 450);
  $sw.add(%globals<canvas>);

  $root = %globals<model-mode> ??
    Goo::Model::Group.new !! %globals<canvas>.get_root_item;
  %globals<canvas>.root-item-model = $root if %globals;
  create_demo_table($root, 400, 200, -1, -1);
  create_demo_table($root, 400, 260, 100, -1);

  create_table($root, -1, -1, 0, 10,  10,  0, 1.0, DEMO_TEXT_ITEM, False);
  create_table($root, -1, -1, 0, 180, 10, 30, 1.0, DEMO_TEXT_ITEM, False);
  create_table($root, -1, -1, 0, 350, 10, 60, 1.0, DEMO_TEXT_ITEM, False);
  create_table($root, -1, -1, 0, 500, 10, 90, 1.0, DEMO_TEXT_ITEM, False);

  $table = create_table(
    $root, -1, -1, 0,  30,  150,  0, 1.0, DEMO_TEXT_ITEM, False
  );
  (.width, .height) = (300, 100) with $table;

  $table = create_table(
    $root, -1, -1, 0,  30, 1400,  0, 1.0, DEMO_TEXT_ITEM_2, True
  );
  (.width, .height) = 300 xx 2 with $table;

  $table = create_table(
    $root, -1, -1, 0, 630, 1430, 30, 1.0, DEMO_TEXT_ITEM_2, True
  );
  (.width, .height) = 300 xx 2 with $table;

  create_table(
    $root, -1, -1, 0,  30, 1800,  0, 1.0, DEMO_TEXT_ITEM_3, True
  );
  create_table(
    $root, -1, -1, 0, 630, 1830, 30, 1.0, DEMO_TEXT_ITEM_3, True
  );

  create_table(
    $root, -1, -1, 1, 200,  200, 30, 0.8, DEMO_TEXT_ITEM,   False
  );

  unless %globals<model-mode> {
    $table = create_table(
      $root, -1, -1, 0,  10,  700,  0, 1.0, DEMO_WIDGET_ITEM, False
    );
    (.width, .height) = (300, 200) with $table;
  }

  create_width_for_height_table($root, 100, 1000, 200, -1, 0);
  create_width_for_height_table($root, 100, 1200, 300, -1, 0);
  create_width_for_height_table($root, 500, 1000, 200, -1, 30);
  create_width_for_height_table($root, 500, 1200, 300, -1, 30);

  $vbox;
}

sub setupObjects (
  $ellipse-obj  is copy,
  $polyline-obj is copy,
  $rect-obj     is copy,
  $table-obj    is copy,
  $text-obj     is copy,
  $widget-obj?  is copy
)
  is export
{
  # Note: Parameters are a special-case situation, when it comes to container
  #       handling. If you specify a parameter WITHOUT "is copy", then what
  #       you are really getting is a bound container, and the expression below
  #       will error out with the LTA message:
  #
  # Use of Nil in string context
  # in block  at /home/cbwood/Projects/p6-GooCanvas/t/Demo/Table10.pm6 (Demo::Table10) line 399
  # Start argument to substr out of range. Is: 1, should be in 0..0; use *-1 if you want to index relative to the end
  #
  # To make parameters TRUE lexicals, you MUST use "is copy".
  %globals{ .VAR.name.substr(1) } = $_ for $ellipse-obj,
                                           $polyline-obj,
                                           $rect-obj,
                                           $table-obj,
                                           $text-obj,
                                           $widget-obj;
  %globals<model-mode> = $ellipse-obj.^name.contains('::Model');
}

sub Table_10_MAIN (
  $title,
  $ellipse-obj,
  $polyline-obj,
  $rect-obj,
  $table-obj,
  $text-obj,
  $widget-obj?
)
  is export
{
  my $app = GTK::Application.new( :$title );

  setupObjects(
    $ellipse-obj,
    $polyline-obj,
    $rect-obj,
    $table-obj,
    $text-obj,
    $widget-obj
  );

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.add(create_table_page);
    $app.window.show-all;
  });

  $app;
}
