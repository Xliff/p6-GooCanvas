use v6.c;

use Pango::Raw::Types;
use GTK::Compat::Types;
use Goo::Raw::Types;

use GTK::Raw::Utils;

use Goo::CanvasItemSimple;

class Goo::Text is Goo::CanvasItemSimple {
  has GooCanvasText $!t;

  submethod BUILD (:$text) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!t = $text) )
  }

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
    self.bless( text => goo_canvas_text_new($parent, $xx, $yy, $w, $a);
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
