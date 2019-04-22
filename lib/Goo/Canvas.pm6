use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use Goo::Raw::Canvas;

use GTK::Roles::Scrollable;
use Goo::Roles::Signals::Canvas;

use GTK::Compat::RGBA;
use GTK::Container;

our subset GooCanvasAncestry is export
  where GooCanvas | GtkScrollable | ContainerAncestry;

class Goo::Canvas is GTK::Container {
  also does GTK::Roles::Scrollable;
  also does Goo::Roles::Signals::Canvas;

  has GooCanvas $!gc;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType(self.^name);
    $o;
  }

  submethod BUILD (:$canvas) {
    given $canvas {
      when GooCanvasAncestry {
        my $to-parent;
        $!gc = do {
          when GooCanvas {
            $to-parent = cast(GtkContainer, $_);
            $_;
          }
          when GtkScrollable {
            $!s = $_;
            $to-parent = cast(GtkContainer, $_);
            cast(GtkContainer, $_);
          }
          default {
            $to-parent = $_;
            cast(GtkContainer, $_);
          }
        }
        $!s //= cast(GtkScrollable, $canvas);
        self.setContainer($to-parent);
      }
      when Goo::Canvas {
      }
      default {
      }
    }
  }

  method Goo::Raw::Types::GooCanvas
    #is also<GooCanvas>
  { $!gc }

  method new {
    self.bless( canvas => goo_canvas_new() );
  }

  # Is originally:
  # GooCanvas, GooCanvasItem, GooCanvasItemModel, gpointer --> void
  method item-created {
    self.connect-item-created($!gc);
  }

  method root_item_model is rw {
    Proxy.new(
      FETCH => sub ($) {
        goo_canvas_get_root_item_model($!gc);
      },
      STORE => sub ($, GooCanvasItemModel() $model is copy) {
        goo_canvas_set_root_item_model($!gc, $model);
      }
    );
  }

  method scale is rw {
    Proxy.new(
      FETCH => sub ($) {
        goo_canvas_get_scale($!gc);
      },
      STORE => sub ($, Num() $scale is copy) {
        my gdouble $s = $scale;
        goo_canvas_set_scale($!gc, $s);
      }
    );
  }

  method static_root_item is rw {
    Proxy.new(
      FETCH => sub ($) {
        goo_canvas_get_static_root_item($!gc);
      },
      STORE => sub ($, $item is copy) {
        goo_canvas_set_static_root_item($!gc, $item);
      }
    );
  }

  method static_root_item_model is rw {
    Proxy.new(
      FETCH => sub ($) {
        goo_canvas_get_static_root_item_model($!gc);
      },
      STORE => sub ($, GooCanvasItemModel() $model is copy) {
        goo_canvas_set_static_root_item_model($!gc, $model);
      }
    );
  }

  # Type: GooCanvasAnchorType
  method anchor is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('anchor', $gv)
        );
        GooCanvasAnchorType( $gv.uint );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('anchor', $gv);
      }
    );
  }

  # Type: gboolean
  method automatic-bounds is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('automatic-bounds', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('automatic-bounds', $gv);
      }
    );
  }

  # Type: gchar
  method background-color is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn "background-color does not allow reading"
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('background-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method background-color-gdk-rgba is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        warn "background-color-gdk-rgba does not allow reading"
      },
      STORE => -> $, GdkRGBA() $val is copy {
        $gv.object = $val;
        self.prop_set('background-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method background-color-rgb is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        warn "background-color-rgb does not allow reading"
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('background-color-rgb', $gv);
      }
    );
  }

  # Type: gboolean
  method bounds-from-origin is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('bounds-from-origin', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('bounds-from-origin', $gv);
      }
    );
  }

  # Type: gdouble
  method bounds-padding is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('bounds-padding', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('bounds-padding', $gv);
      }
    );
  }

  # Type: gboolean
  method clear-background is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('clear-background', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('clear-background', $gv);
      }
    );
  }

  # Type: gboolean
  method integer-layout is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('integer-layout', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('integer-layout', $gv);
      }
    );
  }

  # Type: gboolean
  method redraw-when-scrolled is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('redraw-when-scrolled', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('redraw-when-scrolled', $gv);
      }
    );
  }

  # Type: gdouble
  method resolution-x is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('resolution-x', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('resolution-x', $gv);
      }
    );
  }

  # Type: gdouble
  method resolution-y is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('resolution-y', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('resolution-y', $gv);
      }
    );
  }

  # Type: gdouble
  method scale-x is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('scale-x', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('scale-x', $gv);
      }
    );
  }

  # Type: gdouble
  method scale-y is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('scale-y', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('scale-y', $gv);
      }
    );
  }

  # Type: GtkUnit
  method units is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('units', $gv)
        );
        GtkUnit( $gv.uint )
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('units', $gv);
      }
    );
  }

  # Type: gdouble
  method x1 is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('x1', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x1', $gv);
      }
    );
  }

  # Type: gdouble
  method x2 is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('x2', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x2', $gv);
      }
    );
  }

  # Type: gdouble
  method y1 is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('y1', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y1', $gv);
      }
    );
  }

  # Type: gdouble
  method y2 is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('y2', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y2', $gv);
      }
    );
  }

  method convert_bounds_to_item_space (
    GooCanvasItem() $item,
    GooCanvasBounds() $bounds
  ) {
    goo_canvas_convert_bounds_to_item_space($!gc, $item, $bounds);
  }

  method convert_from_item_space (
    GooCanvasItem() $item,
    Num() $x,
    Num() $y
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_convert_from_item_space($!gc, $item, $xx, $yy);
  }

  method convert_from_pixels (Num() $x, Num() $y) {
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_convert_from_pixels($!gc, $x, $y);
  }

  method convert_to_item_space (GooCanvasItem() $item, Num() $x, Num() $y) {
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_convert_to_item_space($!gc, $item, $x, $y);
  }

  method convert_to_pixels (Num() $x, Num() $y) {
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_convert_to_pixels($!gc, $x, $y);
  }

  method convert_units_from_pixels (Num() $x, Num() $y) {
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_convert_units_from_pixels($!gc, $x, $y);
  }

  method convert_units_to_pixels (Num() $x, Num() $y) {
    my gdouble ($xx, $yy) = ($x, $y);
    goo_canvas_convert_units_to_pixels($!gc, $x, $y);
  }

  method create_cairo_context {
    goo_canvas_create_cairo_context($!gc);
  }

  method create_item (GooCanvasItemModel() $model) {
    goo_canvas_create_item($!gc, $model);
  }

  method get_bounds (
    Num() $left,
    Num() $top,
    Num() $right,
    Num() $bottom
  ) {
    my gdouble ($l, $t, $r, $b) = ($left, $top, $right, $bottom);
    goo_canvas_get_bounds($!gc, $l, $t, $r, $b);
  }

  method get_default_line_width {
    goo_canvas_get_default_line_width($!gc);
  }

  method get_item (GooCanvasItemModel() $model) {
    goo_canvas_get_item($!gc, $model);
  }

  method get_item_at (Num() $x, Num() $y, Int() $is_pointer_event) {
    my gdouble ($xx, $yy) = ($x, $y);
    my gboolean $i = self.RESOLVE-BOOL($is_pointer_event);
    goo_canvas_get_item_at($!gc, $xx, $yy, $i);
  }

  method get_items_at (Num() $x, Num() $y, Int() $is_pointer_event) {
    my gdouble ($xx, $yy) = ($x, $y);
    my gboolean $i = self.RESOLVE-BOOL($is_pointer_event);
    goo_canvas_get_items_at($!gc, $x, $y, $is_pointer_event);
  }

  method get_items_in_area (
    GooCanvasBounds() $area,
    gboolean $inside_area,
    gboolean $allow_overlaps,
    gboolean $include_containers
  ) {
    my gboolean ($ia, $ao, $ic) = self.RESOLVE-BOOL(
      $inside_area,
      $allow_overlaps,
      $include_containers
    );
    goo_canvas_get_items_in_area($!gc, $area, $ia, $ao, $ic);
  }

  method get_root_item {
    goo_canvas_get_root_item($!gc);
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_get_type, $n, $t );
  }

  method grab_focus (GooCanvasItem() $item) {
    goo_canvas_grab_focus($!gc, $item);
  }

  method keyboard_grab (
    GooCanvasItem() $item,
    Int() $owner_events,
    Int() $time
  ) {
    my gboolean $o = self.RESOLVE-BOOL($owner_events);
    my guint $t = self.RESOLVE-UINT($time);
    goo_canvas_keyboard_grab($!gc, $item, $o, $t);
  }

  method keyboard_ungrab (GooCanvasItem() $item, Int() $time) {
    my guint $t = self.RESOLVE-UINT($time);
    goo_canvas_keyboard_ungrab($!gc, $item, $t);
  }

  method pointer_grab (
    GooCanvasItem() $item,
    Int() $event_mask,
    GdkCursor() $cursor,
    Int() $time
  ) {
    my guint ($t, $e) = self.RESOLVE-UINT($time, $event_mask);
    goo_canvas_pointer_grab($!gc, $item, $e, $cursor, $t);
  }

  method pointer_ungrab (GooCanvasItem() $item, Int() $time) {
    my guint $t = self.RESOLVE-UINT($time);
    goo_canvas_pointer_ungrab($!gc, $item, $time);
  }

  method register_widget_item (GooCanvasWidget() $witem) {
    goo_canvas_register_widget_item($!gc, $witem);
  }

  method render (
    CairoContextObject $cr is copy,
    GooCanvasBounds() $bounds,
    Num() $scale
  ) {
    my gdouble $s = $scale;
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_render($!gc, $cr, $bounds, $s);
  }

  method request_item_redraw (
    GooCanvasBounds() $bounds,
    Int() $is_static
  ) {
    my gboolean $i = self.RESOLVE-BOOL($is_static);
    goo_canvas_request_item_redraw($!gc, $bounds, $i);
  }

  method request_redraw (GooCanvasBounds() $bounds) {
    goo_canvas_request_redraw($!gc, $bounds);
  }

  method scroll_to (Num() $left, Num() $top) {
    my gdouble ($l, $t) = ($left, $top);
    goo_canvas_scroll_to($!gc, $l, $t);
  }

  method set_bounds (
    Num() $left,
    Num() $top,
    Num() $right,
    Num() $bottom
  ) {
    my gdouble ($l, $t, $r, $b) = ($left, $top, $right, $bottom);
    goo_canvas_set_bounds($!gc, $left, $top, $right, $bottom);
  }

  method unregister_item (GooCanvasItemModel() $model) {
    goo_canvas_unregister_item($!gc, $model);
  }

  method unregister_widget_item (GooCanvasWidget() $witem) {
    goo_canvas_unregister_widget_item($!gc, $witem);
  }

  method update {
    goo_canvas_update($!gc);
  }

}
