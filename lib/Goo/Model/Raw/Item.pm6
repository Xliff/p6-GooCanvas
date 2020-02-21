use v6.c;

use NativeCall;

use Cairo;

use Goo::Raw::Types;

unit package Goo::Model::Raw::Item;

sub goo_canvas_item_model_add_child (
  GooCanvasItemModel $model,
  GooCanvasItemModel $child,
  gint $position
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_animate (
  GooCanvasItemModel $model,
  gdouble $x,
  gdouble $y,
  gdouble $scale,
  gdouble $degrees,
  gboolean $absolute,
  gint $duration,
  gint $step_time,
  guint $type                   # GooCanvasAnimateType $type
)
  is native(goo)
  is export
  { * }

# sub goo_canvas_item_model_class_find_child_property (
#   GObjectClass $mclass,
#   Str $property_name
# )
#   returns GParamSpec
#   is native(goo)
#   is export
#   { * }
#
# sub goo_canvas_item_model_class_install_child_property (
#   GObjectClass $mclass,
#   guint $property_id,
#   GParamSpec $pspec
# )
#   is native(goo)
#   is export
#   { * }
#
# sub goo_canvas_item_model_class_list_child_properties (
#   GObjectClass $mclass,
#   guint $n_properties
# )
#   returns CArray[GParamSpec]
#   is native(goo)
#   is export
#   { * }

sub goo_canvas_item_model_find_child (
  GooCanvasItemModel $model,
  GooCanvasItemModel $child
)
  returns gint
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_child (
  GooCanvasItemModel $model,
  gint $child_num
)
  returns GooCanvasItemModel
  is native(goo)
  is export
  { * }

# sub goo_canvas_item_model_get_child_properties_valist (
#   GooCanvasItemModel $model,
#   GooCanvasItemModel $child,
#   va_list $var_args
# )
#   is native(goo)
#   is export
#   { * }

sub goo_canvas_item_model_get_child_property (
  GooCanvasItemModel $model,
  GooCanvasItemModel $child,
  Str $property_name,
  GValue $value
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_n_children (GooCanvasItemModel $model)
  returns gint
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_simple_transform (
  GooCanvasItemModel $model,
  gdouble $x,
  gdouble $y,
  gdouble $scale,
  gdouble $rotation
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_transform (
  GooCanvasItemModel $model,
  cairo_matrix_t $transform
)
  returns uint32
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_lower (
  GooCanvasItemModel $model,
  GooCanvasItemModel $below
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_move_child (
  GooCanvasItemModel $model,
  gint $old_position,
  gint $new_position
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_raise (
  GooCanvasItemModel $model,
  GooCanvasItemModel $above
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_remove (GooCanvasItemModel $model)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_remove_child (
  GooCanvasItemModel $model,
  gint $child_num
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_rotate (
  GooCanvasItemModel $model,
  gdouble $degrees,
  gdouble $cx,
  gdouble $cy
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_scale (
  GooCanvasItemModel $model,
  gdouble $sx,
  gdouble $sy
)
  is native(goo)
  is export
  { * }

# sub goo_canvas_item_model_set_child_properties_valist (
#   GooCanvasItemModel $model,
#   GooCanvasItemModel $child,
#   va_list $var_args
# )
#   is native(goo)
#   is export
#   { * }

sub goo_canvas_item_model_set_child_property (
  GooCanvasItemModel $model,
  GooCanvasItemModel $child,
  Str $property_name,
  GValue $value
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_set_simple_transform (
  GooCanvasItemModel $model,
  gdouble $x,
  gdouble $y,
  gdouble $scale,
  gdouble $rotation
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_set_transform (
  GooCanvasItemModel $model,
  cairo_matrix_t $transform
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_skew_x (
  GooCanvasItemModel $model,
  gdouble $degrees,
  gdouble $cx,
  gdouble $cy
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_skew_y (
  GooCanvasItemModel $model,
  gdouble $degrees,
  gdouble $cx,
  gdouble $cy
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_stop_animation (GooCanvasItemModel $model)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_translate (
  GooCanvasItemModel $model,
  gdouble $tx,
  gdouble $ty
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_parent (GooCanvasItemModel $model)
  returns GooCanvasItemModel
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_get_style (GooCanvasItemModel $model)
  returns GooCanvasStyle
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_set_parent (
  GooCanvasItemModel $model,
  GooCanvasItemModel $parent
)
  is native(goo)
  is export
  { * }

sub goo_canvas_item_model_set_style (
  GooCanvasItemModel $model,
  GooCanvasStyle $style
)
  is native(goo)
  is export
  { * }
