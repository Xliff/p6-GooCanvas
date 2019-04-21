use v6.c;

use NativeCall;

use Cairo;
use GTK::Compat::Types;

unit package GooCanvas::Raw::Types;

my subset BooleanValue where True | False | 1 | 0;

our enum CanvasBitmask (
  NEED_UPDATE   => 9,
  NEED_ENTIRE   => 8,
  INT_LAYOUT    => 7,
  AUTO_BOUNDS   => 6,
  ORIGIN_BOUNDS => 5,
  CLEAR_BACK    => 4,
  REDRAW_SCALE  => 3,
  BEFORE_DRAW   => 2,
  HSCROLL_POLCY => 1,
  VSCROLL_POLCY => 0
);

class GooCanvas is repr('CStruct') is export does GTK::Roles::Pointers {
  has GtkContainer       $.container;
  has GooCanvasItemModel $.root_item_model;
  has GooCanvasItem      $.root_item;
  has GooCanvasBounds    $.bounds;
  has gdouble            $.scale_x
  has gdouble            $.scale_y;
  has gdouble            $.scale;
  has uint32             $.anchor                # GooCanvasAnchorType anchor;
  has guint              $.idle_id;

  #guint need_update                : 1;
  #guint need_entire_subtree_update : 1;
  #guint integer_layout             : 1;
  #guint automatic_bounds           : 1;
  #guint bounds_from_origin         : 1;
  #guint clear_background           : 1;
  #guint redraw_when_scrolled       : 1;
  #guint before_initial_draw        : 1;
  #guint hscroll_policy             : 1;
  #guint vscroll_policy             : 1;
  has guint16            $!mask;

  has gdouble            $.bounds_padding;
  has GooCanvasItem      $.pointer_item;
  has GooCanvasItem      $.pointer_grab_item;
  has GooCanvasItem      $.pointer_grab_initial_item;
  has guint pointer_     $.grab_button;
  has GooCanvasItem      $.focused_item;
  has GooCanvasItem      $.keyboard_grab_item;
  has GdkEventCrossing   $.crossing_event;
  has GdkWindow          $.canvas_window;
  has gint               $.canvas_x_offset;
  has gint               $.canvas_y_offset;
  has GtkAdjustment      $.hadjustment;
  has GtkAdjustment      $.vadjustment;
  has gint               $.reeze_count;
  has GdkWindow          $.tmp_window;
  has GHashTable         $.model_to_item;
  has GtkUnit            $.units;
  has gdouble            $.resolution_x;
  has gdouble            $.resolution_y;
  has gdouble            $.device_to_pixels_x;
  has gdouble            $.device_to_pixels_y;
  has GList              $.widget_items;

  method need_update is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< NEED_UPDATE) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< NEED_UPDATE !!
          $!mask +&= +^(1 +< NEED_UPDATE)
      }
  }

  method need_entire_subtree_update is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< NEED_ENTIRE) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< NEED_ENTIRE !!
          $!mask +&= +^(1 +< NEED_ENTIRE)
      }
  }

  method integer_layout is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< INT_LAYOUT) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< INT_LAYOUT  !!
          $!mask +&= +^(1 +< INT_LAYOUT)
      }
  }

  method automatic_bounds is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< AUTO_BOUNDS) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< AUTO_BOUNDS !!
          $!mask +&= +^(1 +< AUTO_BOUNDS);
      }
  }

  method bounds_from_origin is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< ORIGIN_BOUNDS) },
      STORE => => $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< ORIGIN_BOUNDS  !!
          $!mask +&= +^(1 +< ORIGIN_BOUNDS);
      }
  }

  method clear_background is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< CLEAR_BACK) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< CLEAR_BACK  !!
          $!mask +&= +^(1 +< CLEAR_BACK)
      }
  }

  method redraw_when_scrolled is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< REDRAW_SCALE) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< REDRAW_SCALE  !!
          $!mask +&= +^(1 +< REDRAW_SCALE)
      }
  }

  method before_initial_draw is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< BEFORE_DRAW) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< BEFORE_DRAW   !!
          $!mask +&= +^(1 +< BEFORE_DRAW)
      }
  }

  method hscroll_policy is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< HSCROLL_POLCY) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< HSCROLL_POLCY !!
          $!mask +&= +^(1 +< HSCROLL_POLCY)
      }
  }

  method vscroll_policy is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< VSCROLL_POLCY) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< VSCROLL_POLCY
          $!mask +&= +^(1 +< VSCROLL_POLCY)
      }
  }

}

my enum CanvasDataBitmask (
  VISIBILITY  => (0b0011. 14),
  PTR_EVENTS  => (0b1111. 10),
  CAN_FOCUS   => (0b0001.  9),
  OWN_STYLE   => (0b0001.  8),
  CLIP_FILL   => (0b1111.  4),
  STATIC      => (0b0001.  3),
  CACHE       => (0b0011.  1),
  TOOLTIP     => (0b0001.  0)
}

