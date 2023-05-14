use v6.c;

use NativeCall;

use Goo::Raw::Types;

unit package Goo::Raw::Canvas;

sub goo_canvas_convert_bounds_to_item_space (
  GooCanvas $canvas,
  GooCanvasItem $item,
  GooCanvasBounds $bounds
)
  is native(goo)
  is export
{ * }

sub goo_canvas_convert_from_item_space (
  GooCanvas $canvas,
  GooCanvasItem $item,
  gdouble $x,
  gdouble $y
)
  is native(goo)
  is export
{ * }

sub goo_canvas_convert_from_pixels (GooCanvas $canvas, gdouble $x, gdouble $y)
  is native(goo)
  is export
{ * }

sub goo_canvas_convert_to_item_space (
  GooCanvas $canvas,
  GooCanvasItem $item,
  gdouble $x,
  gdouble $y
)
  is native(goo)
  is export
{ * }

sub goo_canvas_convert_to_pixels (GooCanvas $canvas, gdouble $x, gdouble $y)
  is native(goo)
  is export
{ * }

sub goo_canvas_convert_units_from_pixels (
  GooCanvas $canvas,
  gdouble $x,
  gdouble $y
)
  is native(goo)
  is export
{ * }

sub goo_canvas_convert_units_to_pixels (
  GooCanvas $canvas,
  gdouble $x,
  gdouble $y
)
  is native(goo)
  is export
{ * }

sub goo_canvas_create_cairo_context (GooCanvas $canvas)
  returns cairo_t
  is native(goo)
  is export
{ * }

sub goo_canvas_create_item (GooCanvas $canvas, GooCanvasItemModel $model)
  returns GooCanvasItem
  is native(goo)
  is export
{ * }

sub goo_canvas_get_bounds (
  GooCanvas $canvas,
  gdouble   $left   is rw,
  gdouble   $top    is rw,
  gdouble   $right  is rw,
  gdouble   $bottom is rw
)
  is native(goo)
  is export
{ * }

sub goo_canvas_get_default_line_width (GooCanvas $canvas)
  returns gdouble
  is native(goo)
  is export
{ * }

sub goo_canvas_get_item (GooCanvas $canvas, GooCanvasItemModel $model)
  returns GooCanvasItem
  is native(goo)
  is export
{ * }

sub goo_canvas_get_item_at (
  GooCanvas $canvas,
  gdouble $x,
  gdouble $y,
  gboolean $is_pointer_event
)
  returns GooCanvasItem
  is native(goo)
  is export
{ * }

sub goo_canvas_get_items_at (
  GooCanvas $canvas,
  gdouble $x,
  gdouble $y,
  gboolean $is_pointer_event
)
  returns GList
  is native(goo)
  is export
{ * }

sub goo_canvas_get_items_in_area (
  GooCanvas $canvas,
  GooCanvasBounds $area,
  gboolean $inside_area,
  gboolean $allow_overlaps,
  gboolean $include_containers
)
  returns GList
  is native(goo)
  is export
{ * }

sub goo_canvas_get_root_item (GooCanvas $canvas)
  returns GooCanvasItem
  is native(goo)
  is export
{ * }

sub goo_canvas_set_root_item (GooCanvas $canvas, GooCanvasItem $item)
  is native(goo)
  is export
{ * }

sub goo_canvas_get_type ()
  returns GType
  is native(goo)
  is export
{ * }

sub goo_canvas_grab_focus (GooCanvas $canvas, GooCanvasItem $item)
  is native(goo)
  is export
{ * }

sub goo_canvas_keyboard_grab (
  GooCanvas $canvas,
  GooCanvasItem $item,
  gboolean $owner_events,
  guint32 $time
)
  returns uint32 # GdkGrabStatus
  is native(goo)
  is export
{ * }

sub goo_canvas_keyboard_ungrab (
  GooCanvas $canvas,
  GooCanvasItem $item,
  guint32 $time
)
  is native(goo)
  is export
{ * }

sub goo_canvas_new ()
  returns GooCanvas
  is native(goo)
  is export
{ * }

sub goo_canvas_pointer_grab (
  GooCanvas $canvas,
  GooCanvasItem $item,
  guint $event_mask,
  GdkCursor $cursor,
  guint32 $time
)
  returns uint32 # GdkGrabStatus
  is native(goo)
  is export
{ * }

sub goo_canvas_pointer_ungrab (
  GooCanvas $canvas,
  GooCanvasItem $item,
  guint32 $time
)
  is native(goo)
  is export
{ * }

sub goo_canvas_register_widget_item (
  GooCanvas $canvas,
  GooCanvasWidget $witem
)
  is native(goo)
  is export
{ * }

sub goo_canvas_render (
  GooCanvas $canvas,
  cairo_t $cr,
  GooCanvasBounds $bounds,
  gdouble $scale
)
  is native(goo)
  is export
{ * }

sub goo_canvas_request_item_redraw (
  GooCanvas $canvas,
  GooCanvasBounds $bounds,
  gboolean $is_static
)
  is native(goo)
  is export
{ * }

sub goo_canvas_request_redraw (GooCanvas $canvas, GooCanvasBounds $bounds)
  is native(goo)
  is export
{ * }

sub goo_canvas_scroll_to (GooCanvas $canvas, gdouble $left, gdouble $top)
  is native(goo)
  is export
{ * }

sub goo_canvas_set_bounds (
  GooCanvas $canvas,
  gdouble $left,
  gdouble $top,
  gdouble $right,
  gdouble $bottom
)
  is native(goo)
  is export
{ * }

sub goo_canvas_unregister_item (GooCanvas $canvas, GooCanvasItemModel $model)
  is native(goo)
  is export
{ * }

sub goo_canvas_unregister_widget_item (
  GooCanvas $canvas,
  GooCanvasWidget $witem
)
  is native(goo)
  is export
{ * }

sub goo_canvas_update (GooCanvas $canvas)
  is native(goo)
  is export
{ * }

sub goo_canvas_get_root_item_model (GooCanvas $canvas)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_get_scale (GooCanvas $canvas)
  returns gdouble
  is native(goo)
  is export
{ * }

sub goo_canvas_get_static_root_item (GooCanvas $canvas)
  returns GooCanvasItem
  is native(goo)
  is export
{ * }

sub goo_canvas_get_static_root_item_model (GooCanvas $canvas)
  returns GooCanvasItemModel
  is native(goo)
  is export
{ * }

sub goo_canvas_set_root_item_model (
  GooCanvas $canvas,
  GooCanvasItemModel $model
)
  is native(goo)
  is export
{ * }

sub goo_canvas_set_scale (GooCanvas $canvas, gdouble $scale)
  is native(goo)
  is export
{ * }

sub goo_canvas_set_static_root_item (GooCanvas $canvas, GooCanvasItem $item)
  is native(goo)
  is export
{ * }

sub goo_canvas_set_static_root_item_model (
  GooCanvas $canvas,
  GooCanvasItemModel $model
)
  is native(goo)
  is export
{ * }
