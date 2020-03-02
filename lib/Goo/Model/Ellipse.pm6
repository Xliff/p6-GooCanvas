use v6.c;

use NativeCall;

use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Ellipse;

class Goo::Model::Ellipse is Goo::Model::Simple {
  also does Goo::Roles::Ellipse;

  method new (
    GooCanvasItemModel() $parent,
    Num()                $center_x,
    Num()                $center_y,
    Num()                $radius_x,
    Num()                $radius_y,
    *@props
  ) {
    my gdouble ($cx, $cy, $rx, $ry) =
      ($center_x, $center_y, $radius_x, $radius_y);
    my $simple = goo_canvas_ellipse_model_new(
      $parent,
      $cx, $cy, $rx, $ry,
      Str
    );

    $simple ?? self.bless(:$simple, :@props) !! Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &goo_canvas_ellipse_model_get_type,
      $n,
      $t
    );
  }

}

sub goo_canvas_ellipse_model_new (
  GooCanvasItemModel $parent,
  gdouble            $center_x,
  gdouble            $center_y,
  gdouble            $radius_x,
  gdouble            $radius_y,
  Str
)
  returns GooCanvasEllipse
  is native(goo)
  is export
  { * }

sub goo_canvas_ellipse_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
