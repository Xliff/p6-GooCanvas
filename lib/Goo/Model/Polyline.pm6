use v6.c;

use Method::Also;
use NativeCall;

use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Polyline;

class Goo::Model::Polyline is Goo::Model::Simple {
  also does Goo::Roles::Polyline;

  method new (
    GooCanvasItemModel() $parent,
    Int()                $close_path,
    Int()                $num_points,
    *@props
  ) {
    my gboolean $cp = $close_path.so.Int;
    my gint $np = $num_points;
    my @points = @props[0] ~~ Str ?? () !! @props.splice(0, $num_points * 2);
    my $simple = goo_canvas_polyline_model_new($parent, $cp, $np, Str);

    return GooCanvasItemModel unless $simple;

    my $o = self.bless( :$simple, :@props );
    $o.points = @points if +@points;
    $o;
  }

  multi method new_line (
    GooCanvasItemModel() $parent,
    Num()                $x1,
    Num()                $y1,
    Num()                $x2,
    Num()                $y2,
    *@props
  )
    is also<new-line>
  {
    my ($xx1, $yy1, $xx2, $yy2) = ($x1, $y1, $x2, $y2);

    my $simple = goo_canvas_polyline_model_new_line(
      $parent,
      $xx1,
      $yy1,
      $xx2,
      $yy2,
      Str
    );

    $simple ?? self.bless( :$simple, :@props ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name, &goo_canvas_polyline_model_get_type, $n, $t
    );
  }

}

sub goo_canvas_polyline_model_new (
  GooCanvasItemModel $parent,
  gboolean $close_path,
  gint $num_points,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_polyline_model_new_line (
  GooCanvasItemModel $parent,
  gdouble $x1,
  gdouble $y1,
  gdouble $x2,
  gdouble $y2,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_polyline_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
