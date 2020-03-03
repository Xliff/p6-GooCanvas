use v6.c;

use NativeCall;

use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Image;

our subset GooCanvasImageAncestry is export of Mu
  where GooCanvasImage | GooCanvasItemSimpleAncestry;

class Goo::Image is Goo::CanvasItemSimple {
  also does Goo::Roles::Image;

  has GooCanvasImage $!gi;

  submethod BUILD (:$image) {
    given $image {
      when GooCanvasImageAncestry {
        my $to-parent;
        $!gi = do {
          when GooCanvasImage {
            $to-parent = cast(GooCanvasItemSimple, $_);
            $_;
          }

          default {
            $to-parent = $_;
            cast(GooCanvasImage, $_);
          }
        }
        self.setSimpleCanvasItem($to-parent);
      }

      when Goo::Image {
      }

      default {
      }
    }
  }

  multi method new (GooCanvasImage $image) {
    $image ?? self.bless(:$image) !! GooCanvasImage;
  }
  multi method new (
    GooCanvasItem() $parent,
    GdkPixbuf()     $pixbuf,
    Num()           $x,
    Num()           $y
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    $image => goo_canvas_image_new($parent, $pixbuf, $xx, $yy, Str);

    $image ?? self.bless(:$image) !! GooCanvasImage;
  }

  method get_type {
    state ($n, $t);
    
    unstable_get_type( self.^name, &goo_canvas_image_get_type, $n, $t );
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
