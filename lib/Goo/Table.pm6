use v6.c;

use Method::Also;
use NativeCall;


use Goo::Raw::Types;

use GTK::Raw::Utils;

use GLib::Value;
use Goo::Group;

use Goo::Roles::Table;

class Goo::Table is Goo::Group {
  also does Goo::Roles::Table;

  has GooCanvasTable $!t;

  submethod BUILD (:$table) {
    self.setGroup( cast(GooCanvasGroup, $!t = $table) )
  }

  method Goo::Raw::Definitions::GooCanvasTable
    #is also<Table>
  { $!t }

  multi method new (GooCanvasTable $table) {
    self.bless(:$table);
  }
  multi method new (GooCanvasItem() $parent) {
    self.bless( table => goo_canvas_table_new($parent, Str) )
  }
  multi method new (GooCanvasItem() $parent, Int() $width, Int() $height) {
    my $o = samewith($parent);
    ($o.width, $o.height) = ($width, $height);
    $o;
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_table_get_type, $n, $t);
  }

}

sub goo_canvas_table_new (GooCanvasItem $parent, Str)
  returns GooCanvasTable
  is native(goo)
  is export
  { * }

sub goo_canvas_table_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
