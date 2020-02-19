use v6.c;

use Method::Also;
use NativeCall;


use Goo::Raw::Types;

use GTK::Raw::Utils;

use Goo::Raw::Polyline;

use Goo::CanvasItemSimple;
use Goo::Points;

use Goo::Roles::Polyline;

class Goo::Polyline is Goo::CanvasItemSimple {
  also does Goo::Roles::Polyline;

  has GooCanvasPolyline $!pl;
  has $!num;

  method Goo::Raw::Types::GooCanvasPolyline
    is also<Polyline>
  { $!pl }

  submethod BUILD (:$line, :$!num) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!pl = $line) )
  }

  proto method new(|) { * }

  multi method new (
    GooCanvasItem() $line,
    Int() $num?
  ) {
    self.bless(:$line, :$num);
  }
  multi method new (
    GooCanvasItem() $parent,
    Int() $close,
    Int() $num_points,
    *@points
  ) {
    die '@points must contain numeric values'
      unless @points.map( *.Num ).all ~~ Num;
    die '@points must contain an even number of elements!'
      unless @points.elems == 0 || @points.elems % 2 == 0;
    my ($c, $n) = ( resolve-bool($close), resolve-int($num_points) );

    my $o = self.bless(
      line  => goo_canvas_polyline_new($parent, $c, $n, Str),
      num   => $num_points
    );
    $o.points = @points if +@points;
    $o;
  }

  method new_line (
    GooCanvasItem() $parent,
    Num() $x1,
    Num() $y1,
    Num() $x2,
    Num() $y2
  )
    is also<new-line>
  {
    my gdouble ($xx1, $yy1, $xx2, $yy2) = ($x1, $y1, $x2, $y2);
    self.bless(
      line => goo_canvas_polyline_new_line(
        $parent, $xx1, $yy1, $xx2, $yy2, Str
      )
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_polyline_get_type, $n, $t);
  }


}
