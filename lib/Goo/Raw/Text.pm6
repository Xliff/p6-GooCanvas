use v6.c;

use NativeCall;

use Pango::Raw::Types;
use GTK::Compat::Types;
use Goo::Raw::Types;

unit package Goo::Raw::Text;

sub goo_canvas_text_new (
  GooCanvasItem $parent,
  Str           $string,
  gdouble       $x,
  gdouble       $y,
  gdouble       $width,
  uint32        $anchor,                 # GooCanvasAnchorType
  Str
)
  returns GooCanvasText
  is native(goo)
  is export
  { * }

sub goo_canvas_text_get_natural_extents (
  GooCanvasText $text,
  PangoRectangle $ink_rect,
  PangoRectangle $logical_rect
)
  is native(goo)
  is export
  { * }

sub goo_canvas_text_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_text_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
