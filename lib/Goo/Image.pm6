use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;
use Goo::Raw::Boxed;

use Goo::CanvasItemSimple;

class Goo::Image is Goo::CanvasItemSimple {
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

  # Type: gdouble
  method alpha is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('alpha', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('alpha', $gv);
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

  # Type: GooCairoPattern
  method pattern is rw  {
    my GTK::Compat::Value $gv .= new(
      #Goo::Raw::Boxed.pattern_get_type()
      G_TYPE_POINTER
    );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('pattern', $gv)
        );
        Cairo::Pattern::Surface.new(
          cast(cairo_pattern_t, $gv.pointer)
        )
      },
      STORE => -> $, $val is copy {
        $gv.pointer = $val;
        self.prop_set('pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method pixbuf is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        warn 'pixbuf does not allow reading';
        '';
      },
      STORE => -> $, GObject() $val is copy {
        $gv.object = $val;
        self.prop_set('pixbuf', $gv);
      }
    );
  }

  # Type: gboolean
  method scale-to-fit is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('scale-to-fit', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('scale-to-fit', $gv);
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
    unstable_get_type( self.^name, &goo_canvas_image_get_type, $n, $t );
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_image_model_get_type, $n, $t );
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

sub goo_canvas_image_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
