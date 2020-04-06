use v6.c;

use Method::Also;

use Pango::Raw::Types;

use Goo::Raw::Types;
use Goo::Raw::Grid;

use Goo::CanvasItemSimple;

use Goo::Roles::Grid;

our subset GooCanvasGridAncestry is export of Mu
  where GooCanvasGrid | GooCanvasItemSimpleAncestry;

class Goo::Grid is Goo::CanvasItemSimple {
  also does Goo::Roles::Grid;

  has GooCanvasGrid $!g;

  submethod BUILD (:$grid) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!g = $grid) )
  }

  method Goo::Raw::Definitions::GooCanvasGrid
    is also<GooCanvasGrid>
  { $!g }

  proto method new (|) { * }

  multi method new (GooCanvasGridAncestry $grid) {
    $grid ?? self.bless($grid) !! GooCanvasGrid;
  }
  multi method new (
    GooCanvasItem() $parent,
    Num() $x,
    Num() $y,
    Num() $width,
    Num() $height,
    Num() $x_step,
    Num() $y_step,
    Num() $x_offset,
    Num() $y_offset
  ) {
    my gdouble ($xx, $yy, $w, $h, $xs, $ys, $xo, $yo) =
      ($x, $y, $width, $height, $x_step, $y_step, $x_offset, $y_offset);

    my $grid = goo_canvas_grid_new(
      $parent,
      $xx,
      $yy,
      $w,
      $h,
      $xs,
      $ys,
      $xo,
      $yo,
      Str
    );

    $grid ?? self.bless(:$grid) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_grid_get_type, $n, $t );
  }

}
