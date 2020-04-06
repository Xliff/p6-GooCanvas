use v6.c;

use NativeCall;

use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Ellipse;

our subset GooCanvasEllipseAncestry is export of Mu
  where GooCanvasEllipse | GooCanvasItemSimpleAncestry;

class Goo::Ellipse is Goo::CanvasItemSimple {
  also does Goo::Roles::Ellipse;

  has GooCanvasEllipse $!e;

  submethod BUILD (:$ellipse) {
    given $ellipse {
      when GooCanvasEllipseAncestry {
        my $to-parent;
        $!e = do {
          when GooCanvasEllipse {
            $to-parent = cast(GooCanvasItemSimple, $_);
            $_;
          }

          default {
            $to-parent = $_;
            cast(GooCanvasEllipse, $_);
          }
        }
        self.setSimpleCanvasItem($to-parent)
      }

      when Goo::Ellipse {
      }

      default {
      }
    }
  }

  method Goo::Raw::Definitions::GooCanvasEllipse
    #is also<Ellipse>
  { $!e }

  multi method new (GooCanvasEllipseAncestry $ellipse) {
    $ellipse ?? self.bless( :$ellipse ) !! GooCanvasEllipse;
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
    my $ellipse = goo_canvas_ellipse_new($parent, $cx, $cy, $rx, $ry, Str);

    $ellipse ?? self.bless( :$ellipse ) !! GooCanvasEllipse;
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
