use v6.c;

use Method::Also;
use NativeCall;

use Goo::Raw::Types;

use GLib::Value;
use Goo::Group;

use Goo::Roles::Table;

our subset GooCanvasTableAncestry is export of Mu
  where GooCanvasTable | GooCanvasGroupAncestry;

class Goo::Table is Goo::Group {
  also does Goo::Roles::Table;

  has GooCanvasTable $!t;

  submethod BUILD (:$table) {
    given $table {
      when GooCanvasTableAncestry {
        my $to-parent;
        $!t = do {
          when GooCanvasTable {
            $to-parent = cast(GooCanvasGroup, $_);
            $_;
          }

          default {
            $to-parent = $_;
            cast(GooCanvasTable, $_);
          }
        }
        self.setGroup($to-parent)
      }

      when Goo::Group {
      }

      default {
      }
    }
  }

  method Goo::Raw::Definitions::GooCanvasTable
    is also<GooCanvasTable>
  { $!t }

  multi method new (GooCanvasTableAncestry $table) {
    $table ?? self.bless(:$table) !! GooCanvasTable;
  }
  multi method new (GooCanvasItem() $parent) {
    my $table = goo_canvas_table_new($parent, Str);

    $table ?? self.bless(:$table) !! GooCanvasTable;
  }
  multi method new (GooCanvasItem() $parent, Int() $width, Int() $height) {
    my $o = samewith($parent);

    return GooCanvasTable unless $o;

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
