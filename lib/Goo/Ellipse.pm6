use v6.c;

use NativeCall;


use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Ellipse;

class Goo::Ellipse is Goo::CanvasItemSimple {
  also does Goo::Roles::Ellipse;
  
  has GooCanvasEllipse $!e;

  submethod BUILD (:$ellipse) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!e = $ellipse) )
  }

  method Goo::Raw::Types::GooCanvasEllipse
    #is also<Ellipse>
  { $!e }

  multi method new (GooCanvasEllipse $ellipse) {
    self.bless( :$ellipse );
  }
  multi method new (
    GooCanvasItem() $parent,
    Num() $center_x,
    Num() $center_y,
    Num() $radius_x,
    Num() $radius_y
  ) {
    my gdouble ($cx, $cy, $rx, $ry) =
      ($center_x, $center_y, $radius_x, $radius_y);
    self.bless(
      ellipse => goo_canvas_ellipse_new($parent, $cx, $cy, $rx, $ry, Str)
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_ellipse_get_type, $n, $t );
  }

}

sub goo_canvas_ellipse_new (
  GooCanvasItem $parent,
  gdouble       $center_x,
  gdouble       $center_y,
  gdouble       $radius_x,
  gdouble       $radius_y,
  Str
)
  returns GooCanvasEllipse
  is native(goo)
  is export
  { * }

sub goo_canvas_ellipse_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
