use v6.c;

use Pango::Raw::Types;
use GTK::Compat::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use GTK::Raw::Utils;

use Goo::Raw::Text;

use Goo::CanvasItemSimple;

class Goo::Text is Goo::CanvasItemSimple {
  has GooCanvasText $!t;

  submethod BUILD (:$text) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!t = $text) )
  }

  method Goo::Raw::Types::GooCanvasText
    #is also<Text>
  { $!t }

  proto method new (|) { * }

  multi method new (GooCanvasText $text) {
    self.bless($text);
  }
  multi method new (
    GooCanvasItem() $parent,
    Str() $text,
    Num() $x,
    Num() $y,
    Num() $width,
    Int() $anchor
  ) {
    my gdouble ($xx, $yy, $w) = ($x, $y, $w);
    my guint $a = resolve-uint($anchor);
    self.bless(
      text => goo_canvas_text_new($parent, $text, $xx, $yy, $w, $a, Str)
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
        PangoAlignment( $gv.uint );
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
        GooCanvasAnchorType( $gv.uint );
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
        PangoEllipsizeMode( $gv.uint );
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
        PangoWrapMode( $gv.uint );
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

  method get_natural_extents (
    PangoRectangle $ink_rect,
    PangoRectangle $logical_rect
  ) {
    goo_canvas_text_get_natural_extents($!t, $ink_rect, $logical_rect);
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_text_get_type, $n, $t );
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_text_model_get_type, $n, $t );
  }

}
