use v6.c;

use GTK::Compat::Types;
use Goo::Raw::Types;

use GTK::Raw::Utils;

use Goo::Raw::Points;

class Goo::Points {
  has gpointer $!points;
  has $.elems;

  submethod BUILD (:$!points, :$!elems) { }

  method Goo::Raw::Types::GooCanvasPoints
    #is also<Points>
  { $!points }

  method new (Int() $num_points) {
    my gint $np = resolve-int($num_points);
    self.bless(
      points => goo_canvas_points_new($np),
      elems  => $num_points
    );
  }

  method set_points ($points is copy) {
    die '$points is a { $points.^name }, not an Array' unless $points ~~ Array;
    die '$points must only contain Num compatible objects'
      unless $points.grep({ $_.^can('Num').elems }) == $points.elems;
    die '$points must be even' unless $points.elems % 2 == 0;

    if $points.elems > $.elems * 2 {
      warn 'Too many points! Clipping...';
      $points = $points[ ^($.elems * 2) ];
    }
    my $idx = 0;
    self.set_point($idx++, |@($_) ) for $points.rotor(2);
  }
  
  method set_point (
    Int() $idx,
    Num() $x,
    Num() $y
  ) {
    my gint $i = resolve-int($idx);
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_points_set_point($!points, $i, $xx, $yy);
  }

  method get_points {
    my @a;
    @a.append: |self.get_point($_) for ^$.elems;
    @a;
  }

  multi method get_point (Int() $idx) {
    my Num ($x, $y) = 0 xx 2;
    samewith($idx, $x, $y);
  }
  multi method get_point(
    Int() $idx,
    Num() $x is rw,
    Num() $y is rw
  ) {
    my gint $i = resolve-int($idx);
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_points_get_point($!points, $i, $xx, $yy);
    ($x, $y) = ($xx, $yy);
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_points_get_type, $n, $t );
  }

}
