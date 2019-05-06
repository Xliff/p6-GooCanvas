use v6.c;

use NativeCall;

use GTK::Compat::Types;

use GTK::Compat::Roles::Object;

use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Rect;

class Goo::Model::Rect is Goo::Model::Simple {
  also does Goo::Roles::Rect;

  method new (
    GooCanvasItemModel() $parent,
    Num()                $x,
    Num()                $y,
    Num()                $width,
    Num()                $height,
    *@props
  ) {
    my gdouble ($xx, $yy, $w, $h) = ($x, $y, $width, $height);
    self.bless(
      simple => goo_canvas_rect_model_new($parent, $xx, $yy, $w, $h, Str),
      props  => @props
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_rect_model_get_type, $n, $t );
  }
}

sub goo_canvas_rect_model_new (
  GooCanvasItemModel $parent,
  gdouble $x,
  gdouble $y,
  gdouble $width,
  gdouble $height,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_rect_model_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
