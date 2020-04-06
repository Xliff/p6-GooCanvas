use v6.c;

use NativeCall;


use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Image;

class Goo::Image is Goo::CanvasItemSimple {
  also does Goo::Roles::Image;

  has GooCanvasImage $!gi;

  submethod BUILD (:$image) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!gi = $image) )
  }

  multi method new (GooCanvasImage $image) {
    self.bless(:$image);
  }
  multi method new (
    GooCanvasItem() $parent,
    GdkPixbuf()     $pixbuf,
    Num()           $x,
    Num()           $y
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    self.bless(
      image => goo_canvas_image_new($parent, $pixbuf, $xx, $yy, Str)
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_image_get_type, $n, $t );
  }

}

sub goo_canvas_image_new (
  GooCanvasItem $parent,
  GdkPixbuf     $pixbuf,
  gdouble       $x,
  gdouble       $y,
  Str
)
  returns GooCanvasImage
  is native(goo)
  is export
  { * }

sub goo_canvas_image_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
