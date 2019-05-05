use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

role Goo::Roles::Signals::Canvas {
  has %!signals-gc;

  # GooCanvas, GooCanvasItem, GooCanvasItemModel, gpointer
  method connect-item-created (
    $obj,
    $signal = 'item-created',
    &handler?
  ) {
    my $hid;

    %!signals-gc{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-item-created($obj, $signal,
        -> $, $gcim, $gciml, $ud {
          CATCH {
            default { $s.quit($_) }
          }

          $s.emit( [self, $gcim, $gciml, $ud ] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-gc{$signal}[0].tap(&handler) with &handler;
    %!signals-gc{$signal}[0];
  }

}

# GooCanvas, GooCanvasItem, GooCanvasItemModel, gpointer
sub g-connect-item-created(
  Pointer $app,
  Str $name,
  &handler (Pointer, GooCanvasItem, GooCanvasItemModel, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }
