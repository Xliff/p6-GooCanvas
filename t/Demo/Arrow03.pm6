use v6.c;

use NativeCall;

use Cairo;

use Goo::Raw::Types;

use GDK::Cursor;
use Goo::Canvas;
use Goo::Points;

use GTK::Application;
use GTK::Box;
use GTK::Frame;
use GTK::Label;

use Goo::CanvasItemSimple;

use Goo::Model::Group;
use Goo::Model::Rect;

enum OurDirection (
  LEFT   => 50.0,
  RIGHT  => 350.0,
  MIDDLE => 150.0
);

enum OurShapes (
  DEFAULT_SHAPE_A => 4,
  DEFAULT_SHAPE_B => 5,
  DEFAULT_SHAPE_C => 4
);

constant DEFAULT_WIDTH = 2;

my (%data, %globals, $app);

sub set_dimension ($arrow, $text, Array $points, $tx, $ty, $dim) {
  my $pts = Goo::Points.new(2);
  $pts.set_points($points);

  %data<canvas>{$arrow}.points = $pts;
  %data<canvas>{$text}.text    = $dim;
  %data<canvas>{$text}.x       = $tx;
  %data<canvas>{$text}.y       = $ty;
}

sub move_drag_box ($box, $x, $y) {
  %data<canvas>{$box}.x = $x - 5;
  %data<canvas>{$box}.y = $y - 5;
}

sub set_arrow_shape {
  my ($shape_a, $shape_b, $shape_c, $width);
  with %data<canvas><big_arrow> {
    .line-width       = 10 * ($width = %data<canvas><width>);
    .arrow-tip-length =    ($shape_a = %data<canvas><shape_a>);
    .arrow-length     =    ($shape_b = %data<canvas><shape_b>);
    .arrow-width      =    ($shape_c = %data<canvas><shape_c>);
  }

  # Outline
  my $points = Goo::Points.new(5);
  my @p = (
    RIGHT  - 10 *  $shape_a * $width,
    MIDDLE - 10 *  $width            / 2.0,
    RIGHT  - 10 *  $shape_b * $width,
    MIDDLE - 10 * ($shape_c * $width / 2.0),
    RIGHT,
    MIDDLE
  );
  @p.push: @p[2];
  @p.push: MIDDLE + 10 * ($shape_c * $width / 2.0);
  @p.push: @p[0];
  @p.push: MIDDLE + 10 * $width / 2;
  $points.set_points(@p);
  %data<canvas><outline>.points = $points;

  # Drag Boxes
  move_drag_box(
    'width_drag_box',
    LEFT,
    MIDDLE - 10 * $width / 2
  );
  move_drag_box(
    'shape_a_drag_box',
    RIGHT - 10 * $shape_a * $width,
    MIDDLE
  );
  move_drag_box(
    'shape_b_c_drag_box',
    RIGHT  - 10 * $shape_b * $width,
    MIDDLE - 10 * $shape_c * $width / 2
  );

  # Dimensions
  set_dimension('width_arrow', 'width_text',
    [
      LEFT   - 10,
      MIDDLE - 10 * $width / 2,
      LEFT   - 10,
      MIDDLE + 10 * $width / 2
    ],
    LEFT   - 15,
    MIDDLE,
    $width.Int
  );

  set_dimension('shape_a_arrow', 'shape_a_text',
    [
      RIGHT  - 10 * $shape_a * $width,
      MIDDLE + 10 * $shape_c * $width / 2 + 10,
      RIGHT,
      MIDDLE + 10 * $shape_c * $width / 2 + 10
    ],
    RIGHT  - 10 * $shape_a * $width / 2,
    MIDDLE + 10 * $shape_c * $width / 2 + 15,
    $shape_a.Int
  );

  set_dimension('shape_b_arrow', 'shape_b_text',
    [
      RIGHT  - 10 *  $shape_b * $width,
      MIDDLE + 10 * ($shape_c * $width / 2.0) + 35,
      RIGHT,
      MIDDLE + 10 * ($shape_c * $width / 2.0) + 35
    ],
    RIGHT  - 10 *  $shape_b * $width / 2.0,
    MIDDLE + 10 * ($shape_c * $width / 2.0) + 40,
    $shape_b.Int
  );

  set_dimension('shape_c_arrow', 'shape_c_text',
    [
      RIGHT  + 10,
      MIDDLE - 10 * $shape_c * $width / 2,
      RIGHT  + 10,
      MIDDLE + 10 * $shape_c * $width / 2
    ],
    RIGHT  + 15,
    MIDDLE,
    $shape_c.Int
  );

  # Info
  %data<canvas><width_info>.text   = "line-width: { $width.Int }";
  %data<canvas><shape_a_info>.text =
    "arrow-tip-length: { $shape_a.Int } (* line-width)";
  %data<canvas><shape_b_info>.text =
    "arrow-length: { $shape_b.Int } (* line-width)";
  %data<canvas><shape_c_info>.text =
    "arrow-width: { $shape_c.Int } (* line-width)";

  # Sample arrows
  for <sample_1 sample_2 sample_3> {
    with %data<canvas>{$_} {
      .line-width        = $width;
      .arrow-tip-length  = $shape_a;
      .arrow-length      = $shape_b;
      .arrow-width       = $shape_c;
    }
  }
}

