use v6.c;

use NativeCall;


use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Path;

class Goo::Path is Goo::CanvasItemSimple {
  also does Goo::Roles::Path;

  has GooCanvasPath $!p;

  submethod BUILD (:$path) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!p = $path) );
  }

  multi method new (GooCanvasPath $path) {
    self.bless(:$path);
  }
  multi method new (GooCanvasItem() $parent, Str $path_data) {
    self.bless( path => goo_canvas_path_new($parent, $path_data, Str) );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_path_get_type, $n, $t );
  }
}

sub goo_canvas_path_new (
  GooCanvasItem $parent,
  Str           $path_data,
  Str
)
  returns GooCanvasPath
  is native(goo)
  is export
  { * }

sub goo_canvas_path_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
