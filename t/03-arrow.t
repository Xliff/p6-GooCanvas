use v6.c;

use Cairo;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Enums;

use Goo::Canvas;
use Goo::Polyline;
use Goo::Points;
use Goo::Rect;
use Goo::Text;

use GTK::Application;
use GTK::Box;
use GTK::Frame;
use GTK::Label;

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
  %data<canvas><shape_a_info>.text = "arrow-tip-length: { $shape_a.Int } (* line-width)";
  %data<canvas><shape_b_info>.text = "arrow-length: { $shape_b.Int } (* line-width)";
  %data<canvas><shape_c_info>.text = "arrow-width: { $shape_c.Int } (* line-width)";

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
  with %data<canvas>{$arrow} = Goo::Polyline.new($root, False, 0) {
    .fill-color  = 'black';
    .start-arrow = True;
    .end-arrow   = True;
  }

  with %data<canvas>{$text} = Goo::Text.new($root, Str, 0, 0, -1, $anchor) {
    .fill-color = 'black';
    .font       = 'Sans 12';
  }
}

sub create_info ($root, $info, $x, $y) {
  with %data<canvas>{$info} =
    Goo::Text.new($root, Str, $x, $y, -1, GOO_CANVAS_ANCHOR_NW)
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
    Goo::Polyline.new_line($root, $x1, $y1, $x2, $y2)
  {
    .start-arrow = True;
    .end-arrow   = True;
  }
}

sub button_press ($item, $event, $r) {
  CATCH { default { .message.say; $app.exit; } }

  my $canvas = $item.canvas;
  my $fleur = GTK::Compat::Cursor.new_for_display($canvas.display, GDK_FLEUR);
  my $mask = GDK_POINTER_MOTION_MASK +|
             GDK_POINTER_MOTION_HINT_MASK +|
             GDK_BUTTON_RELEASE_MASK;
  my $button_event = cast(GdkEventButton, $event);
  $canvas.pointer_grab($item, $mask, $fleur, $button_event.time);
  $r.r = 1;
}

sub button_release ($item, $event, $r) {
  CATCH { default { .message.say; $app.exit; } }

  my $button_event = cast(GdkEventButton, $event);
  $item.canvas.pointer_ungrab($item, $button_event.time);
  $r.r = 1;
}

sub on_motion ($item, $event, $r) {
  CATCH { default { .message.say; $app.exit }; }

  my $button_event = cast(GdkEventButton, $event);
  return ($r.r = 0) unless $button_event.state +& GDK_BUTTON1_MASK;

  my ($p, $width, $change) = ( +$item.CanvasItem.p, Nil, False );
  if $p == +%data<canvas><width_drag_box>.CanvasItem.p {
    my $y     = $button_event.y;
    my $width = (MIDDLE - $y) / 5;

    return ($r.r = 0) if $width < 0;
    %data<canvas><width> = $width;
    set_arrow_shape;
  } elsif $p == +%data<canvas><shape_a_drag_box>.CanvasItem.p {
    my $x       = $button_event.x;
    my $width   = %data<canvas><width>;
    my $shape_a = (RIGHT - $x) / 10 / $width;

    return ($r.r = 0) unless $shape_a ~~ 0..30;
    %data<canvas><shape_a> = $shape_a;
    set_arrow_shape;
  } elsif $p == +%data<canvas><shape_b_c_drag_box>.CanvasItem.p {
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

sub create_drag_box ($root, $box) {
  with ( my $item = Goo::Rect.new($root, 0, 0, 10, 10) ) {
    (.fill-color, .stroke-color) = 'black' xx 2;
    .line-width = 1;
    .enter-notify-event.tap(-> *@a { .fill-color = 'red';   @a[* - 1].r = 1 });
    .leave-notify-event.tap(-> *@a { .fill-color = 'black'; @a[* - 1].r = 1 });

    .button-press-event  .tap(-> *@a { button_press(   $_, |@a[2, *-1] ) });
    .button-release-event.tap(-> *@a { button_release( $_, |@a[2, *-1] ) });
    .motion-notify-event. tap(-> *@a { on_motion(      $_, |@a[2, *-1] ) });
  }
  %data<canvas>{$box} = $item;
}

sub create_canvas_arrowhead {
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

  my $root = (%globals<canvas> = Goo::Canvas.new).get_root_item;
  %globals<canvas>.set_size_request(500, 350);
  %globals<canvas>.set_bounds(0, 0, 500, 350);
  %globals<frame>.add(%globals<canvas>);

  %data<canvas><width>   = DEFAULT_WIDTH.Int;
  %data<canvas><shape_a> = DEFAULT_SHAPE_A.Int;
  %data<canvas><shape_b> = DEFAULT_SHAPE_B.Int;
  %data<canvas><shape_c> = DEFAULT_SHAPE_C.Int;

  # Big Arrow
  (.stroke-color, .end-arrow) = ('mediumseagreen', True) with
    %data<canvas><big_arrow> = Goo::Polyline.new_line(
      $root, LEFT, MIDDLE, RIGHT, MIDDLE
    );

  # Arrow outline
  with %data<canvas><outline> = Goo::Polyline.new($root, True, 0) {
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
    %globals<divline> = Goo::Polyline.new_line(
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

sub MAIN {
  $app = GTK::Application.new( title => 'org.genex.goo.arrow' );

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.set_default_size(800, 600);
    $app.window.add(create_canvas_arrowhead);
    $app.window.show_all;
  });

  $app.run;
}
