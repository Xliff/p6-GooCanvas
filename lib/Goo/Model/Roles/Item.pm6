use v6.c;

use Cairo;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use GTK::Raw::Utils;

use Goo::Model::Raw::Item;

use GTK::Roles::Properties;
use GTK::Roles::Protection;
use GTK::Roles::Signals::Generic;

role Goo::Model::Roles::Item {
  also does GTK::Roles::Properties;
  also does GTK::Roles::Protection;
  also does GTK::Roles::Signals::Generic;

  has GooCanvasItemModel $!im;

  submethod BUILD (:$model) {
    self.ADD-PREFIX('Goo::');
    self.setModelItem($model);
  }

  multi method new (GooCanvasItemModel $model) {
    self.bless(:$model);
  }

  method setModelItem ($item) {
    self.IS-PROTECTED;
    self!setObject($!im = $item);
  }

  method Goo::Raw::Types::GooCanvasItemModel
    #is also<ItemModel>
  { $!im }

  method parent is rw {
    Proxy.new(
      FETCH => sub ($) {
        Goo::Model::Roles::Item.new(
          goo_canvas_item_model_get_parent($!im)
        );
      },
      STORE => sub ($, GooCanvasItemModel() $parent is copy) {
        goo_canvas_item_model_set_parent($!im, $parent);
      }
    );
  }

  method style is rw {
    Proxy.new(
      FETCH => sub ($) {
        Goo::Style.new(
          cast( GooCanvasStyle, goo_canvas_item_model_get_style($!im) )
        );
      },
      STORE => sub ($, GooCanvasStyle() $style is copy) {
        goo_canvas_item_model_set_style($!im, $style);
      }
    );
  }

  # Type: gboolean
  method can-focus is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
  method pointer-events is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
  method transform is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('transform', $gv)
        );
        Cairo::Matrix.new( matrix => cast(cairo_matrix_t, $gv.pointer) );
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
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('visibility', $gv)
        );
        GooCanvasItemVisibility( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('visibility', $gv);
      }
    );
  }

  # Type: gdouble
  method visibility-threshold is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
  method animation-finished {
    self.connect-bool($!im, 'animation-finished');
  }

  # Is originally:
  # GooCanvasItemModel, gboolean, gpointer --> void
  method changed {
    self.connect-bool($!im, 'changed');
  }

  # Is originally:
  # GooCanvasItemModel, gint, gpointer --> void
  method child-added {
    self.connect-int($!im, 'child-added');
  }

  # Is originally:
  # GooCanvasItemModel, gint, gint, gpointer --> void
  method child-moved {
    self.connect-intint($!im, 'child-moved');
  }

  # Is originally:
  # GooCanvasItemModel, GParamSpec, gpointer --> void
  method child-notify {
    self.connect-param($!im, 'child-notify');
  }

  # Is originally:
  # GooCanvasItemModel, gint, gpointer --> void
  method child-removed {
    self.connect-int($!im, 'child-removed');
  }

  method add_child (GooCanvasItemModel() $child, Int() $position) {
    my gint $p = resolve-int($position);
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
    my gboolean $a = resolve-bool($absolute);
    my gint ($dur, $st) = resolve-int($duration, $step_time);
    my guint $t = resolve-uint($type);
    goo_canvas_item_model_animate($!im, $xx, $yy, $s, $d, $a, $dur, $st, $t);
  }

  method find_child (GooCanvasItemModel() $child) {
    goo_canvas_item_model_find_child($!im, $child);
  }

  method get_child (Int() $child_num) {
    my gint $cn = resolve-int($child_num);
    goo_canvas_item_model_get_child($!im, $cn);
  }

  method get_child_property (
    GooCanvasItemModel $child,
    Str() $property_name,
    GValue $value
  ) {
    goo_canvas_item_model_get_child_property(
      $!im,
      $child,
      $property_name,
      $value
    );
  }

  method get_n_children {
    goo_canvas_item_model_get_n_children($!im);
  }

  method get_simple_transform (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $rotation
  ) {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);
    goo_canvas_item_model_get_simple_transform($!im, $xx, $yy, $s, $r);
  }

  multi method get_transform {
    my $matrix = cairo_matrix_t.new;
    samewith($matrix);
    Cairo::Matrix.new(:$matrix);
  }
  multi method get_transform (CairoMatrixObject $transform is copy) {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_model_get_transform($!im, $transform);
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_item_model_get_type, $n, $t );
  }

  method lower (GooCanvasItemModel() $below) {
    goo_canvas_item_model_lower($!im, $below);
  }

  method move_child (Int() $old_position, Int() $new_position) {
    my gint ($op, $np) = resolve-int($old_position, $new_position);
    goo_canvas_item_model_move_child($!im, $old_position, $new_position);
  }

  method raise (GooCanvasItemModel() $above) {
    goo_canvas_item_model_raise($!im, $above);
  }

  method remove {
    goo_canvas_item_model_remove($!im);
  }

  method remove_child (Int() $child_num) {
    my gint $cn = resolve-int($child_num);
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
  ) {
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
  ) {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);
    goo_canvas_item_model_set_simple_transform($!im, $xx, $yy, $s, $r);
  }

  method set_transform (CairoMatrixObject $transform) {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_model_set_transform($!im, $transform);
  }

  method skew_x (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);
    goo_canvas_item_model_skew_x($!im, $d, $cxx, $cyy);
  }

  method skew_y (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);
    goo_canvas_item_model_skew_y($!im, $d, $cxx, $cyy);
  }

  method stop_animation {
    goo_canvas_item_model_stop_animation($!im);
  }

  method translate (Num() $tx, Num() $ty) {
    my gdouble ($txx, $tyy) = ($tx, $ty);
    goo_canvas_item_model_translate($!im, $txx, $tyy);
  }

}
