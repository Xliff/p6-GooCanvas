use v6.c;

use Method::Also;

use Cairo;

use Goo::Raw::Types;
use Goo::Raw::CanvasItemSimple;

use GLib::Value;
use Pango::FontDescription;

use Goo::Roles::CanvasItem;

our subset GooCanvasItemSimpleAncestry is export of Mu
  where GooCanvasItem | GooCanvasItemSimple;

class Goo::CanvasItemSimple {
  also does Goo::Roles::CanvasItem;

  has GooCanvasItemSimple $!gc;

  submethod BUILD (:$simplecanvas) {
    #self.ADD-PREFIX('Goo::');
    self.setSimpleCanvasItem($simplecanvas) if $simplecanvas.defined;
  }

  method setSimpleCanvasItem (GooCanvasItemSimpleAncestry $_) {
    #self.IS-PROTECTED;
    my $to-parent;
    $!gc = do {
      when GooCanvasItemSimple {
        $to-parent = cast(GooCanvasItem, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GooCanvasItemSimple, $_);
      }
    }
    self.setCanvasItem($to-parent);
  }

  multi method new (GooCanvasItemSimpleAncestry $simplecanvas) {
    $simplecanvas ?? self.bless(:$simplecanvas) !! GooCanvasItemSimple;
  }

