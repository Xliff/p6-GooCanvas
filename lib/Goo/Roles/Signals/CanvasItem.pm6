use v6.c;

use NativeCall;

use Goo::Raw::Types;

use GLib::Raw::ReturnedValue;

use GLib::Roles::Signals::Generic;

role Goo::Roles::Signals::CanvasItem {
  also does GLib::Roles::Signals::Generic;

  has %!signals-ci;

  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method connect-canvas-event (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-ci{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-canvas-event($obj, $signal,
        -> $, $gcim, $get, $ud --> gboolean {
          CATCH {
            default { $s.quit($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $gcim, $get, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-ci{$signal}[0].tap(&handler) with &handler;
    %!signals-ci{$signal}[0];
  }

  # GooCanvasItem, gdouble, gdouble, gboolean, GtkTooltip, gpointer --> gboolean
  method connect-query-tooltip (
    $obj,
    $signal = 'query-tooltip',
    &handler?
  ) {
    my $hid;
    %!signals-ci{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-query-tooltip($obj, $signal,
        -> $, $ge1, $ge2, $gn, $gtp, $ud --> gboolean {
          CATCH {
            default { $s.quit($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $ge1, $ge2, $gn, $gtp, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-ci{$signal}[0].tap(&handler) with &handler;
    %!signals-ci{$signal}[0];
  }
}

# GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
sub g-connect-canvas-event(
  Pointer $app,
  Str $name,
  &handler (Pointer, GooCanvasItem, GdkEvent, Pointer --> gboolean),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GooCanvasItem, gdouble, gdouble, gboolean, GtkTooltip, gpointer --> gboolean
sub g-connect-query-tooltip(
  Pointer $app,
  Str $name,
  &handler (Pointer, gdouble, gdouble, gboolean, GtkTooltip, Pointer --> gboolean),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }
