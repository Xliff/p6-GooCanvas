use v6.c;

use NativeCall;


use Goo::Raw::Types;

unit package Goo::Raw::Points;

sub goo_canvas_points_get_type ()
  returns GType
  is native(goo)
  is export
  { * }

sub goo_canvas_points_new (gint $num_points)
  returns GooCanvasPoints
  is native(goo)
  is export
  { * }

sub goo_canvas_points_ref (GooCanvasPoints $points)
  returns Pointer
  is native(goo)
  is export
  { * }

sub goo_canvas_points_unref (GooCanvasPoints $points)
  is native(goo)
  is export
  { * }

sub goo_canvas_points_set_point(
  GooCanvasPoints $points,
  gint    $idx,
  gdouble $x,
  gdouble $y
)
  is native(goo)
  is export
  { * }

sub goo_canvas_points_get_point(
  GooCanvasPoints $points,
  gint    $idx,
  gdouble $x is rw,
  gdouble $y is rw
)
  is native(goo)
  is export
  { * }
