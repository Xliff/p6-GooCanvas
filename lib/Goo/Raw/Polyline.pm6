use v6.c;

use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

unit package Goo::Raw::Polyline;

sub goo_canvas_polyline_new (
  GooCanvasItem $parent,
  gboolean $close_path,
  gint $num_points,
  Str
)
  returns GooCanvasPolyline
  is native(goo)
  is export
  { * }

sub goo_canvas_polyline_new_line (
  GooCanvasItem $parent,
  gdouble       $x1,
  gdouble       $y1,
  gdouble       $x2,
  gdouble       $y2,
  Str
)
  returns GooCanvasPolyline
  is native(goo)
  is export
  { * }

sub goo_canvas_polyline_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_points_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_points_ref (GooCanvasPoints $points)
  returns GooCanvasPoints
  is native(goo)
  is export
  { * }

sub goo_canvas_points_set_point (
  GooCanvasPoints $points,
  gint $idx,
  gdouble $x, 
  gdouble $y
)
  is native(goo)
  is export
  { * }

sub goo_canvas_polyline_model_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
