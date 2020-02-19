use v6.c;

use NativeCall;

use Cairo;


use Goo::Raw::Types;

unit package Goo::Raw::CanvasItemSimple;

sub goo_canvas_item_model_simple_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_changed (
  GooCanvasItemSimple $item,
  gboolean $recompute_bounds
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_check_in_path (
  GooCanvasItemSimple $item,
  gdouble $x,
  gdouble $y,
  cairo_t $cr,
  uint32 $pointer_events # GooCanvasPointerEvents $pointer_events
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_check_style (GooCanvasItemSimple $item)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_get_path_bounds (
  GooCanvasItemSimple $item,
  cairo_t $cr,
  GooCanvasBounds $bounds
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_paint_path (GooCanvasItemSimple $item, cairo_t $cr)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_set_model (
  GooCanvasItemSimple $item,
  GooCanvasItemModel $model
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_user_bounds_to_device (
  GooCanvasItemSimple $item,
  cairo_t $cr,
  GooCanvasBounds $bounds
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_simple_user_bounds_to_parent (
  GooCanvasItemSimple $item,
  cairo_t $cr,
  GooCanvasBounds $bounds
)
  is native(goo)
  is export
  { * }
