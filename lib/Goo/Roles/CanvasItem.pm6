use v6.c;

use Cairo;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;

use GTK::Raw::Utils;

use Goo::Raw::CanvasItem;

use GTK::Roles::Properties;
use Goo::Roles::Signals::CanvasItem;

role Goo::Roles::CanvasItem {
  also does GTK::Roles::Properties;
  also does Goo::Roles::Signals::CanvasItem;

  has GooCanvasItem $!ci;

  # Is originally:
  # GooCanvasItem, gboolean, gpointer --> void
  method animation-finished {
    self.connect-uint($!ci, 'animation-finished');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method button-press-event {
    self.connect-canvas-event($!ci, 'button-press-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method button-release-event {
    self.connect-canvas-event($!ci, 'button-release-event');
  }

  # Is originally:
  # GooCanvasItem, GParamSpec, gpointer --> void
  method child-notify {
    self.connect-gparam($!ci, 'child-notify');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method enter-notify-event {
    self.connect-canvas-event($!ci, 'enter-notify-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method focus-in-event {
    self.connect-canvas-event($!ci, 'focus-in-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method focus-out-event {
    self.connect-canvas-event($!ci, 'focus-out-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method grab-broken-event {
    self.connect-canvas-event($!ci, 'grab-broken-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method key-press-event {
    self.connect-canvas-event($!ci, 'key-press-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method key-release-event {
    self.connect-canvas-event($!ci, 'key-release-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method leave-notify-event {
    self.connect-canvas-event($!ci, 'leave-notify-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method motion-notify-event {
    self.connect-canvas-event($!ci, 'motion-notify-event');
  }

  # Is originally:
  # GooCanvasItem, gdouble, gdouble, gboolean, GtkTooltip, gpointer --> gboolean
  method query-tooltip {
    self.connect-query-tooltip($!ci);
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method scroll-event {
    self.connect-canvas-event($!ci, 'scroll-event');
  }

  method canvas is rw {
    Proxy.new(
      FETCH => sub ($) {
        Goo::Canvas.new( goo_canvas_item_get_canvas($!ci) );
      },
      STORE => sub ($, GooCanvas() $canvas is copy) {
        goo_canvas_item_set_canvas($!ci, $canvas);
      }
    );
  }

  method is_static is rw {
    Proxy.new(
      FETCH => sub ($) {
        so goo_canvas_item_get_is_static($!ci);
      },
      STORE => sub ($, Int() $is_static is copy) {
        my gboolean $i = resolve-bool($is_static);
        goo_canvas_item_set_is_static($!ci, $i);
      }
    );
  }

  method style is rw {
    Proxy.new(
      FETCH => sub ($) {
        goo_canvas_item_get_style($!ci);
      },
      STORE => sub ($, $style is copy) {
        goo_canvas_item_set_style($!ci, $style);
      }
    );
  }

  method add_child (GooCanvasItem() $child, Int() $position) {
    my gint $p = resolve-int($position);
    goo_canvas_item_add_child($!ci, $child, $p);
  }

  method allocate_area (
    CairoContextObject $cr is copy,
    GooCanvasBounds() $requested_area,
    GooCanvasBounds() $allocated_area,
    Num() $x_offset,
    Num() $y_offset
  ) {
    my gdouble ($xo, $yo) = ($x_offset, $y_offset);
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_allocate_area(
      $!ci,
      $cr,
      $requested_area,
      $allocated_area,
      $xo,
      $yo
    );
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
    my guint $t = resolve-uint($type);
    my gboolean $a = resolve-bool($absolute);
    my gint ($dur, $st) = resolve-int($duration, $step_time);
    goo_canvas_item_animate($!ci, $xx, $yy, $s, $d, $a, $dur, $st, $t);
  }

  method ensure_updated {
    goo_canvas_item_ensure_updated($!ci);
  }

  method find_child (GooCanvasItem() $child) {
    goo_canvas_item_find_child($!ci, $child);
  }

  method get_bounds (GooCanvasBounds() $bounds) {
    goo_canvas_item_get_bounds($!ci, $bounds);
  }

  method get_child (Int() $child_num) {
    my gint $c = resolve-int($child_num);
    goo_canvas_item_get_child($!ci, $c);
  }

  method get_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    GValue() $value
  ) {
    goo_canvas_item_get_child_property($!ci, $child, $property_name, $value);
  }

  method get_items_at (
    Num() $x,
    Num() $y,
    CairoContextObject $cr is copy,
    Int() $is_pointer_event,
    Int() $parent_is_visible,
    GList() $found_items
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    my gboolean ($i, $p) = resolve-bool($is_pointer_event, $parent_is_visible);
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_items_at($!ci, $x, $y, $cr, $i, $p, $found_items);
  }

  method get_model {
    goo_canvas_item_get_model($!ci);
  }

  method get_n_children {
    goo_canvas_item_get_n_children($!ci);
  }

  method get_parent {
    goo_canvas_item_get_parent($!ci);
  }

  method get_requested_area (
    CairoContextObject $cr is copy,
    GooCanvasBounds() $requested_area
  ) {
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_requested_area($!ci, $cr, $requested_area);
  }

  method get_requested_area_for_width (
    CairoContextObject $cr is copy,
    Num() $width,
    GooCanvasBounds() $requested_area
  ) {
    my gdouble $w = $width;
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_requested_area_for_width(
      $!ci,
      $cr,
      $w,
      $requested_area
    );
  }

  method get_requested_height (
    CairoContextObject $cr is copy,
    Num() $width
  ) {
    my gdouble $w = $width;
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_requested_height($!ci, $cr, $w);
  }

  method get_simple_transform (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $rotation
  ) {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);
    goo_canvas_item_get_simple_transform($!ci, $xx, $yy, $s, $r);
  }

  method get_transform (CairoMatrixObject $transform is copy) {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_get_transform($!ci, $transform);
  }

  method get_transform_for_child (
    GooCanvasItem() $child,
    CairoMatrixObject $transform
  ) {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_get_transform_for_child($!ci, $child, $transform);
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_item_get_type, $n, $t );
  }

  method goo_canvas_bounds_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_bounds_get_type, $n, $t );
  }

  method is_visible {
    so goo_canvas_item_is_visible($!ci);
  }

  method lower (GooCanvasItem() $below) {
    goo_canvas_item_lower($!ci, $below);
  }

  method move_child (Int() $old_position, Int() $new_position) {
    my gint ($op, $np) = resolve-int($old_position, $new_position);
    goo_canvas_item_move_child($!ci, $op, $np);
  }

  method paint (
    CairoContextObject $cr is copy,
    GooCanvasBounds() $bounds,
    Num() $scale
  ) {
    my gdouble $s = $scale;
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_paint($!ci, $cr, $bounds, $s);
  }

  method raise (GooCanvasItem() $above) {
    goo_canvas_item_raise($!ci, $above);
  }

  method remove {
    goo_canvas_item_remove($!ci);
  }

  method remove_child (Int() $child_num) {
    my gint $c = resolve-int($child_num);
    goo_canvas_item_remove_child($!ci, $c);
  }

  method request_update {
    goo_canvas_item_request_update($!ci);
  }

  method rotate (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);
    goo_canvas_item_rotate($!ci, $d, $cxx, $cyy);
  }

  method scale (Num() $sx, Num() $sy) {
    my gdouble ($sxx, $syy) = ($sx, $sy);
    goo_canvas_item_scale($!ci, $sxx, $syy);
  }

  method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    GValue() $value
  ) {
    goo_canvas_item_set_child_property($!ci, $child, $property_name, $value);
  }

  method set_simple_transform (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $rotation
  ) {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);
    goo_canvas_item_set_simple_transform($!ci, $xx, $yy, $s, $r);
  }

  method set_transform (CairoMatrixObject $transform) {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_set_transform($!ci, $transform);
  }

  method skew_x (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);
    goo_canvas_item_skew_x($!ci, $degrees, $cx, $cy);
  }

  method skew_y (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);
    goo_canvas_item_skew_y($!ci, $degrees, $cx, $cy);
  }

  method stop_animation {
    goo_canvas_item_stop_animation($!ci);
  }

  method translate (Num() $tx, Num() $ty) {
    my gdouble ($txx, $tyy);
    goo_canvas_item_translate($!ci, $txx, $tyy);
  }

}
