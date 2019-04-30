use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

use GTK::Raw::Utils;

use GTK::Compat::Value;
use Goo::Group;

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
  method column-spacing is rw  is also<column_spacing> {
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
  method homogeneous-columns is rw  is also<homogeneous_columns> {
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
  method homogeneous-rows is rw  is also<homogeneous_rows> {
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
  method horz-grid-line-width is rw  is also<horz_grid_line_width> {
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
  method row-spacing is rw  is also<row_spacing> {
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
  method vert-grid-line-width is rw  is also<vert_grid_line_width> {
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
  method x-border-spacing is rw  is also<x_border_spacing> {
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
  method y-border-spacing is rw  is also<y_border_spacing> {
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

  proto method get_child_property (|)
    is also<get-child-property>
  { * }

  multi method get_child_property (
    GooCanvasItem() $child,
    Str() $property_name
  ) {
    # Set type based on $property_name.
    my $gv-type = do given $property_name {
      when   @child-property-bool.any { G_TYPE_BOOLEAN }
      when   @child-property-uint.any { G_TYPE_UINT    }
      when @child-property-double.any { G_TYPE_DOUBLE  }
    }

    my $gv = GTK::Compat::Value.new($gv-type);
    samewith($child, $property_name, $gv);
    $gv.value;
  }
  multi method get_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    GValue() $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;
    self.Goo::Roles::CanvasItem::get_child_property(
      $child, $property_name, $value
    );
  }

  proto method set_child_property (|)
    is also<set-child-property>
  { * }

  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name where * eq (
      |@child-property-uint,
      |@child-property-bool
    ).any,
    Int $value is copy
  ) {
    $value = resolve-bool($value)
      if $property_name eq @child-property-bool.any;
    samewith( $child, $property_name, gv_uint($value.Int) );
  }
  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name where * eq @child-property-bool.any,
    Bool $value
  ) {
    samewith( $child, $property_name, gv_bool($value) );
  }
  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name where * eq @child-property-double.any,
    Cool $value is copy
  ) {
    $value .= Num;
    samewith( $child, $property_name, gv_dbl($value) );
  }
  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    GValue $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;
    nextwith($child, $property_name, $value);
  }

  multi method set_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;
    # Force to right method in inheritance chain.
    if $value ~~ (GTK::Compat::Value, GValue).any {
      self.Goo::Roles::CanvasItem::set_child_property(
        $child, $property_name, $value
      )
    } else {
      die "Invalid value of type { $value.^name } passed for {
           $property_name }!";
    }
  }

  method set_child_properties (
    GooCanvasItem() $child,
    *@props
  )
    is also<set-child-properties>
  {
    die 'Parameters must be a flattened array of (property, value) pairs'
      unless +@props && @props.elems % 2 == 0;
    for @props.rotor(2) -> ($p, $v) {
      self.set_child_property($child, $p, $v);
    }
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &goo_canvas_table_get_type, $n, $t);
  }

  method model_get_type is also<model-get-type> {
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
