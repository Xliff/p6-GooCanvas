use v6.c;

use Method::Also;

use Cairo;

use Goo::Raw::Types;
use Goo::Model::Raw::Item;

use GLib::Value;

use GLib::Roles::Object;
use GLib::Roles::Signals::Generic;

role Goo::Model::Roles::Item {
  also does GLib::Roles::Object;
  also does GLib::Roles::Signals::Generic;

  has GooCanvasItemModel $!im;

  multi submethod BUILD (:$model is required) {
    #self.ADD-PREFIX('Goo::');
    self.setModelItem($model);
  }

  method setModelItem ($item) {
    self.IS-PROTECTED;
    self!setObject($!im = $item);
  }

  multi method new-goocanvasitem-obj (GooCanvasItemModel $model) {
    $model ?? self.bless(:$model) !! Nil;
  }

  method Goo::Raw::Types::GooCanvasItemModel
    is also<
      ItemModel
      CanvasItemModel
    >
  { $!im }

  method parent (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $p = goo_canvas_item_model_get_parent($!im);

        $p ??
          ( $raw ?? $p !! Goo::Model::Roles::Item.new-goocanvasitem-obj($p) )
          !!
          Nil;
      },
      STORE => sub ($, GooCanvasItemModel() $parent is copy) {
        goo_canvas_item_model_set_parent($!im, $parent);
      }
    );
  }

  method style (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $s = goo_canvas_item_model_get_style($!im);

        return Nil unless $s;

        $s = cast(GooCanvasStyle, $s);
        $raw ?? $s !! Goo::Style.new($s);
      },
      STORE => sub ($, GooCanvasStyle() $style is copy) {
        goo_canvas_item_model_set_style($!im, $style);
      }
    );
  }

  # Type: gboolean
  method can-focus is rw  is also<can_focus> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('can-focus', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('can-focus', $gv);
      }
    );
  }

  # Type: gchar
  method description is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('description', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('description', $gv);
      }
    );
  }

  # Type: GooCanvasPointerEvents
  method pointer-events is rw  is also<pointer_events> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('pointer-events', $gv)
        );
        GooCanvasPointerEvents( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('pointer-events', $gv);
      }
    );
  }

  # Type: gchar
  method title is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('title', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('title', $gv);
      }
    );
  }

  # Type: gchar
  method tooltip is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('tooltip', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('tooltip', $gv);
      }
    );
  }

  # Type: GooCairoMatrix
  method transform (:$raw = False) is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('transform', $gv)
        );

        return Nil unless $gv.pointer;

        my $m = cast(cairo_matrix_t, $gv.pointer);

        $raw ?? $m !! Cairo::Matrix.new($m);
      },
      STORE => -> $, CairoMatrixObject $val is copy {
        $val .= matrix if $val ~~ Cairo::Matrix;
        $gv.pointer = $val;
        self.prop_set('transform', $gv);
      }
    );
  }

  # Type: GooCanvasItemVisibility
  method visibility is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('visibility', $gv)
        );
        GooCanvasItemVisibilityEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('visibility', $gv);
      }
    );
  }

  # Type: gdouble
  method visibility-threshold is rw  is also<visibility_threshold> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('visibility-threshold', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('visibility-threshold', $gv);
      }
    );
  }

  # Is originally:
  # GooCanvasItemModel, gboolean, gpointer --> void
  method animation-finished is also<animation_finished> {
    self.connect-bool($!im, 'animation-finished');
  }

  # Is originally:
  # GooCanvasItemModel, gboolean, gpointer --> void
  method changed {
    self.connect-bool($!im, 'changed');
  }

  # Is originally:
  # GooCanvasItemModel, gint, gpointer --> void
  method child-added is also<child_added> {
    self.connect-int($!im, 'child-added');
  }

  # Is originally:
  # GooCanvasItemModel, gint, gint, gpointer --> void
  method child-moved is also<child_moved> {
    self.connect-intint($!im, 'child-moved');
  }

  # Is originally:
  # GooCanvasItemModel, GParamSpec, gpointer --> void
  method child-notify is also<child_notify> {
    self.connect-param($!im, 'child-notify');
  }

  # Is originally:
  # GooCanvasItemModel, gint, gpointer --> void
  method child-removed is also<child_removed> {
    self.connect-int($!im, 'child-removed');
  }

  method add_child (GooCanvasItemModel() $child, Int() $position = -1)
    is also<add-child>
  {
    my gint $p = $position;

    goo_canvas_item_model_add_child($!im, $child, $position);
  }

  method animate (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $degrees,
    Int() $absolute,
    Int() $duration,
    Int() $step_time,
    Int() $type
  ) {
    my gdouble ($xx, $yy, $s, $d) = ($x, $y, $scale, $degrees);
    my gboolean $a = $absolute.so.Int;
    my gint ($dur, $st) = ($duration, $step_time);
    my guint $t = $type;

    goo_canvas_item_model_animate($!im, $xx, $yy, $s, $d, $a, $dur, $st, $t);
  }

  method find_child (GooCanvasItemModel() $child) is also<find-child> {
    goo_canvas_item_model_find_child($!im, $child);
  }

  method get_child (Int() $child_num) is also<get-child> {
    my gint $cn = $child_num;

    goo_canvas_item_model_get_child($!im, $cn);
  }

  method get_child_property (
    GooCanvasItemModel $child,
    Str() $property_name,
    GValue $value
  )
    is also<get-child-property>
  {
    goo_canvas_item_model_get_child_property(
      $!im,
      $child,
      $property_name,
      $value
    );
  }

  method get_n_children
    is also<
      get-n-children
      n_children
      n-children
      elems
    >
  {
    goo_canvas_item_model_get_n_children($!im);
  }

  method get_simple_transform (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $rotation
  )
    is also<get-simple-transform>
  {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);

    goo_canvas_item_model_get_simple_transform($!im, $xx, $yy, $s, $r);
  }

  proto method get_transform (|)
    is also<get-transform>
  { * }

  # Cannot offer the single arg alias, as it would conflict with
  # the 'transform' property, above.
  # Replace the attribute with a proxy object that call get_transform and
  # set_transform?
  multi method get_transform (:$raw = False) {
    my $matrix = cairo_matrix_t.new;
    samewith($matrix);
  }
  multi method get_transform (
    CairoMatrixObject $transform is copy,
    :$raw = False
  ) {
    die '$transform must be a defined, Cairo::Matrix compatible object!'
      unless $transform;

    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_model_get_transform($!im, $transform);

    Cairo::Matrix.new($transform);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_item_model_get_type, $n, $t );
  }

  method lower (GooCanvasItemModel() $below) {
    goo_canvas_item_model_lower($!im, $below);
  }

  method move_child (Int() $old_position, Int() $new_position)
    is also<move-child>
  {
    my gint ($op, $np) = ($old_position, $new_position);

    goo_canvas_item_model_move_child($!im, $old_position, $new_position);
  }

  method raise (GooCanvasItemModel() $above) {
    goo_canvas_item_model_raise($!im, $above);
  }

  method remove {
    goo_canvas_item_model_remove($!im);
  }

  method remove_child (Int() $child_num) is also<remove-child> {
    my gint $cn = $child_num;

    goo_canvas_item_model_remove_child($!im, $cn);
  }

  method rotate (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);

    goo_canvas_item_model_rotate($!im, $d, $cxx, $cyy);
  }

  method scale (Num() $sx, Num() $sy) {
    my gdouble ($sxx, $syy) = ($sx, $sy);

    goo_canvas_item_model_scale($!im, $sxx, $syy);
  }

  method set_child_property (
    GooCanvasItemModel() $child,
    Str() $property_name,
    GValue() $value
  )
    is also<set-child-property>
  {
    goo_canvas_item_model_set_child_property(
      $!im,
      $child,
      $property_name,
      $value
    );
  }

  method set_simple_transform (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $rotation
  )
    is also<set-simple-transform>
  {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);

    goo_canvas_item_model_set_simple_transform($!im, $xx, $yy, $s, $r);
  }

  method set_transform (CairoMatrixObject $transform) is also<set-transform> {
    $transform .= matrix if $transform ~~ Cairo::Matrix;

    goo_canvas_item_model_set_transform($!im, $transform);
  }

  method skew_x (Num() $degrees, Num() $cx, Num() $cy) is also<skew-x> {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);

    goo_canvas_item_model_skew_x($!im, $d, $cxx, $cyy);
  }

  method skew_y (Num() $degrees, Num() $cx, Num() $cy) is also<skew-y> {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);

    goo_canvas_item_model_skew_y($!im, $d, $cxx, $cyy);
  }

  method stop_animation is also<stop-animation> {
    goo_canvas_item_model_stop_animation($!im);
  }

  method translate (Num() $tx, Num() $ty) {
    my gdouble ($txx, $tyy) = ($tx, $ty);

    goo_canvas_item_model_translate($!im, $txx, $tyy);
  }

}
