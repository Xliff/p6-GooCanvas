use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

unit package Goo::Raw::Rect;

sub goo_canvas_rect_new (
  GooCanvasItem $parent,
  gdouble       $x,
  gdouble       $y,
  gdouble       $width,
  gdouble       $height,
  Str
)
  returns GooCanvasRect
  is export
  { * }

sub goo_canvas_rect_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_rect_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
