use v6.c;

use NativeCall;

use Pango::Raw::Types;

use GTK::Compat::Types;
use GTK::Raw::Types;

use GTK::Raw::Utils;

use Goo::Raw::Types;
use Goo::Raw::Enums;

use Goo::Model::Simple;

class Goo::Model::Text is Goo::Model::Simple {

  method new (
    GooCanvasItemModel() $parent,
    Str()                $string,
    Num()                $x,
    Num()                $y,
    Num()                $width,
    Int()                $anchor,
    *@props
  ) {
    my guint $a = resolve-uint($anchor);
    my gdouble ($xx, $yy, $w) = ($x, $y, $width);
    self.bless(
      simple => goo_canvas_text_model_new(
        $parent, $string, $xx, $yy, $w, $a, Str
      ),
      props  => @props
    );
  }

  # Type: PangoAlignment
  method alignment is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('alignment', $gv)
        );
        PangoAlignment( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('alignment', $gv);
      }
    );
  }

  # Type: GooCanvasAnchorType
  method anchor is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('anchor', $gv)
        );
        GooCanvasAnchorType( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('anchor', $gv);
      }
    );
  }

  # Type: PangoEllipsizeMode
  method ellipsize is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('ellipsize', $gv)
        );
        PangoEllipsizeMode( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('ellipsize', $gv);
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

  # Type: gchar
  method text is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('text', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('text', $gv);
      }
    );
  }

  # Type: gboolean
  method use-markup is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('use-markup', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('use-markup', $gv);
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

  # Type: PangoWrapMode
  method wrap is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('wrap', $gv)
        );
        PangoWrapMode( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('wrap', $gv);
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
    unstable_get_type( self.^name, &goo_canvas_text_model_get_type, $n, $t );
  }

}

sub goo_canvas_text_model_new (
  GooCanvasItemModel $parent,
  Str                $string,
  gdouble            $x,
  gdouble            $y,
  gdouble            $width,
  uint32             $anchor,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_text_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
