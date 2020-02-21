use v6.c;

use Cairo;

use Pango::Raw::Types;

use GDK::RGBA;
use Goo::Raw::Types;

use GLib::Value;
use Pango::FontDescription;

use Goo::Model::Roles::Item;

class Goo::Model::Simple {
  also does Goo::Model::Roles::Item;

  submethod BUILD (:$simple, :@props) {
    #self.ADD-PREFIX('Goo::');
    self.setModelItem(
      cast( GooCanvasItemModel, $simple )
    );
    for @props.rotor(2) -> ($m, $v) {
      self."$m"() = $v
    }
  }

  multi method new (GooCanvasItemModel $simple) {
    $simple ?? self.bless(:$simple) !! Nil;
  }

  # Type: GooCairoAntialias
  method antialias is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('antialias', $gv)
        );
        Cairo::cairo_antialias_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('antialias', $gv);
      }
    );
  }

  # Type: GooCairoFillRule
  method clip-fill-rule is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('clip-fill-rule', $gv)
        );
        Cairo::FillRule( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('clip-fill-rule', $gv);
      }
    );
  }

  # Type: gchar
  method clip-path is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn 'clip-path does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('clip-path', $gv);
      }
    );
  }

  # Type: gchar
  method fill-color is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn 'fill-color does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('fill-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method fill-color-gdk-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('fill-color-gdk-rgba', $gv)
        );

        return GdkRGBA unless $gv.pointer;

        cast(GdkRGBA, $gv.pointer)
      },
      STORE => -> $, GdkRGBA() $val is copy {
        $gv.pointer = $val;
        self.prop_set('fill-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method fill-color-rgba is rw  {
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
  method fill-pattern (:$raw = False) is rw  {
    my GLib::Value $gv .= new( Goo::Raw::Boxed.pattern_get_type() );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('fill-pattern', $gv)
        );

        return Nil unless $gv.boxed;

        my $p = cast(cairo_pattern_t, $gv.boxed);

        $raw ?? $p !! Cairo::Pattern.new($p);
      },
      STORE => -> $, CairoPatternObject $val is copy {
        $val .= pattern if $val ~~ Cairo::Pattern;
        $gv.boxed = $val;
        self.prop_set('fill-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method fill-pixbuf is rw  {
    my GLib::Value $gv .= new( GDK::Pixbuf.get_type() );
    Proxy.new(
      FETCH => -> $ {
        warn 'fill-pixbuf does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('fill-pixbuf', $gv);
      }
    );
  }

  # Type: GooCairoFillRule
  method fill-rule is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('fill-rule', $gv)
        );
        Cairo::FillRule( $gv.enum )
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
  method font-desc (:$raw = False) is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('font-desc', $gv)
        );

        return Nil unless $gv.pointer;

        my $fd = cast(PangoFontDescription, $gv.pointer);

        $raw ?? $fd !! Pango::FontDescription.new($fd);
      },
      STORE => -> $, PangoFontDescription() $val is copy {
        $gv.pointer = $val;
        self.prop_set('font-desc', $gv);
      }
    );
  }

  # Type: GooCairoHintMetrics
  method hint-metrics is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('hint-metrics', $gv)
        );
        Cairo::cairo_hint_metrics_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('hint-metrics', $gv);
      }
    );
  }

  # Type: GooCairoLineCap
  method line-cap is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-cap', $gv)
        );
        Cairo::cairo_line_cap( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('line-cap', $gv);
      }
    );
  }

  # Type: GooCanvasLineDash
  method line-dash is rw  {
    my GLib::Value $gv .= new( Goo::Raw::Boxed.line_dash_get_type() );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-dash', $gv)
        );
        cast(GooCanvasLineDash, $gv.boxed);
      },
      STORE => -> $, GooCanvasLineDash $val is copy {
        $gv.boxed = $val;
        self.prop_set('line-dash', $gv);
      }
    );
  }

  # Type: GooCairoLineJoin
  method line-join is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('line-join', $gv)
        );
        Cairo::cairo_line_join_t( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('line-join', $gv);
      }
    );
  }

  # Type: gdouble
  method line-join-miter-limit is rw  {
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
  method line-width is rw  {
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
  method stroke-color is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn 'stroke-color does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('stroke-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method stroke-color-gdk-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('stroke-color-gdk-rgba', $gv)
        );

        return Nil unless $gv.pointer;

        cast(GdkRGBA, $gv.pointer);

      },
      STORE => -> $, GdkRGBA $val is copy {
        $gv.pointer = $val;
        self.prop_set('stroke-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method stroke-color-rgba is rw  {
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
  method stroke-pattern (:$raw = False) is rw  {
    my GLib::Value $gv .= new(
      Goo::Raw::Boxed.pattern_get_type()
    );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('stroke-pattern', $gv)
        );

        return cairo_pattern_t unless $gv.boxed;

        my $p = cast(cairo_pattern_t, $gv.boxed);

        $raw ?? $p !! Cairo::Pattern.new($p);
      },
      STORE => -> $, CairoPatternObject $val is copy {
        $val .= pattern if $val ~~ Cairo::Pattern;
        $gv.boxed = $val;
        self.prop_set('stroke-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method stroke-pixbuf is rw  {
    my GLib::Value $gv .= new( GDK::Pixbuf.get_type() );
    Proxy.new(
      FETCH => -> $ {
        warn 'stroke-pixbuf does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('stroke-pixbuf', $gv);
      }
    );
  }

}
