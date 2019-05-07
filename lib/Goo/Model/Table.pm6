use v6.c;

use NativeCall;
use Method::Also;

use GTK::Compat::Types;

use Goo::Raw::Types;

use Goo::Model::Group;

use Goo::Roles::Table;

class Goo::Model::Table is Goo::Model::Group {
  also does Goo::Roles::Table;

  method new (
    GooCanvasItemModel() $parent = GooCanvasItemModel,
    *@props
  ) {
    self.bless(
      simple => goo_canvas_table_model_new($parent, Str),
      props  => @props
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_table_model_get_type, $n, $t );
  }
}

sub goo_canvas_table_model_new(GooCanvasItemModel $parent, Str)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_table_model_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
