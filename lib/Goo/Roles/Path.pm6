use v6.c;

use Goo::Raw::Types;
use GLib::Value;

role Goo::Roles::Path {

  # Type: gchar
  method data is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'data does not allow reading' if $DEBUG;
        ''
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('data', $gv);
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

}
