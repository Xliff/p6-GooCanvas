use v6.c;

use NativeCall;

use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Text;

class Goo::Model::Text is Goo::Model::Simple {
  also does Goo::Roles::Text;

  method new (
    GooCanvasItemModel() $parent,
    Str()                $string,
    Num()                $x,
    Num()                $y,
    Num()                $width,
    Int()                $anchor,
    *@props
  ) {
    my guint $a = $anchor;
    my gdouble ($xx, $yy, $w) = ($x, $y, $width);
    my $simple = goo_canvas_text_model_new(
      $parent,
      $string,
      $xx,
      $yy,
      $w,
      $a,
      Str
    );

    $simple ?? self.bless( :$simple, :@props ) !! GooCanvasItemModel;
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
