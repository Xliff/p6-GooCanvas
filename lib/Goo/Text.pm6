use v6.c;

use Pango::Raw::Types;
use GTK::Compat::Types;

use GTK::Raw::Utils;

use Goo::Raw::Types;
use Goo::Raw::Text;

use Goo::CanvasItemSimple;

use Goo::Roles::Text;

class Goo::Text is Goo::CanvasItemSimple {
  also does Goo::Roles::Text;

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
    my gdouble ($xx, $yy, $w) = ($x, $y, $width);
    my guint $a = resolve-uint($anchor);
    self.bless(
      text => goo_canvas_text_new($parent, $text, $xx, $yy, $w, $a, Str)
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

}