class GooCanvasItemSimpleData is repr('CStruct') is export does GTK::Roles::Pointers {
  has GooCanvasStyle  $.style;
  has cairo_matrix_t  $.transform;
  has GArray          $.clip_path_commands;
  has Str             $.tooltip;
  has gdouble         $.visibility_threshold;

  #guint visibility			    : 2;
  #guint pointer_events			: 4;
  #guint can_focus          : 1;
  #guint own_style          : 1;
  #guint clip_fill_rule			: 4;
  #guint is_static			    : 1;
  #guint cache_setting			: 2;  # PRIVATE
  #guint has_tooltip			  : 1;  # PRIVATE
  has guint16         $!mask;

  method visibility is rw {
    Proxy.new:
      FETCH => -> $ { ($!masks +& PTR_VISIBILITY[0]) +> PTR_VISIBILITY[1] },
      STORE => -> $, $val where 0..3 {
        $!mask +&= +^PTR_VISIBILITY[0] +< PTR_VISIBILITY[1];
        $!mask +|= $val                +< PTR_VISIBILITY[1];
      }
  }

  method pointer_events is rw {
    Proxy.new:
      FETCH => -> $ { ($!mask +& PTR_EVENTS[0]) +> PTR_EVENTS[1] },
      STORE => -> $, $val where 0..15 {
        $!mask +&= +^PTR_EVENTS[0] +< PTR_EVENTS[1];
        $!mask +|= $val            +< PTR_EVENTS[1];
      }
  }

  method can_focus is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< CAN_FOCUS[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< CAN_FOCUS[1] !!
          $!mask +&= +^(1 +< CAN_FOCUS[1])
      }
  }

  method own_style is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< OWN_STYLE[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< OWN_STYLE[1] !!
          $!mask +&= +^(1 +< OWN_STYLE[1])
      }
  }

  method clip_fill_rule is rw {
    Proxy.new:
      FETCH => -> $ { ($!masks +& CLIP_FILL[0]) +> CLIP_FILL[1] },
      STORE => -> $, $val where 0..3 {
        $!mask +&= +^CLIP_FILL[0] +< CLIP_FILL[1];
        $!mask +|= $val           +< CLIP_FILL[1];
      }
  }

  method is_static is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< STATIC[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< STATIC[1] !!
          $!mask +&= +^(1 +< STATIC[1])
      }
  }

  method cache_setting is rw {
    Proxy.new:
      FETCH => -> $ { ($!masks +& CACHE[0]) +> CACHE[1] },
      STORE => -> $, $val where 0..3 {
        $!mask +&= +^CACHE[0] +< CACHE[1];
        $!mask +|= $val       +< CACHE[1];
      }
  }

  method has_tooltip is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< TOOLTIP[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< TOOLTIP[1] !!
          $!mask +&= +^(1 +< TOOLTIP[1])
      }
  }

};

my enum SimpleCanvasBitmask (
  # Mask 1
  SIMPLE_NEED_UPDATE   => 1,
  SIMPLE_NEED_ENTIRE   => 0
);

class GooCanvasItemModelSimple is repr('CStruct') is export does GTK::Roles::Pointers {
  HAS GObject                 $!parent_object;
  has GooCanvasItemModel      $.parent;
  HAS GooCanvasItemSimpleData $.simple_data;
  has Str                     $!title;
  has Str                     $!description;
};

class GooCanvasItemSimple is repr('CStruct') is export does GTK::Roles::Pointers {
  HAS GObject                  $!parent_object;

  has GooCanvas                $.canvas;
  has GooCanvasItem            $.parent;
  has GooCanvasItemModelSimple $.model;
  has GooCanvasItemSimpleData  $.simple_data;
  has GooCanvasBounds          $.bounds;

  #guint need_update			               : 1;
  #guint need_entire_subtree_update      : 1;
  has guint                    $!mask;

  has gpointer                 $.priv;

  method need_update is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< SIMPLE_NEED_UPDATE) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< SIMPLE_NEED_UPDATE !!
          $!mask +&= +^(1 +< SIMPLE_NEED_UPDATE)
      }
  }

  method need_entire_subtree_update is rw {
    Proxy.new:
      FETCH => -> $ { so $!mask +& (1 +< SIMPLE_NEED_ENTIRE) },
      STORE => -> $, BooleanValue $val {
        $val ??
          $!mask +|=    1 +< SIMPLE_NEED_ENTIRE !!
          $!mask +&= +^(1 +< SIMPLE_NEED_ENTIRE)
      }
  }
};
