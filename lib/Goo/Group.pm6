use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Group;

class Goo::Group is Goo::CanvasItemSimple {
  also does Goo::Roles::Group;

  has GooCanvasGroup $!g;

  submethod BUILD (:$group) {
    self.setGroup($group) if $group.defined;
  }

  method setGroup(GooCanvasGroup $group) {
    self.IS-PROTECTED;
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!g = $group) )
  }

  method Goo::Raw::Types::GooGroup
    #is also<Group>
  { $!g }

  multi method new (GooCanvasGroup $group) {
    self.bless(:$group);
  }
  multi method new (GooCanvasItem() $parent) {
    self.bless( group => goo_canvas_group_new($parent, Str) )
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_group_get_type, $n, $t);
  }

}

sub goo_canvas_group_new (GooCanvasItem $parent, Str)
  returns GooCanvasGroup
  is native(goo)
  is export
  { * }

sub goo_canvas_group_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
