use v6.c;

use NativeCall;



use Goo::Raw::Types;


use GLib::Value;
use GTK::Widget;

use Goo::CanvasItemSimple;

class Goo::Widget is Goo::CanvasItemSimple {
  has GooCanvasWidget $!gw;
  has $!gtk_widget;

  submethod BUILD (:$widget, :$!gtk_widget) {
    self.setSimpleCanvasItem( cast(GooCanvasItemSimple, $!gw = $widget) )
  }

  method Goo::Raw::Definitions::GooCanvasWidget
    #is also<GooWidget>
  { $!gw }

  multi method new (GooCanvasWidget $widget) {
    self.bless(:$widget);
  }
  multi method new (
    GooCanvasItem() $parent,
                    $widget is copy,
    Num()           $x,
    Num()           $y,
    Num()           $width,
    Num()           $height
  ) {
    my gdouble ($xx, $yy, $w, $h) = ($x, $y, $width, $height);
    my $ww = $widget ~~ GTK::Widget ?? $widget.Widget !! $widget;
    self.bless(
      widget      => goo_canvas_widget_new(
        $parent, $ww, $xx, $yy, $w, $h, Str
      ),
      gtk_widget  => $widget
    );
  }

  # Type: GooCanvasAnchorType
  method anchor is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
          self.prop_get('anchor', $gv)
        );
        GooCanvasAnchorType( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('anchor', $gv);
      }
    );
  }

  # Type: gdouble
  method height is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
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

  # Type: GtkWidget
  method widget is rw  {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        # In this situation, we leave the creation logic to the caller.
        $!gtk_widget;
      },
      STORE => -> $, $val is copy {
        die q:to/D/.chomp unless $val ~~ (GTK::Widget, GtkWidget).any;
$val is not a GtkWidget compatible object! Please pass the widget object, if
available, or cast(GtkWidget, $val) if you are sure this message is in error!
D
        $!gtk_widget = $val;
        $gv.object = $val ~~ GTK::Widget ?? $val.Widget !! $val;
        self.prop_set('widget', $gv);
      }
    );
  }

  # Type: gdouble
  method width is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GLib::Value.new(
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
    unstable_get_type( self.^name, &goo_canvas_widget_get_type, $n, $t );
  }

}

sub goo_canvas_widget_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_widget_new (
  GooCanvasItem $parent,
  GtkWidget     $widget,
  gdouble       $x,
  gdouble       $y,
  gdouble       $width,
  gdouble       $height,
  Str
)
  returns GooCanvasWidget
  is native(goo)
  is export
  { * }
