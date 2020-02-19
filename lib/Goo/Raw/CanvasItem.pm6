use v6.c;

use NativeCall;


use Goo::Raw::Types;

unit package Goo::Raw::CanvasItem;

sub goo_canvas_item_add_child (
  GooCanvasItem $item,
  GooCanvasItem $child,
  gint $position
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_allocate_area (
  GooCanvasItem $item,
  cairo_t $cr,
  GooCanvasBounds $requested_area,
  GooCanvasBounds $allocated_area,
  gdouble $x_offset,
  gdouble $y_offset
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_animate (
  GooCanvasItem $item,
  gdouble $x,
  gdouble $y,
  gdouble $scale,
  gdouble $degrees,
  gboolean $absolute,
  gint $duration,
  gint $step_time,
  uint32 $type                      # GooCanvasAnimateType $type
)
  is native(goo)
  is export
  { * }

# sub goo_canvas_item_class_find_child_property (
#   GObjectClass $iclass,
#   Str $property_name
# )
#   returns GParamSpec
#   is native(goo)
#   is export
#   { * }

# sub goo_canvas_item_class_install_child_property (
#   GObjectClass $iclass,
#   guint $property_id,
#   GParamSpec $pspec
# )
#   is native(goo)
#   is export
#   { * }
#
# sub goo_canvas_item_class_list_child_properties (
#   GObjectClass $iclass,
#   guint $n_properties
# )
#   returns CArray[GParamSpec]
#   is native(goo)
#   is export
#   { * }

sub goo_canvas_item_ensure_updated (GooCanvasItem $item)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_find_child (GooCanvasItem $item, GooCanvasItem $child)
  returns gint
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_bounds (GooCanvasItem $item, GooCanvasBounds $bounds)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_child (GooCanvasItem $item, gint $child_num)
  returns GooCanvasItem
  is native(goo)
  is export
  { * }

# sub goo_canvas_item_get_child_properties_valist (
#   GooCanvasItem $item,
#   GooCanvasItem $child,
#   va_list $var_args
# )
#   is native(goo)
#   is export
#   { * }

sub goo_canvas_item_get_child_property (
  GooCanvasItem $item,
  GooCanvasItem $child,
  Str $property_name,
  GValue $value
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_items_at (
  GooCanvasItem $item,
  gdouble $x,
  gdouble $y,
  cairo_t $cr,
  gboolean $is_pointer_event,
  gboolean $parent_is_visible,
  GList $found_items
)
  returns GList
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_model (GooCanvasItem $item)
  returns GooCanvasItemModel
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_n_children (GooCanvasItem $item)
  returns gint
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_parent (GooCanvasItem $item)
  returns GooCanvasItem
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_requested_area (
  GooCanvasItem $item,
  cairo_t $cr,
  GooCanvasBounds $requested_area
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_requested_area_for_width (
  GooCanvasItem $item,
  cairo_t $cr,
  gdouble $width,
  GooCanvasBounds $requested_area
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_requested_height (
  GooCanvasItem $item,
  cairo_t $cr,
  gdouble $width
)
  returns gdouble
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_simple_transform (
  GooCanvasItem $item,
  gdouble $x,
  gdouble $y,
  gdouble $scale,
  gdouble $rotation
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_transform (
  GooCanvasItem $item,
  cairo_matrix_t $transform
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_transform_for_child (
  GooCanvasItem $item,
  GooCanvasItem $child,
  cairo_matrix_t $transform
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_bounds_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_item_is_visible (GooCanvasItem $item)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_lower (GooCanvasItem $item, GooCanvasItem $below)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_move_child (
  GooCanvasItem $item,
  gint $old_position,
  gint $new_position
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_paint (
  GooCanvasItem $item,
  cairo_t $cr,
  GooCanvasBounds $bounds,
  gdouble $scale
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_raise (GooCanvasItem $item, GooCanvasItem $above)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_remove (GooCanvasItem $item)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_remove_child (GooCanvasItem $item, gint $child_num)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_request_update (GooCanvasItem $item)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_rotate (
  GooCanvasItem $item,
  gdouble $degrees,
  gdouble $cx,
  gdouble $cy
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_scale (GooCanvasItem $item, gdouble $sx, gdouble $sy)
  is native(goo)
  is export
  { * }

# sub goo_canvas_item_set_child_properties_valist (
#   GooCanvasItem $item,
#   GooCanvasItem $child,
#   va_list $var_args
# )
#   is native(goo)
#   is export
#   { * }

sub goo_canvas_item_set_child_property (
  GooCanvasItem $item,
  GooCanvasItem $child,
  Str $property_name,
  GValue $value
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_set_simple_transform (
  GooCanvasItem $item,
  gdouble $x,
  gdouble $y,
  gdouble $scale,
  gdouble $rotation
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_set_transform (
  GooCanvasItem $item,
  cairo_matrix_t $transform
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_skew_x (
  GooCanvasItem $item,
  gdouble $degrees,
  gdouble $cx,
  gdouble $cy
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_skew_y (
  GooCanvasItem $item,
  gdouble $degrees,
  gdouble $cx,
  gdouble $cy
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_stop_animation (GooCanvasItem $item)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_translate (GooCanvasItem $item, gdouble $tx, gdouble $ty)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_canvas (GooCanvasItem $item)
  returns GooCanvas
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_is_static (GooCanvasItem $item)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_get_style (GooCanvasItem $item)
  returns GooCanvasStyle
  is native(goo)
  is export
  { * }

sub goo_canvas_item_set_canvas (GooCanvasItem $item, GooCanvas $canvas)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_set_is_static (GooCanvasItem $item, gboolean $is_static)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_set_style (GooCanvasItem $item, GooCanvasStyle $style)
  is native(goo)
  is export
  { * }
