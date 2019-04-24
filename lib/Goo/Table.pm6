use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use GTK::Compat::Value;
use Goo::Group;
use Goo::CanvasItemSimple;

class Goo::Table is Goo::Group {
  has GooCanvasTable $!t;

  my @child-property-uint = <column columns row rows>;
  my @child-property-double = <
    bottom-padding  left-padding  right-padding  top-padding
    x-align         y-align
  >;
  my @child-property-bool = <
    x-expand        x-fill        x-shrink
    y-expand        y-fill        y-shrink
  >;
  my @valid-child-properties = (
    |@child-property-uint,
    |@child-property-double,
    |@child-property-bool
  );

  submethod BUILD (:$table) {
    self.setGroup( cast(GooCanvasGroup, $!t = $table) )
  }

  method Goo::Raw::Types::GooCanvasTable
    #is also<Table>
  { $!t }

  multi method new (GooCanvasTable $table) {
    self.bless(:$table);
  }
  multi method new (GooCanvasItem() $parent) {
    self.bless( table => goo_canvas_table_new($parent, Str) )
  }

  # Type: gdouble
  method column-spacing is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('column-spacing', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('column-spacing', $gv);
      }
    );
  }

  # Type: gboolean
  method homogeneous-columns is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('homogeneous-columns', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('homogeneous-columns', $gv);
      }
    );
  }

  # Type: gboolean
  method homogeneous-rows is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('homogeneous-rows', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('homogeneous-rows', $gv);
      }
    );
  }

  # Type: gdouble
  method horz-grid-line-width is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('horz-grid-line-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('horz-grid-line-width', $gv);
      }
    );
  }

  # Type: gdouble
  method row-spacing is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('row-spacing', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('row-spacing', $gv);
      }
    );
  }

  # Type: gdouble
  method vert-grid-line-width is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('vert-grid-line-width', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('vert-grid-line-width', $gv);
      }
    );
  }

  # Type: gdouble
  method x-border-spacing is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('x-border-spacing', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x-border-spacing', $gv);
      }
    );
  }

  # Type: gdouble
  method y-border-spacing is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('y-border-spacing', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y-border-spacing', $gv);
      }
    );
  }

  method get_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    GValue() $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;
    nextsame;
  }

  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    Int $value
  ) {
    die "Invalid INT Child property name '{ $property_name }'!"
      unless
        $property_name eq @child-property-uint.any ||
        $property_name eq @child-property-bool.any;
    nextwith($child, $property_name, gv_uint($value.Int));
  }
  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    Bool $value
  ) {
    die "Invalid BOOL Child property name '{ $property_name }'!"
      unless $property_name eq @child-property-bool.any;
    nextwith($child, $property_name, gv_bool($value));
  }
  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    Num $value
  ) {
    die "Invalid DOUBLE Child property name '{ $property_name }'!"
      unless $property_name eq @child-property-double.any;
    nextwith($child, $property_name, gv_dbl($value));
  }
  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;
    my $v = do {
      when $property_name eq @child-property-uint    { $v.Int }
      when $property_name eq @child-property-bool    { $v.Int }
      when $property_name eq @child-property-double  { $v.Num }
    }
    nextwith($child, $property_name, $v);
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_table_get_type, $n, $t);
  }

  method model_get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_table_model_get_type, $n, $t );
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

sub goo_canvas_table_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
