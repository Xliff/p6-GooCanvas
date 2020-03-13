use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Goo::Raw::Definitions;

unit package Goo::Raw::Structs;

class GooCanvasBounds is repr('CStruct')         is export does GLib::Roles::Pointers {
  has gdouble $.x1 is rw;
  has gdouble $.y1 is rw;
  has gdouble $.x2 is rw;
  has gdouble $.y2 is rw;
}

class GooCanvasPoints is repr('CStruct')         is export does GLib::Roles::Pointers {
  has CArray[num64] $.coords;
  has gint          $num_points;
  has gint          $ref_count;
}

class GooCanvasStyle is repr('CStruct')          is export does GLib::Roles::Pointers {
  has GooCanvasStyle $.parent;
  has GArray         $.properties;
}

class GooCanvasStyleProperty                     is repr('CStruct') is export does GLib::Roles::Pointers {
  has GQuark $.id;
  has GValue $.value;
}

class GooCanvasLineDash                          is repr('CStruct') is export does GLib::Roles::Pointers {
  has gint    $.ref_count   is rw;
  has gint    $.num_dashes  is rw;
  has gdouble $.dashes      is rw;
  has gdouble $.dash_offset is rw;
}

our enum CanvasDataBitmask (
  VISIBILITY  => (0b0011, 14),
  PTR_EVENTS  => (0b1111, 10),
  CAN_FOCUS   => (0b0001,  9),
  OWN_STYLE   => (0b0001,  8),
  CLIP_FILL   => (0b1111,  4),
  STATIC      => (0b0001,  3),
  CACHE       => (0b0011,  1),
  TOOLTIP     => (0b0001,  0)
);

class GooCanvasItemSimpleData is repr('CStruct') is export does GLib::Roles::Pointers {
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
      FETCH => sub ($) { ($!mask +& VISIBILITY[0]) +> VISIBILITY[1] },
      STORE => -> $, $val where 0..3 {
        $!mask +&= +^VISIBILITY[0] +< VISIBILITY[1];
        $!mask +|= $val            +< VISIBILITY[1];
      }
  }

  method pointer_events is rw {
    Proxy.new:
      FETCH => sub ($) { ($!mask +& PTR_EVENTS[0]) +> PTR_EVENTS[1] },
      STORE => -> $, $val where 0..15 {
        $!mask +&= +^PTR_EVENTS[0] +< PTR_EVENTS[1];
        $!mask +|= $val            +< PTR_EVENTS[1];
      }
  }

  method can_focus is rw {
    Proxy.new:
      FETCH => sub ($) { so $!mask +& (1 +< CAN_FOCUS[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          ( $!mask +|=    1 +< CAN_FOCUS[1]  ) !!
          ( $!mask +&= +^(1 +< CAN_FOCUS[1]) )
      }
  }

  method own_style is rw {
    Proxy.new:
      FETCH => sub ($) { so $!mask +& (1 +< OWN_STYLE[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          ( $!mask +|=    1 +< OWN_STYLE[1]  ) !!
          ( $!mask +&= +^(1 +< OWN_STYLE[1]) )
      }
  }

  method clip_fill_rule is rw {
    Proxy.new:
      FETCH => sub ($) { ($!mask +& CLIP_FILL[0]) +> CLIP_FILL[1] },
      STORE => -> $, $val where 0..3 {
        $!mask +&= +^CLIP_FILL[0] +< CLIP_FILL[1];
        $!mask +|= $val           +< CLIP_FILL[1];
      }
  }

  method is_static is rw {
    Proxy.new:
      FETCH => sub ($) { so $!mask +& (1 +< STATIC[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          ( $!mask +|=    1 +< STATIC[1]  ) !!
          ( $!mask +&= +^(1 +< STATIC[1]) )
      }
  }

  method cache_setting is rw {
    Proxy.new:
      FETCH => sub ($) { ($!mask +& CACHE[0]) +> CACHE[1] },
      STORE => -> $, $val where 0..3 {
        $!mask +&= +^CACHE[0] +< CACHE[1];
        $!mask +|= $val       +< CACHE[1];
      }
  }

  method has_tooltip is rw {
    Proxy.new:
      FETCH => sub ($) { so $!mask +& (1 +< TOOLTIP[1]) },
      STORE => -> $, BooleanValue $val {
        $val ??
          ( $!mask +|=    1 +< TOOLTIP[1]  ) !!
          ( $!mask +&= +^(1 +< TOOLTIP[1]) )
      }
  }

}

my enum SimpleCanvasBitmask (
  # Mask 1
  SIMPLE_NEED_UPDATE   => 1,
  SIMPLE_NEED_ENTIRE   => 0
);

# class GooCanvasItemModelSimple is repr('CStruct') is export does GLib::Roles::Pointers {
#   HAS GObject                 $!parent_object;
#   has GooCanvasItemModel      $.parent;
#   HAS GooCanvasItemSimpleData $.simple_data;
#   has Str                     $!title;
#   has Str                     $!description;
# }

# class GooCanvasItemSimple is repr('CStruct') is export does GLib::Roles::Pointers {
#   HAS GObject                  $!parent_object;
#
#   has GooCanvas                $.canvas;
#   has GooCanvasItem            $.parent;
#   has GooCanvasItemModelSimple $.model;
#   has GooCanvasItemSimpleData  $.simple_data;
#   has GooCanvasBounds          $.bounds;
#
#   #guint need_update			               : 1;
#   #guint need_entire_subtree_update      : 1;
#   has guint                    $!mask;
#
#   has gpointer                 $.priv;
#
#   method need_update is rw {
#     Proxy.new:
#       FETCH => sub ($) { so $!mask +& (1 +< SIMPLE_NEED_UPDATE) },
#       STORE => -> $, BooleanValue $val {
#         $val ??
#           ( $!mask +|=    1 +< SIMPLE_NEED_UPDATE  ) !!
#           ( $!mask +&= +^(1 +< SIMPLE_NEED_UPDATE) )
#       }
#   }
#
#   method need_entire_subtree_update is rw {
#     Proxy.new:
#       FETCH => sub ($) { so $!mask +& (1 +< SIMPLE_NEED_ENTIRE) },
#       STORE => -> $, BooleanValue $val {
#         $val ??
#           ( $!mask +|=    1 +< SIMPLE_NEED_ENTIRE  ) !!
#           ( $!mask +&= +^(1 +< SIMPLE_NEED_ENTIRE) )
#       }
#   }
# }