  # Type: GooCairoAntialias
  method antialias is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('antialias', $gv)
        );
        cairo_antialias_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('antialias', $gv);
      }
    );
  }

  # Type: GooCairoFillRule
  method clip-fill-rule is rw  is also<clip_fill_rule> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('clip-fill-rule', $gv)
        );
        cairo_fill_rule_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('clip-fill-rule', $gv);
      }
    );
  }

  # Type: gchar
  method clip-path is rw  is also<clip_path> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn "'clip-path' does not allow reading" if $DEBUG;
        ''
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('clip-path', $gv);
      }
    );
  }

  # Type: gchar
  method fill-color is rw  is also<fill_color> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn "'fill-color' does not allow reading" if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('fill-color', $gv);
      }
    );
  }

  # Type: guint
  method fill-color-rgba is rw  is also<fill_color_rgba> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('fill-color-rgba', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('fill-color-rgba', $gv);
      }
    );
  }

  # Type: GooCairoPattern
  method fill-pattern (:$raw = False) is rw  is also<fill_pattern> {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('fill-pattern', $gv)
        );

        return Nil unless $gv.pointer;

        my $fp = cast(cairo_pattern_t, $gv.pointer);

        $raw ?? $fp !! Cairo::Pattern.new($fp);
      },
      STORE => -> $, CairoPatternObject $val is copy {
        $val = $val.pattern if $val ~~ Cairo::Pattern;
        $gv.pointer = $val;
        self.prop_set('fill-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method fill-pixbuf is rw  is also<fill_pixbuf> {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        warn "'fill-pixbuf' does not allow reading" if $DEBUG;
        0;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('fill-pixbuf', $gv);
      }
    );
  }

  # Type: GooCairoFillRule
  method fill-rule is rw  is also<fill_rule> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('fill-rule', $gv)
        );
        cairo_fill_rule_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('fill-rule', $gv);
      }
    );
  }

  # Type: gchar
  method font is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('font', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('font', $gv);
      }
    );
  }

  # Type: PangoFontDescription
  method font-desc (:$raw = False) is rw  is also<font_desc> {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('font-desc', $gv)
        );

        return Nil unless $gv.pointer;

        my $fd = cast(PangoFontDescription, $gv.pointer);

        $raw ?? $fd !! Pango::FontDescription($fd);
      },
      STORE => -> $, PangoFontDescription() $val is copy {
        $gv.pointer = $val;
        self.prop_set('font-desc', $gv);
      }
    );
  }

  # Type: GooCairoHintMetrics
  method hint-metrics is rw  is also<hint_metrics> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('hint-metrics', $gv)
        );
        cairo_hint_metrics_t( $gv.enum );
      },
      STORE => -> $, Int()  $val is copy {
        $gv.uint = $val;
        self.prop_set('hint-metrics', $gv);
      }
    );
  }

  # Type: GooCairoLineCap
  method line-cap is rw  is also<line_cap> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-cap', $gv)
        );
        cairo_line_cap_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('line-cap', $gv);
      }
    );
  }

  # Type: GooCanvasLineDash
  method line-dash is rw  is also<line_dash> {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-dash', $gv)
        );
        cast(GooCanvasLineDash, $gv.pointer);
      },
      STORE => -> $, GooCanvasLineDash $val is copy {
        $gv.pointer = $val;
        self.prop_set('line-dash', $gv);
      }
    );
  }

  # Type: GooCairoLineJoin
  method line-join is rw  is also<line_join> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-join', $gv)
        );
        cairo_line_join_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('line-join', $gv);
      }
    );
  }

  # Type: gdouble
  method line-join-miter-limit is rw  is also<line_join_miter_limit> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-join-miter-limit', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('line-join-miter-limit', $gv);
      }
    );
  }

  # Type: gdouble
  method line-width is rw  is also<line_width> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('line-width', $gv);
      }
    );
  }

  # Type: GooCairoOperator
  method operator is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('operator', $gv)
        );
        cairo_operator_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('operator', $gv);
      }
    );
  }

  # Type: gchar
  method stroke-color is rw  is also<stroke_color> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn "'stroke-color' does not allow reading" if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('stroke-color', $gv);
      }
    );
  }

  # Type: guint
  method stroke-color-rgba is rw  is also<stroke_color_rgba> {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('stroke-color-rgba', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('stroke-color-rgba', $gv);
      }
    );
  }

  # Type: GooCairoPattern
  method stroke-pattern (:$raw = False) is rw  is also<stroke_pattern> {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('stroke-pattern', $gv)
        );

        return Nil unless $gv.pointer;

        my $fp = cast(cairo_pattern_t, $gv.pointer);

        $raw ?? $fp !! Cairo::Pattern.new($fp);
      },
      STORE => -> $, GooCairoPattern $val is copy {
        $val = $val.pattern if $val ~~ Cairo::Pattern;
        $gv.pointer = $val;
        self.prop_set('stroke-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method stroke-pixbuf is rw  is also<stroke_pixbuf> {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        warn "'stroke-pixbuf' does not allow reading" if $DEBUG;
        0;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('stroke-pixbuf', $gv);
      }
    );
  }

  method changed (Int() $recompute_bounds) {
    my gboolean $r = $recompute_bounds.so.Int;

    goo_canvas_item_simple_changed($!gc, $r);
  }

  method check_in_path (
    Num() $x,
    Num() $y,
    CairoContextObject $cr is copy,
    Int() $pointer_events
  )
    is also<check-in-path>
  {
    my gdouble ($xx, $yy) = ($x, $y);
    my guint $p = $pointer_events;

    $cr .= context if $cr ~~ Cairo::Context;
    so goo_canvas_item_simple_check_in_path($!gc, $xx, $yy, $cr, $p);
  }

  method check_style is also<check-style> {
    goo_canvas_item_simple_check_style($!gc);
  }

  method get_path_bounds (
    CairoContextObject $cr,
    GooCanvasBounds() $bounds
  )
    is also<get-path-bounds>
  {
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_simple_get_path_bounds($!gc, $cr, $bounds);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_item_simple_get_type, $n, $t );
  }

  method paint_path (CairoContextObject $cr is copy) is also<paint-path> {
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_simple_paint_path($!gc, $cr);
  }

  method set_model (GooCanvasItemModel() $model) is also<set-model> {
    goo_canvas_item_simple_set_model($!gc, $model);
  }

  method user_bounds_to_device (
    CairoContextObject $cr is copy,
    GooCanvasBounds() $bounds
  )
    is also<user-bounds-to-device>
  {
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_simple_user_bounds_to_device($!gc, $cr, $bounds);
  }

  method user_bounds_to_parent (
    CairoContextObject $cr,
    GooCanvasBounds() $bounds
  )
    is also<user-bounds-to-parent>
  {
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_simple_user_bounds_to_parent($!gc, $cr, $bounds);
  }

  method unset_fill_pattern is also<unset-fill-pattern> {
    self.fill-pattern = cairo_pattern_t;
  }

  method unset_stroke_pattern is also<unset-stroke-pattern> {
    self.stroke-pattern = cairo_pattern_t;
  }

  method unset_patterns is also<unset-patterns> {
    self.stroke-pattern = self.fill-pattern = cairo_pattern_t;
  }

}
