use v6.c;

use NativeCall;


use Goo::Raw::Types;

use Goo::Model::Simple;

use Goo::Roles::Group;

class Goo::Model::Group is Goo::Model::Simple {
  also does Goo::Roles::Group;

  method new (GooCanvasItemModel() $parent = GooCanvasItemModel, *@props) {
    my $simple = goo_canvas_group_model_new($parent, Str);

    $simple ?? self.bless(:$simple, :@props) !! GooCanvasGroupModel;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_group_model_get_type, $n, $t );
  }

}

sub goo_canvas_group_model_new (GooCanvasItemModel $parent, Str)
  returns GooCanvasGroupModel
  is native(goo)
  is export
{ * }

sub goo_canvas_group_model_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
