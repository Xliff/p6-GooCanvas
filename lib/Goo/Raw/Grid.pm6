use v6.c;

use NativeCall;

use Pango::Raw::Types;

use Goo::Raw::Types;

unit package Goo::Raw::Grid;

sub goo_canvas_grid_new (
  GooCanvasItemModel $parent,
  gdouble            $x,
  gdouble            $y,
  gdouble            $width,
  gdouble            $height,
  gdouble            $x_step,
  gdouble            $y_step,
  gdouble            $x_offset,
  gdouble            $y_offset,
  Str
)
  returns GooCanvasGrid
  is native(goo)
  is export
{ * }

sub goo_canvas_grid_get_type ()
  returns GType
  is native(goo)
  is export
  { * }
