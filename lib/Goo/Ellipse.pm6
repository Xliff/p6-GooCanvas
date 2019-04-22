use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use Goo::CanvasItemSimple;

class Goo::Ellipse is Goo::CanvasItemSimple {
  has GooCanvasEllipse $!e;

  submethod BUILD (:$ellipse) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!e = $ellipse) )
  }

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

  # Type: gdouble
  method center-x is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('center-x', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('center-x', $gv);
      }
    );
  }

  # Type: gdouble
  method center-y is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('center-y', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('center-y', $gv);
      }
    );
  }

  # Type: gdouble
  method height is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
  method radius-x is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
  method radius-y is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_ellipse_get_type, $n, $t );
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_ellipse_model_get_type, $n, $t );
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

sub goo_canvas_ellipse_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_ellipse_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
