use v6.c;

use NativeCall;

use Cairo;

use GLib::Roles::Pointers;

unit package Goo::Raw::Definitions;

# Number of times a forced recompile was deemed necessary.
constant forced = 0;

constant goo is export = 'goocanvas-2.0',v9;

class GooCanvas           is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasEllipse    is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasGrid       is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasGroup      is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasImage      is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasItem       is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasItemSimple is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasPath       is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasPolyline   is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasRect       is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasText       is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasTable      is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasWidget     is repr<CPointer> is export does GLib::Roles::Pointers { }

class GooCanvasItemModel  is repr<CPointer> is export does GLib::Roles::Pointers { }
class GooCanvasGroupModel is repr<CPointer> is export does GLib::Roles::Pointers { }

our subset BooleanValue is export where True | False | 1 | 0;

constant cairo_fill_rule_t   is export := Cairo::FillRule;
constant cairo_line_cap_t    is export := Cairo::LineCap;
constant cairo_line_join_t   is export := Cairo::LineJoin;
constant cairo_matrix_t      is export := Cairo::cairo_matrix_t;
constant cairo_pattern_t     is export := Cairo::cairo_pattern_t;
constant cairo_t             is export := Cairo::cairo_t;

our subset CairoContextObject is export of Mu
  where Cairo::Context | cairo_t;
our subset CairoPatternObject is export of Mu
  where Cairo::Pattern | cairo_pattern_t;
our subset CairoMatrixObject  is export of Mu
  where Cairo::Matrix | cairo_matrix_t;

constant GooCairoPattern is export := CairoPatternObject;
