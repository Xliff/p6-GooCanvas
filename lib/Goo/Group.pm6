use v6.c;

use NativeCall;

use Goo::Raw::Types;

use Goo::CanvasItemSimple;

use Goo::Roles::Group;

our subset GooCanvasGroupAncestry is export of Mu
  where GooCanvasGroup | GooCanvasItemSimple;

class Goo::Group is Goo::CanvasItemSimple {
  also does Goo::Roles::Group;

  has GooCanvasGroup $!g;

  submethod BUILD (:$group) {
    self.setGroup($group) if $group.defined;
  }

  method setGroup(GooCanvasGroupAncestry $_) {
    #self.IS-PROTECTED;
    my $to-parent;
    $!g = do {
      when GooCanvasGroup {
        $to-parent = cast(GooCanvasItemSimple, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GooCanvasGroup, $_);
      }
    }
    self.setSimpleCanvasItem($to-parent);
  }

  method Goo::Raw::Definitions::GooCanvasGroup
    #is also<
    #   CanvasGroup
    #   GooCanvasGroup
    # >
  { $!g }

  # Included here due to errors in Method::Also and rakudo.
  method GooCanvasGroup { $!g }

  multi method new (GooCanvasGroupAncestry $group) {
    $group ?? self.bless(:$group) !! GooCanvasGroup;
  }
  multi method new (GooCanvasItem() $parent) {
    my $group = goo_canvas_group_new($parent, Str);

    $group ?? self.bless(:$group) !! GooCanvasGroup;
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
