use v6.c;

use Goo::Raw::Types;
use Goo::Raw::Boxed;

use GLib::Value;
use GDK::RGBA;

role Goo::Roles::Grid {

  # Type: gchar
  method border-color is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'border-color does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('border-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method border-color-gdk-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('border-color-gdk-rgba', $gv)
        );

        my $c = $gv.pointer;

        $c ?? cast(GdkRGBA, $c) !! GdkRGBA
      },
      STORE => -> $, GDK::RGBA $val is copy {
        $gv.pointer = $val;
        self.prop_set('border-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method border-color-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('border-color-rgba', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('border-color-rgba', $gv);
      }
    );
  }

  # Type: GooCairoPattern
  method border-pattern (:$raw = False) is rw  {
    my GLib::Value $gv .= new( Goo::Raw::Boxed.pattern_get_type() );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('border-pattern', $gv)
        );

        return cairo_pattern_t unless $gv.boxed;

        my $pattern = cast(cairo_pattern_t, $gv.boxed);

        $raw ?? $pattern !! Cairo::Pattern.new(:$pattern);
      },
      STORE => -> $, CairoPatternObject $val is copy {
        $val .= pattern if $val ~~ CairoPatternObject;
        $gv.boxed = $val;
        self.prop_set('border-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method border-pixbuf is rw  {
    my GLib::Value $gv .= new( GDK::Pixbuf.get_type() );
    Proxy.new(
      FETCH => sub ($) {
        warn 'border-pixbuf does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('border-pixbuf', $gv);
      }
    );
  }

  # Type: gdouble
  method border-width is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('border-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('border-width', $gv);
      }
    );
  }

  # Type: gdouble
  method height is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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

  # Type: gchar
  method horz-grid-line-color is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'horz-grid-line-color does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('horz-grid-line-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method horz-grid-line-color-gdk-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('horz-grid-line-color-gdk-rgba', $gv)
        );

        my $c = $gv.pointer;

        $c ?? cast(GdkRGBA, $c) !! GdkRGBA;
      },
      STORE => -> $, GDK::RGBA $val is copy {
        $gv.pointer = $val;
        self.prop_set('horz-grid-line-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method horz-grid-line-color-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('horz-grid-line-color-rgba', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('horz-grid-line-color-rgba', $gv);
      }
    );
  }

  # Type: GooCairoPattern
  method horz-grid-line-pattern (:$raw = False) is rw  {
    my GLib::Value $gv .= new( Goo::Raw::Boxed.pattern_get_type() );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('horz-grid-line-pattern', $gv)
        );

        return cairo_pattern_t unless $gv.boxed;

        my $pattern = cast(cairo_pattern_t, $gv.boxed);

        $raw ?? $pattern !! Cairo::Pattern.new(:$pattern);
      },
      STORE => -> $, CairoPatternObject $val is copy {
        $val .= pattern if $val ~~ Cairo::Pattern;
        $gv.boxed = $val;
        self.prop_set('horz-grid-line-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method horz-grid-line-pixbuf is rw  {
    my GLib::Value $gv .= new( GDK::Pixbuf.get_type() );
    Proxy.new(
      FETCH => sub ($) {
        warn 'horz-grid-line-pixbuf does not allow reading' if $DEBUG;

        GdkPixbuf;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('horz-grid-line-pixbuf', $gv);
      }
    );
  }

  # Type: gdouble
  method horz-grid-line-width is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('horz-grid-line-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('horz-grid-line-width', $gv);
      }
    );
  }

  # Type: gboolean
  method show-horz-grid-lines is rw  {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('show-horz-grid-lines', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('show-horz-grid-lines', $gv);
      }
    );
  }

  # Type: gboolean
  method show-vert-grid-lines is rw  {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('show-vert-grid-lines', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('show-vert-grid-lines', $gv);
      }
    );
  }

  # Type: gchar
  method vert-grid-line-color is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'vert-grid-line-color does not allow reading' if $DEBUG;

        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('vert-grid-line-color', $gv);
      }
    );
  }

  # Type: GdkRGBA
  method vert-grid-line-color-gdk-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vert-grid-line-color-gdk-rgba', $gv)
        );

        my $c = $gv.pointer;

        $c ?? cast(GdkRGBA, $c) !! GdkRGBA;
      },
      STORE => -> $, GDK::RGBA $val is copy {
        $gv.pointer = $val;
        self.prop_set('vert-grid-line-color-gdk-rgba', $gv);
      }
    );
  }

  # Type: guint
  method vert-grid-line-color-rgba is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vert-grid-line-color-rgba', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('vert-grid-line-color-rgba', $gv);
      }
    );
  }

  # Type: GooCairoPattern
  method vert-grid-line-pattern (:$raw = False) is rw  {
    my GLib::Value $gv .= new( Goo::Boxed.pattern_get_type() );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vert-grid-line-pattern', $gv)
        );

        return cairo_pattern_t unless $gv.boxed;

        my $pattern = cast(Cairo::cairo_pattern_t, $gv.boxed);

        $raw ?? $pattern !! Cairo::Pattern.new(:$pattern);
      },
      STORE => -> $, CairoPatternObject $val is copy {
        $val .= pattern if $val ~~ Cairo::Pattern;
        $gv.boxed = $val;
        self.prop_set('vert-grid-line-pattern', $gv);
      }
    );
  }

  # Type: GdkPixbuf
  method vert-grid-line-pixbuf is rw  {
    my GLib::Value $gv .= new( GDK::Pixbuf.get_type() );
    Proxy.new(
      FETCH => sub ($) {
        warn 'vert-grid-line-pixbuf does not allow reading' if $DEBUG;

        GdkPixbuf;
      },
      STORE => -> $, GdkPixbuf() $val is copy {
        $gv.object = $val;
        self.prop_set('vert-grid-line-pixbuf', $gv);
      }
    );
  }

  # Type: gdouble
  method vert-grid-line-width is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vert-grid-line-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('vert-grid-line-width', $gv);
      }
    );
  }

  # Type: gboolean
  method vert-grid-lines-on-top is rw  {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vert-grid-lines-on-top', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('vert-grid-lines-on-top', $gv);
      }
    );
  }

  # Type: gdouble
  method width is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method x-offset is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('x-offset', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x-offset', $gv);
      }
    );
  }

  # Type: gdouble
  method x-step is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('x-step', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x-step', $gv);
      }
    );
  }

  # Type: gdouble
  method y is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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

  # Type: gdouble
  method y-offset is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('y-offset', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y-offset', $gv);
      }
    );
  }

  # Type: gdouble
  method y-step is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('y-step', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y-step', $gv);
      }
    );
  }

}
