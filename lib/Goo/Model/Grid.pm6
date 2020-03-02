use v6.c;

use NativeCall;

use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Grid;

class Goo::Model::Grid is Goo::Model::Simple {
  also does Goo::Roles::Grid;

  method new (
    GooCanvasItemModel() $parent,
    Num()                $x,
    Num()                $y,
    Num()                $width,
    Num()                $height,
    Num()                $x_step,
    Num()                $y_step,
    Num()                $x_offset,
    Num()                $y_offset,
    *@props
  ) {
    my gdouble ($xx, $yy, $w,   $h) = ($x, $y, $width, $height);
    my gdouble ($xs, $ys, $xo, $yo) = ($x_step, $y_step, $x_offset, $y_offset);
    my $simple = goo_canvas_grid_model_new(
      $parent,
      $xx, $yy,
      $w, $h,
      $xs, $ys,
      $xo, $yo,
      Str
    );

    $simple ?? self.bless(:$simple, :@props) !! GooCanvasItemModel;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &goo_canvas_grid_model_get_type,
      $n,
      $t
    );
  }

}

sub goo_canvas_grid_model_new (
  GooCanvasItemModel $parent,
  gdouble            $x,
  gdouble            $y,
  gdouble            $width,
  gdouble            $height,
  gdouble            $x_step,
  gdouble            $y_step,
  gdouble            $x_offset,
  gdouble            $y_offset,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_grid_model_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
