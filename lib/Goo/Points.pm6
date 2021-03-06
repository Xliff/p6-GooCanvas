use v6.c;

use Method::Also;

use Goo::Raw::Types;
use Goo::Raw::Points;

class Goo::Points {
  also does Positional;

  has GooCanvasPoints $!points;
  has $.elems;

  submethod BUILD (:$points, :$elems) {
    $!points = $points;
    $!elems  = $elems // 0;
  }

  method Goo::Raw::Structs::GooCanvasPoints
    is also<
      Points
      GooCanvasPoints
    >
  { $!points }

  multi method new (
    GooCanvasPoints $points,
    $elems? is copy
  ) {
    return GooCanvasPoints unless $points;

    die '$elems must be an Int compatible value!'
      unless $elems.defined.not || $elems.^lookup('Int');
    $elems //= 0;
    self.bless( :$points, :$elems );
  }
  multi method new (@points) {
    # Remember: 2 entries per point!
    my $o = samewith(+@points / 2);
    $o.set_points(@points);
    $o;
  }
  multi method new (Int() $num_points) {
    my gint $elems = $num_points // 0;
    my $points = goo_canvas_points_new($elems);

    $points ?? self.bless( :$points, :$elems ) !! GooCanvasPoints;
  }

  method set_points ($points is copy) is also<set-points> {
    die '$points is a { $points.^name }, not an Array' unless $points ~~ Array;
    die '$points must only contain Num compatible objects'
      unless $points.grep({ .^lookup('Num') }) == $points.elems;
    die '$points must be even' unless $points.elems % 2 == 0;

    if $points.elems > $.elems * 2 {
      warn 'Too many points! Clipping...';
      $points = $points[ ^($.elems * 2) ];
    }
    my $idx = 0;
    for $points.rotor(2) -> ($x, $y) {
      self.set_point($idx++, $x, $y);
    }
  }

  method set_point (
    Int() $idx,
    Num() $x,
    Num() $y
  )
    is also<set-point>
  {
    my gint $i = $idx;
    my gdouble ($xx, $yy) = ($x, $y);

    goo_canvas_points_set_point($!points, $i, $xx, $yy);
  }

  method get_points
    is also<
      get-points
      points
    >
  {
    my @a;
    @a.append: |self.get_point($_) for ^$.elems;
    @a;
  }

  proto method get_point(|)
    is also<get-point>
  { * }

  multi method get_point (Int() $idx) {
    my Num ($x, $y) = 0e0 xx 2;

    samewith($idx, $x, $y);
  }
  multi method get_point(
    Int() $idx,
    Num() $x is rw,
    Num() $y is rw
  ) {
    my gint $i = $idx;
    my gdouble ($xx, $yy) = ($x, $y);

    goo_canvas_points_get_point($!points, $i, $xx, $yy);
    ($x, $y) = ($xx, $yy);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_points_get_type, $n, $t );
  }

  # Positional
  method AT-POS (\p) is rw {
    die "Invalid position { p }! Size is only { $.elems }!"
      if p > $.elems;

    Proxy.new:
      FETCH => sub ($)  { self.get-point(p)        },
      STORE => -> $, @v {
        die 'Value is not a point.' unless @v.elems == 2;
        @v.map({
          die 'All elements of value must be Num-compatible'
            unless (my $m = .^lookup('Num') );
          $m($_)
        });
        self.set-point(p, @v[0], @v[1])
      };
  }

  method EXISTS-POS (\p) { p <= $!elems      }

}