sub create_dimension ($root, $arrow, $text, $anchor) {
  with %data<canvas>{$arrow} = %globals<polyline-obj>.new($root, False, 0) {
    .fill-color  = 'black';
    .start-arrow = True;
    .end-arrow   = True;
  }

  with
    %data<canvas>{$text} = %globals<text-obj>.new(
      $root, Str, 0, 0, -1, $anchor
    )
  {
    .fill-color = 'black';
    .font       = 'Sans 12';
  }
}

sub create_info ($root, $info, $x, $y) {
  with %data<canvas>{$info} =
    %globals<text-obj>.new($root, Str, $x, $y, -1, GOO_CANVAS_ANCHOR_NW)
  {
    .fill-color = 'black';
    .font       = 'Sans 14';
  }
}

multi sub create_sample_arrow ($root, $sample, @p) {
  samewith($root, $sample, |@p);
}
multi sub create_sample_arrow ($root, $sample, $x1, $y1, $x2, $y2) {
  with %data<canvas>{$sample} =
    %globals<polyline-obj>.new_line($root, $x1, $y1, $x2, $y2)
  {
    .start-arrow = True;
    .end-arrow   = True;
  }
}

sub button_press ($item, $target, $event, $r) {
  CATCH { default { .message.say; $app.exit; } }

  my $canvas = $item.canvas;
  my $fleur = GDK::Cursor.new_for_display($canvas.display, GDK_FLEUR);
  my $mask = GDK_POINTER_MOTION_MASK +|
             GDK_POINTER_MOTION_HINT_MASK +|
             GDK_BUTTON_RELEASE_MASK;
  my $button_event = cast(GdkEventButton, $event);
  $canvas.pointer_grab($item, $mask, $fleur, $button_event.time);
  $r.r = 1;
}

sub button_release ($item, $target, $event, $r) {
  CATCH { default { .message.say; $app.exit; } }

  my $button_event = cast(GdkEventButton, $event);
  $item.canvas.pointer_ungrab($item, $button_event.time);
  $r.r = 1;
}

