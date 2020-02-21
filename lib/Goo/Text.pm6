use v6.c;

use Method::Also;

use Pango::Raw::Types;

use Goo::Raw::Types;
use Goo::Raw::Text;

use Goo::CanvasItemSimple;

use Goo::Roles::Text;

our subset GooCanvasTextAncestry is export of Mu
  where GooCanvasText | GooCanvasItemSimpleAncestry;

class Goo::Text is Goo::CanvasItemSimple {
  also does Goo::Roles::Text;

  has GooCanvasText $!t;

  submethod BUILD (:$text) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!t = $text) )
  }

  method Goo::Raw::Definitions::GooCanvasText
    is also<GooCanvasText>
  { $!t }

  proto method new (|) { * }

  multi method new (GooCanvasTextAncestry $text) {
    $text ?? self.bless($text) !! $text;
  }
  multi method new (
    GooCanvasItem() $parent,
    Str() $t,
    Num() $x,
    Num() $y,
    Num() $width,
    Int() $anchor
  ) {
    my gdouble ($xx, $yy, $w) = ($x, $y, $width);
    my guint $a = $anchor;
    my $text = goo_canvas_text_new($parent, $t, $xx, $yy, $w, $a, Str);

    $text ?? self.bless(:$text) !! Nil;
  }

  method get_natural_extents (
    PangoRectangle $ink_rect,
    PangoRectangle $logical_rect
  )
    is also<get-natural-extents>
  {
    goo_canvas_text_get_natural_extents($!t, $ink_rect, $logical_rect);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_text_get_type, $n, $t );
  }

}
