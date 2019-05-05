use v6.c;

use NativeCall;

use GTK::Compat::Types;

use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Path;

class Goo::Model::Path is Goo::Model::Simple {
  also does Goo::Roles::Path;

  method new (
    GooCanvasItemModel() $parent,
    Str() $path_data,
    *@props
  ) {
    self.bless(
      simple => goo_canvas_path_model_new($parent, $path_data, Str),
      props  => @props
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_path_model_get_type, $n, $t );
  }

}

sub goo_canvas_path_model_new (
  GooCanvasItemModel $parent,
  Str $path_data,
  Str
)
  returns GooCanvasItemModel
  is native(goo)
  is export
  { * }

sub goo_canvas_path_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
