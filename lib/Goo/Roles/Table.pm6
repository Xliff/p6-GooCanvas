use v6.c;

use Method::Also;

use Goo::Raw::Types;

use GLib::Value;

use Goo::Roles::CanvasItem;
use Goo::Model::Roles::Item;

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

my subset ItemOrModel
    where Goo::Roles::CanvasItem | Goo::Model::Roles::Item   |
          GooCanvasItem          | GooCanvasItemModel        ;

role Goo::Roles::Table {

  # Type: gdouble
  method column-spacing is rw  is also<column_spacing> {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    ItemOrModel $child,
    Str() $property_name
  ) {
    my $c = do given $child {
      when Goo::Roles::CanvasItem    { .CanvasItem      }
      when Goo::Model::Roles::Item   { .CanvasItemModel }
    }
    my $gv-type = do given $property_name {
      when   @child-property-bool.any { G_TYPE_BOOLEAN }
      when   @child-property-uint.any { G_TYPE_UINT    }
      when @child-property-double.any { G_TYPE_DOUBLE  }
    }

    my $gv = GLib::Value.new($gv-type);
    samewith($c, $property_name, $gv);
    $gv.value;
  }
  multi method get_child_property (
    ItemOrModel $child,
    Str() $property_name,
    GValue() $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;

    my @args = ($child, $property_name, $value);
    if $child ~~ GooCanvasItem {
      self.Goo::Roles::CanvasItem::get_child_property(|@args);
    } else {
      self.Goo::Model::Roles::Item::get_child_property(|@args);
    }
  }

  multi method set_child_property (
    ItemOrModel $child,
    Str() $property_name, # where { $_ eq @child-property-uint.any },
    Int() $value is copy
  ) {
    my ($is-uint, $is-bool) = (
      ($property_name eq @child-property-uint.any).so,
      ($property_name eq @child-property-bool.any).so
    );
    nextsame unless $is-uint || $is-bool;
    samewith( $child, $property_name, gv_uint($value) );
  }
  multi method set_child_property (
    ItemOrModel $child,
    Str() $property_name,
    Bool $value
  ) {
    nextsame unless ($property_name eq @child-property-bool.any).so;
    samewith( $child, $property_name, gv_bool($value) );
  }
  multi method set_child_property (
    ItemOrModel $child,
    Str() $property_name, # where * eq @child-property-double.any,
    Cool $value is copy
  ) {
    nextsame unless ($property_name eq @child-property-double.any).so;
    $value .= Num;
    samewith( $child, $property_name, gv_dbl($value) );
  }
  multi method set_child_property (
    ItemOrModel $child,
    Str() $property_name,
    $value
  ) {
    die "Invalid child property name '{ $property_name }'!"
      unless $property_name eq @valid-child-properties.any;
    # Force to right method in inheritance chain.
    if $value ~~ (GLib::Value, GValue).any {
      my $c = do given $child {
        when Goo::Roles::CanvasItem             { .CanvasItem      }
        when Goo::Model::Roles::Item            { .CanvasItemModel }

        when GooCanvasItem | GooCanvasItemModel { $_ }

        default {
          die "Unknown type passed as \$child to{ ''
              } Goo::Roles::Table.set_child_property: { .^name }";
        }
      }
      # nextwith/nextsame isn't doing the job, so it has to be done manually
      # via a type-check hack.
      my @args = ($c, $property_name, $value);
      if $c ~~ GooCanvasItem {
        self.Goo::Roles::CanvasItem::set_child_property(|@args);
      } else {
        self.Goo::Model::Roles::Item::set_child_property(|@args);
      }
    } else {
      die "Invalid value of type { $value.^name } passed for {
           $property_name }!";
    }
  }

  method set_child_properties (
    ItemOrModel $child,
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

}
