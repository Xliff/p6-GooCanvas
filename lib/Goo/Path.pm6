use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use Goo::CanvasItemSimple;

class Goo::Path is Goo::CanvasItemSimple {
  has GooCanvasPath $!p;

  multi method new ($path) {
    self.bless(:$path);
  }
  multi method new (GooCanvasItem() $parent, Str $path_data) {
    self.bless( path => goo_canvas_path_new($parent, $path_data, Str) );
  }

  # Type: gchar
  method data is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn "data does not allow reading";
        ''
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('data', $gv);
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
    unstable_get_type( self.^name, &goo_canvas_path_get_type, $n, $t );
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_path_model_get_type, $n, $t );
  }
}

sub goo_canvas_path_new (
  GooCanvasItem $parent,
  Str           $path_data,
  Str
)
  returns GooCanvasPath
  is native(goo)
  is export
  { * }

sub goo_canvas_path_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_path_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
