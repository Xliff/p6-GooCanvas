use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use Goo::CanvasItemSimple;

class Goo::Group is Goo::CanvasItemSimple {
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

  # Type: gdouble
  method height is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
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

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_group_get_type, $n, $t);
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_group_model_get_type, $n, $t );
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

sub goo_canvas_group_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
