use v6.c;

use NativeCall;


use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Image;

class Goo::Model::Image is Goo::Model::Simple {
  also does Goo::Roles::Image;

  method new (
    GooCanvasItemModel() $parent,
    GdkPixbuf()          $pixbuf,
    Num()                $x,
    Num()                $y,
    *@props
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    self.bless(
      simple => goo_canvas_image_model_new($parent, $pixbuf, $xx, $yy, Str),
      props  => @props
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_image_model_get_type, $n, $t );
  }
}

sub goo_canvas_image_model_new (
  GooCanvasItemModel $parent,
  GdkPixbuf          $pixbuf,
  gdouble            $x,
  gdouble            $y,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_image_model_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