sub on_motion ($item, $target, $event, $r) {
  CATCH { default { .message.say; $app.exit }; }

  my $button_event = cast(GdkEventButton, $event);
  return ($r.r = 0) unless $button_event.state +& GDK_BUTTON1_MASK;

  my ($p, $width, $change) = (
    +(%globals<model-mode> ??
      Goo::CanvasItemSimple.new($target).get_model.GooCanvasItemModel !!
      $item.GooCanvasItem
    ).p,
    Nil,
    False
  );

  my $meth-name = %globals<model-mode> ?? 'GooCanvasItemModel'
                                       !! 'GooCanvasItem';

  if $p == +%data<canvas><width_drag_box>."$meth-name"().p {
    my $y     = $button_event.y;
    my $width = (MIDDLE - $y) / 5;

    return ($r.r = 0) if $width < 0;
    %data<canvas><width> = $width;
    set_arrow_shape;
  } elsif $p == +%data<canvas><shape_a_drag_box>."$meth-name"().p {
    my $x       = $button_event.x;
    my $width   = %data<canvas><width>;
    my $shape_a = (RIGHT - $x) / 10 / $width;

    return ($r.r = 0) unless $shape_a ~~ 0..30;
    %data<canvas><shape_a> = $shape_a;
    set_arrow_shape;
  } elsif $p == +%data<canvas><shape_b_c_drag_box>."$meth-name"().p {
    my ($x, $y) = ($button_event.x, $button_event.y);
    my $width   = %data<canvas><width>;
    my $shape_b = (RIGHT  - $x)     / 10 / $width;
    my $shape_c = (MIDDLE - $y) * 2 / 10 / $width;

    if $shape_b ~~ 0..30 {
      %data<canvas><shape_b> = $shape_b;
      $change = True;
    }
    if $shape_c > 0 {
      %data<canvas><shape_c> = $shape_c;
      $change = True;
    }
    set_arrow_shape if $change;
  }

  $r.r = 1;
}

sub set_events ($item) {
  CATCH { default { .message.say; $app.exit } }

  $item.enter-notify-event.tap(-> *@a {
    CATCH { default { .message.say } }
    my $i = $item;
    $i .= get_model if %globals<model-mode>;
    $i.fill-color = 'red'; @a[*-1].r = 1
  });

  $item.leave-notify-event.tap(-> *@a {
    CATCH { default { .message.say } }
    my $i = $item;
    $i .= get_model if %globals<model-mode>;
    $i.fill-color = 'black'; @a[*-1].r = 1
  });

  $item.button-press-event  .tap(-> *@a {
    CATCH { default { .message.say; $app.exit } }
    button_press(   $item, |@a[1...2, *-1] )
  });
  $item.button-release-event.tap(-> *@a {
    CATCH { default { .message.say; $app.exit } }
    button_release( $item, |@a[1...2, *-1] )
  });
  $item.motion-notify-event. tap(-> *@a {
    CATCH { default { .message.say; $app.exit } }
    on_motion(      $item, |@a[1...2, *-1] )
  });
}

sub create_drag_box ($root, $box) {
  my $item = %globals<rect-obj>.new($root, 0, 0, 10, 10);
  ($item.fill-color, $item.stroke-color) = 'black' xx 2;
  $item.line-width = 1;
  set_events($item) unless %globals<model-mode>;
  %data<canvas>{$box} = $item;
}

