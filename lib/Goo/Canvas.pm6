use v6.c;

use Method::Also;

use Goo::Raw::Types;
use Goo::Raw::Canvas;

use GLib::Value;
use GLib::GList;
use GDK::RGBA;
use GTK::Container;
use Goo::CanvasItem;
use Goo::CanvasItemSimple;
use Goo::Model::Item;

use GLib::Roles::ListData;
use GTK::Roles::Scrollable;
use Goo::Roles::Signals::Canvas;

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
    #self.ADD-PREFIX('Goo::');
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

  method Goo::Raw::Definitions::GooCanvas
    is also<
      Canvas
      GooCanvas
    >
  { $!gc }

  multi method new (GooCanvasAncestry $canvas, :$ref = True) {
    return GooCanvas unless $canvas;

    my $o = self.bless(:$canvas);
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $canvas = goo_canvas_new();

    $canvas ?? self.bless(:$canvas) !! GooCanvas;
  }

  # Is originally:
  # GooCanvas, GooCanvasItem, GooCanvasItemModel, gpointer --> void
  method item-created is also<item_created> {
    self.connect-item-created($!gc);
  }

  method root_item_model (:$raw = False) is rw is also<root-item-model> {
    Proxy.new(
      FETCH => sub ($) {
        my $mi = goo_canvas_get_root_item_model($!gc);

        $mi ??
          ( $raw ?? $mi !! Goo::Model::Item.new($mi) )
          !!
          GooCanvasItemModel;
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

  # This will attempt to reuse the last set object for as long as it stays
  # the same.
  method static_root_item (:$raw = False) is rw is also<static-root-item> {
    state $ri;
    Proxy.new(
      FETCH => sub ($) {
        $ri = goo_canvas_get_static_root_item($!gc);

        $ri ??
          ( $raw ?? $ri !! Goo::CanvasItem.new($ri) )
          !!
          GooCanvasItem;
      },
      STORE => sub ($, GooCanvasItem() $item is copy) {
        $ri = $item ~~ GooCanvas ?? $item !! Goo::Canvas.new( $item );
        goo_canvas_set_static_root_item($!gc, $item);
      }
    );
  }

  method static_root_item_model is rw is also<static-root-item-model> {
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
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('anchor', $gv)
        );
        GooCanvasAnchorTypeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('anchor', $gv);
      }
    );
  }

  # Type: gboolean
  method automatic-bounds is rw  is also<automatic_bounds> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method background-color is rw  is also<background_color> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'background-color does not allow reading'
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('background-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method background-color-gdk-rgba is rw  is also<background_color_gdk_rgba> {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        warn 'background-color-gdk-rgba does not allow reading'
      },
      STORE => -> $, GdkRGBA() $val is copy {
        $gv.object = $val;
        self.prop_set('background-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method background-color-rgb is rw  is also<background_color_rgb> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        warn 'background-color-rgb does not allow reading'
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('background-color-rgb', $gv);
      }
    );
  }

  # Type: gboolean
  method bounds-from-origin is rw  is also<bounds_from_origin> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method bounds-padding is rw  is also<bounds_padding> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method clear-background is rw  is also<clear_background> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method integer-layout is rw  is also<integer_layout> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method redraw-when-scrolled is rw  is also<redraw_when_scrolled> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method resolution-x is rw  is also<resolution_x> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method resolution-y is rw  is also<resolution_y> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method scale-x is rw  is also<scale_x> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method scale-y is rw  is also<scale_y> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('units', $gv)
        );
        GtkUnitEnum( $gv.uint )
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('units', $gv);
      }
    );
  }

  # Type: gdouble
  method x1 is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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

  method root-item (:$raw = False) is also<root_item> {
    Proxy.new:
      FETCH => sub ($)                     { self.get_root_item(:$raw) },
      STORE => -> $, GooCanvasItem() \i { self.set_root_item(i)     };
  }

  method convert_bounds_to_item_space (
    GooCanvasItem() $item,
    GooCanvasBounds() $bounds
  )
    is also<convert-bounds-to-item-space>
  {
    goo_canvas_convert_bounds_to_item_space($!gc, $item, $bounds);
  }

  proto method convert_from_item_space (|)
    is also<convert-from-item-space>
  { * }

  multi method convert_from_item_space (GooCanvasItem() $item) {
    samewith($, $);
  }
  multi method convert_from_item_space (
    GooCanvasItem() $item,
    $x is rw,
    $y is rw
  ) {
    my gdouble ($xx, $yy) = 0e0 xx 2;

    goo_canvas_convert_from_item_space($!gc, $item, $xx, $yy);
    ($x, $y) = ($xx, $yy);
  }

  proto method convert_from_pixels (|)
    is also<convert-from-pixels>
  { * }

  multi method convert_from_pixels {
    samewith($, $);
  }
  multi method convert_from_pixels ($x is rw, $y is rw) {
    my gdouble ($xx, $yy) = 0e0 xx 2;

    goo_canvas_convert_from_pixels($!gc, $xx, $yy);
    ($x, $y) = ($xx, $yy);
  }

  method convert_to_item_space (
    GooCanvasItem() $item,
    Num() $x is rw,
    Num() $y is rw
  )
    is also<convert-to-item-space>
  {
    my gdouble ($xx, $yy) = ($x, $y);

    goo_canvas_convert_to_item_space($!gc, $item, $xx, $yy);
  }

  method convert_to_pixels (
    Num() $x is rw,
    Num() $y is rw
  )
    is also<convert-to-pixels>
  {
    my gdouble ($xx, $yy) = ($x, $y);

    goo_canvas_convert_to_pixels($!gc, $xx, $yy);
  }

  method convert_units_from_pixels (
    Num() $x is rw,
    Num() $y is rw
  )
    is also<convert-units-from-pixels>
  {
    my gdouble ($xx, $yy) = ($x, $y);

    goo_canvas_convert_units_from_pixels($!gc, $x, $y);
  }

  method convert_units_to_pixels (
    Num() $x is rw,
    Num() $y is rw
  )
    is also<convert-units-to-pixels>
  {
    my gdouble ($xx, $yy) = ($x, $y);

    goo_canvas_convert_units_to_pixels($!gc, $x, $y);
  }

  method create_cairo_context is also<create-cairo-context> {
    goo_canvas_create_cairo_context($!gc);
  }

  method create_item (GooCanvasItemModel() $model) is also<create-item> {
    goo_canvas_create_item($!gc, $model);
  }

  proto method get_bounds (|)
    is also<get-bounds>
  { * }

  multi method get_bounds {
    samewith($, $, $, $);
  }
  multi method get_bounds (
    $left   is rw,
    $top    is rw,
    $right  is rw,
    $bottom is rw
  ) {
    my gdouble ($l, $t, $r, $b) = 0e0 xx 4;

    goo_canvas_get_bounds($!gc, $l, $t, $r, $b);
    ($left, $top, $right, $bottom) = ($l, $t, $r, $b);
  }

  method get_default_line_width is also<get-default-line-width> {
    goo_canvas_get_default_line_width($!gc);
  }

  method get_item (
    GooCanvasItemModel() $model,
    Num() $x,
    Num() $y,
    Int() $is_pointer_event,
    :$raw = False
  )
    is also<get-item>
  {
    my gdouble ($xx, $yy) = ($x, $y);
    my gboolean $ipe = $is_pointer_event.so.Int;
    my $i = goo_canvas_get_item_at($!gc, $xx, $yy, $ipe);

    $i ??
      ( $raw ?? $i !! Goo::CanvasItem.new($i) )
      !!
      GooCanvasItem;
  }

  method get_item_at (
    Num() $x,
    Num() $y,
    Int() $is_pointer_event,
    :$raw = False
  )
    is also<get-item-at>
  {
    my gdouble ($xx, $yy) = ($x, $y).map( *.so.Int );
    my gboolean $ipe = $is_pointer_event;
    my $i = goo_canvas_get_item_at($!gc, $xx, $yy, $ipe);

    $i ??
      ( $raw ?? $i !! Goo::CanvasItem.new($i) )
      !!
      GooCanvasItem;
  }

  method get_items_at (
    Num() $x,
    Num() $y,
    Int() $is_pointer_event = False,
    :$glist = False,
    :$raw = False
  )
    is also<get-items-at>
  {
    my gdouble ($xx, $yy) = ($x, $y);
    my gboolean $i = $is_pointer_event.so.Int;
    my $l = goo_canvas_get_items_at($!gc, $xx, $yy, $is_pointer_event);

    return Nil unless $l;
    return $l if $glist;

    $l = GLib::GList.new($l) but GLib::Roles::ListData[GooCanvasItem];
    $raw ?? $l.Array !! $l.Array.map({ Goo::CanvasItem.new($_) })
  }

  method get_items_in_area (
    GooCanvasBounds() $area,
    Int() $inside_area,
    Int() $allow_overlaps,
    Int() $include_containers,
    :$glist = False,
    :$raw = False
  )
    is also<get-items-in-area>
  {
    my gboolean ($ia, $ao, $ic) = (
      $inside_area,
      $allow_overlaps,
      $include_containers
    ).map( *.so.Int );

    my $l = goo_canvas_get_items_in_area($!gc, $area, $ia, $ao, $ic);

    return Nil unless $l;
    return $l if $glist;

    $l = GLib::GList.new($l) but GLib::Roles::ListData[GooCanvasItem];
    $raw ?? $l.Array !! $l.Array.map({ Goo::CanvasItem.new($_) })
  }

  method get_root_item (:$raw = False) is also<get-root-item> {
    my $c = goo_canvas_get_root_item($!gc);

    $c ??
      ( $raw ?? $c !! Goo::CanvasItem.new($c) )
      !!
      GooCanvasItem;
  }

  method set_root_item (GooCanvasItem() $item) {
    goo_canvas_set_root_item($!gc, $item);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_get_type, $n, $t );
  }

  method grab_focus (GooCanvasItem() $item) is also<grab-focus> {
    goo_canvas_grab_focus($!gc, $item);
  }

  method keyboard_grab (
    GooCanvasItem() $item,
    Int() $owner_events,
    Int() $time
  )
    is also<keyboard-grab>
  {
    my gboolean $o = $owner_events.so.Int;
    my guint $t = $time;

    goo_canvas_keyboard_grab($!gc, $item, $o, $t);
  }

  method keyboard_ungrab (GooCanvasItem() $item, Int() $time)
    is also<keyboard-ungrab>
  {
    my guint $t = $time;

    goo_canvas_keyboard_ungrab($!gc, $item, $t);
  }

  method pointer_grab (
    GooCanvasItem() $item,
    Int() $event_mask,
    GdkCursor() $cursor,
    Int() $time
  )
    is also<pointer-grab>
  {
    my guint ($t, $e) = ($time, $event_mask);

    goo_canvas_pointer_grab($!gc, $item, $e, $cursor, $t);
  }

  method pointer_ungrab (GooCanvasItem() $item, Int() $time)
    is also<pointer-ungrab>
  {
    my guint $t = $time;

    goo_canvas_pointer_ungrab($!gc, $item, $time);
  }

  method register_widget_item (GooCanvasWidget() $witem)
    is also<register-widget-item>
  {
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
  )
    is also<request-item-redraw>
  {
    my gboolean $i = $is_static.so.Int;

    goo_canvas_request_item_redraw($!gc, $bounds, $i);
  }

  method request_redraw (GooCanvasBounds() $bounds) is also<request-redraw> {
    goo_canvas_request_redraw($!gc, $bounds);
  }

  method scroll_to (Num() $left, Num() $top) is also<scroll-to> {
    my gdouble ($l, $t) = ($left, $top);

    goo_canvas_scroll_to($!gc, $l, $t);
  }

  method set_bounds (
    Num() $left  ,
    Num() $top   ,
    Num() $right ,
    Num() $bottom
  )
    is also<set-bounds>
  {
    my gdouble ($l, $t, $r, $b) = ($left, $top, $right, $bottom);

    goo_canvas_set_bounds($!gc, $left, $top, $right, $bottom);
  }

  method unregister_item (GooCanvasItemModel() $model)
    is also<unregister-item>
  {
    goo_canvas_unregister_item($!gc, $model);
  }

  method unregister_widget_item (GooCanvasWidget() $witem)
    is also<unregister-widget-item>
  {
    goo_canvas_unregister_widget_item($!gc, $witem);
  }

  method update {
    goo_canvas_update($!gc);
  }

}
