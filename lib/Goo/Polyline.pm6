use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use GTK::Raw::Utils;

use Goo::Raw::Polyline;

use Goo::CanvasItemSimple;
use Goo::Points;

class Goo::Polyline is Goo::CanvasItemSimple {
  has GooCanvasPolyline $!pl;
  has $!num;

  method Goo::Raw::Types::GooCanvasPolyline
    # is also<Polyline>
  { $!pl }

  submethod BUILD (:$line, :$!num) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!pl = $line) )
  }

  proto method new(|) { * }

  multi method new (
    GooCanvasPolyline $line,
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
      line => goo_canvas_polyline_new($parent, $c, 0, Str),
      num  => $num_points
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
  ) {
    my gdouble ($xx1, $yy1, $xx2, $yy2) = ($x1, $y1, $x2, $y2);
    self.bless(
      line => goo_canvas_polyline_new_line(
        $parent, $xx1, $yy1, $xx2, $yy2, Str
      )
    );
  }

  # Type: gdouble
  method arrow-length is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('arrow-length', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('arrow-length', $gv);
      }
    );
  }

  # Type: gdouble
  method arrow-tip-length is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('arrow-tip-length', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('arrow-tip-length', $gv);
      }
    );
  }

  # Type: gdouble
  method arrow-width is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('arrow-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('arrow-width', $gv);
      }
    );
  }

  # Type: gboolean
  method close-path is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('close-path', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('close-path', $gv);
      }
    );
  }

  # Type: gboolean
  method end-arrow is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('end-arrow', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('end-arrow', $gv);
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

  # Type: GooCanvasPoints
  method points is rw  {
    my GTK::Compat::Value $gv .= new( Goo::Points.get_type() );
    Proxy.new(
      FETCH => -> $ {
        $gv.boxed.defined ??
          Goo::Points.new( cast(GooCanvasPoints, $gv.boxed) ) !! 0;
      },
      STORE => -> $, $val is copy {
        die "Invalid value of type '{ $val.^name }' passed."
          unless $val ~~ (Array, GooCanvasPoints, Goo::Points).any;
        given $val {
          when Array {
            $val = Goo::Points.new($val).Points;
          }
          when Goo::Points {
            $val = Goo::Raw::Types::GooCanvasPoints($val);
          }
        }
        $gv.boxed = $val;
        self.prop_set('points', $gv);
      }
    );
  }

  # Type: gboolean
  method start-arrow is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('start-arrow', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('start-arrow', $gv);
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
    unstable_get_type( self.^name, &goo_canvas_polyline_get_type, $n, $t);
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_polyline_model_get_type, $n, $t );
  }
}
