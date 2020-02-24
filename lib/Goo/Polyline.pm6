use v6.c;

use Method::Also;
use NativeCall;

use Goo::Raw::Types;
use Goo::Raw::Polyline;

use Goo::CanvasItemSimple;
use Goo::Points;

use Goo::Roles::Polyline;

our subset GooPolylineAncestry is export of Mu
  where GooCanvasPolyline | GooCanvasItemSimpleAncestry;

class Goo::Polyline is Goo::CanvasItemSimple {
  also does Goo::Roles::Polyline;

  has GooCanvasPolyline $!pl;
  has $!num;

  submethod BUILD (:$line, :$num) {
    $!num = $num // 0;
    given $line {
      when GooPolylineAncestry {
        my $to-parent;
        $!pl = do {
          when GooCanvasPolyline {
            $to-parent = cast(GooCanvasItemSimple, $_);
            $_;
          }

          default {
            $to-parent = $_;
            cast(GooCanvasPolyline, $_);
          }
        }
        self.setSimpleCanvasItem($to-parent)
      }
    }
  }

  method Goo::Raw::Definitions::GooCanvasPolyline
    is also<
      Polyline
      GooPolyline
    >
  { $!pl }

  proto method new(|)
  { * }

  multi method new (
    GooCanvasItem() $line,
    Int() $num?
  ) {
    $line ?? self.bless(:$line, :$num) !! $line;
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

    my gboolean $c = $close.so.Int;
    my gint $num   = $num_points;
    my $line       = goo_canvas_polyline_new($parent, $c, $num, Str);

    return GooCanvasPoints unless $line;

    my $o = self.bless(:$line, :$num);
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
    my $line = goo_canvas_polyline_new_line(
      $parent,
      $xx1,
      $yy1,
      $xx2,
      $yy2,
      Str
    );

    $line ?? self.bless(:$line) !! GooCanvasPolyline;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_polyline_get_type, $n, $t);
  }

}