sub create_canvas_arrowhead is export {

  %globals<vbox> = GTK::Box.new-vbox(4);
  %globals<vbox>.margins = 4;
  %globals<label> = GTK::Label.new(q:to/LABEL/.chomp);
This demo allows you to edit arrowhead shapes.  Drag the little boxes
to change the shape of the line and its arrowhead.  You can see the
arrows at their normal scale on the right hand side of the window.
LABEL
  %globals<vbox>.pack_start(%globals<label>);

  with %globals<frame> = GTK::Frame.new(Str) {
    .halign  = .valign  = GTK_ALIGN_CENTER;
    .hexpand = .vexpand = True;
  }
  %globals<frame>.shadow_type = GTK_SHADOW_IN;
  %globals<vbox>.pack_start(%globals<frame>);

  %globals<canvas> = Goo::Canvas.new;
  %globals<canvas>.item-created.tap(-> *@a {
    CATCH { default { .message.say } }
    if Goo::Model::Rect.is_type( @a[2] ) {
      set_events(
        Goo::CanvasItemSimple.new( @a[1] )
      );
    }
  }) if %globals<model-mode>;

  my $root = %globals<model-mode> ??
    Goo::Model::Group.new !! %globals<canvas>.get_root_item;
  %globals<canvas>.root-item-model = $root if %globals<model-mode>;

  %globals<canvas>.set_size_request(500, 350);
  %globals<canvas>.set_bounds(0, 0, 500, 350);
  %globals<frame>.add(%globals<canvas>);

  %data<canvas><width>   = DEFAULT_WIDTH.Int;
  %data<canvas><shape_a> = DEFAULT_SHAPE_A.Int;
  %data<canvas><shape_b> = DEFAULT_SHAPE_B.Int;
  %data<canvas><shape_c> = DEFAULT_SHAPE_C.Int;

  # Big Arrow
  (.stroke-color, .end-arrow) = ('mediumseagreen', True) with
    %data<canvas><big_arrow> = %globals<polyline-obj>.new_line(
      $root, LEFT, MIDDLE, RIGHT, MIDDLE
    );

  # Arrow outline
  with %data<canvas><outline> = %globals<polyline-obj>.new($root, True, 0) {
    (.stroke-color, .line-width) = ('black', 2);
    # Setting this using the above method generates lots of GTK warnings.
    # Using the standard method, solves the problem.
    .line-cap = LINE_CAP_ROUND;
    .line-join = LINE_JOIN_ROUND;
  }

  # Drag Boxes
  create_drag_box($root, 'width_drag_box');
  create_drag_box($root, 'shape_a_drag_box');
  create_drag_box($root, 'shape_b_c_drag_box');

  # Dimensions
  create_dimension($root, 'width_arrow',   'width_text',   GOO_CANVAS_ANCHOR_E);
  create_dimension($root, 'shape_a_arrow', 'shape_a_text', GOO_CANVAS_ANCHOR_N);
  create_dimension($root, 'shape_b_arrow', 'shape_b_text', GOO_CANVAS_ANCHOR_N);
  create_dimension($root, 'shape_c_arrow', 'shape_c_text', GOO_CANVAS_ANCHOR_W);

  # Info
  create_info($root, 'width_info',   LEFT, 260);
  create_info($root, 'shape_a_info', LEFT, 280);
  create_info($root, 'shape_b_info', LEFT, 300);
  create_info($root, 'shape_c_info', LEFT, 320);

  # Divisioin line
  (.fill-color, .line-width) = ('black', 2) with
    %globals<divline> = %globals<polyline-obj>.new_line(
      $root, RIGHT + 50, 0, RIGHT + 50, 1000
    );

  # Sample arrows
  create_sample_arrow($root, 'sample_1',
         RIGHT + 100, 30,          RIGHT + 100, MIDDLE - 30  );
  create_sample_arrow($root, 'sample_2',
         RIGHT + 70,  MIDDLE,      RIGHT + 130, MIDDLE       );
  create_sample_arrow($root, 'sample_3',
         RIGHT + 70,  MIDDLE + 30, RIGHT + 130, MIDDLE + 120 );

  set_arrow_shape;

  %globals<vbox>;
}

sub Arrow_03_MAIN($rect-obj, $polyline-obj, $text-obj) is export {
  $app = GTK::Application.new( title => 'org.genex.goo.arrow' );

  $app.activate.tap({
    $app.wait-for-init;
    %globals<rect-obj   polyline-obj   text-obj> = (
            $rect-obj, $polyline-obj, $text-obj
    );
    %globals<model-mode> = %globals<rect-obj>.^name.contains('::Model');
    $app.window.set_default_size(800, 600);
    $app.window.add(create_canvas_arrowhead);
    $app.window.show_all;
  });

  $app
}
