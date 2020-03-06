use v6.c;

use Method::Also;

use Goo::Raw::Types;
use Goo::Raw::Rect;

use GLib::Value;

use Goo::CanvasItemSimple;

our subset GooRectAncestry is export of Mu
  where GooCanvasRect | GooCanvasItemSimpleAncestry;

class Goo::Rect is Goo::CanvasItemSimple {
  has GooCanvasRect $!r;

  submethod BUILD (:$rect) {
    self.setSimpleCanvasItem(
      cast(
        GooCanvasItemSimple,
        $!r = cast(GooCanvasRect, $rect)
      )
    );
  }

  method Goo::Raw::Definitions::GooCanvasRect
    is also<GooCanvasRect>
  { $!r }

  multi method new (GooRectAncestry $rect) {
    $rect ?? self.bless(:$rect) !! GooCanvasRect;
  }
  multi method new (
    GooCanvasItem() $parent,
    Num() $x,
    Num() $y,
    Num() $width,
    Num() $height,
  ) {
    my gdouble ($xx, $yy, $w, $h) = ($x, $y, $width, $height);
    my $rect = goo_canvas_rect_new($parent, $xx, $yy, $w, $h, Str);

    $rect ?? self.bless(:$rect) !! Nil;
  }

  # Type: gdouble
  method height is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('height', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('height', $gv);
      }
    );
  }

  # Type: gdouble
  method radius-x is rw is also<radius_x> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('radius-x', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('radius-x', $gv);
      }
    );
  }

  # Type: gdouble
  method radius-y is rw is also<radius_y> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('radius-y', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('radius-y', $gv);
      }
    );
  }

  # Type: gdouble
  method width is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('width', $gv);
      }
    );
  }

  # Type: gdouble
  method x is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('x', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x', $gv);
      }
    );
  }

  # Type: gdouble
  method y is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('y', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y', $gv);
      }
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_rect_get_type, $n, $t );
  }

}
