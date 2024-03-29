use v6.c;

use Method::Also;

use Cairo;

use Goo::Raw::Types;
use Goo::Raw::CanvasItem;

use GLib::Value;
use Goo::Model::Simple;

use GLib::Roles::Object;
use Goo::Roles::Signals::CanvasItem;

our subset GooCanvasItemAncestry is export of Mu
  where GooCanvasItem | GObject;

role Goo::Roles::CanvasItem {
  also does GLib::Roles::Object;
  also does Goo::Roles::Signals::CanvasItem;

  has GooCanvasItem $!ci;

  method setCanvasItem (GooCanvasItemAncestry $_) {
    #self.IS-PROTECTED;
    my $to-parent;
    $!ci = do {
      when GooCanvasItem {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GooCanvasItem, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Goo::Raw::Definitions::GooCanvasItem
    # is also<
    #   CanvasItem
    #   GooCanvasItem
    # >
  { $!ci }

  # These are here due to a bug in rakudo and Method::Also, please remove
  # them, when rectified.
  method CanvasItem    { $!ci }
  method GooCanvasItem { $!ci }

  # Is originally:
  # GooCanvasItem, gboolean, gpointer --> void
  method animation-finished is also<animation_finished> {
    self.connect-uint($!ci, 'animation-finished');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method button-press-event is also<button_press_event> {
    self.connect-canvas-event($!ci, 'button-press-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method button-release-event is also<button_release_event> {
    self.connect-canvas-event($!ci, 'button-release-event');
  }

  # Is originally:
  # GooCanvasItem, GParamSpec, gpointer --> void
  method child-notify is also<child_notify> {
    self.connect-gparam($!ci, 'child-notify');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method enter-notify-event is also<enter_notify_event> {
    self.connect-canvas-event($!ci, 'enter-notify-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method focus-in-event is also<focus_in_event> {
    self.connect-canvas-event($!ci, 'focus-in-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method focus-out-event is also<focus_out_event> {
    self.connect-canvas-event($!ci, 'focus-out-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method grab-broken-event is also<grab_broken_event> {
    self.connect-canvas-event($!ci, 'grab-broken-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method key-press-event is also<key_press_event> {
    self.connect-canvas-event($!ci, 'key-press-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method key-release-event is also<key_release_event> {
    self.connect-canvas-event($!ci, 'key-release-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method leave-notify-event is also<leave_notify_event> {
    self.connect-canvas-event($!ci, 'leave-notify-event');
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method motion-notify-event is also<motion_notify_event> {
    self.connect-canvas-event($!ci, 'motion-notify-event');
  }

  # Is originally:
  # GooCanvasItem, gdouble, gdouble, gboolean, GtkTooltip, gpointer --> gboolean
  method query-tooltip is also<query_tooltip> {
    self.connect-query-tooltip($!ci);
  }

  # Is originally:
  # GooCanvasItem, GooCanvasItem, GdkEvent, gpointer --> gboolean
  method scroll-event is also<scroll_event> {
    self.connect-canvas-event($!ci, 'scroll-event');
  }

  method canvas (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $c = goo_canvas_item_get_canvas($!ci);

        $c ??
          ( $raw ?? $c !! ::('Goo::Canvas').new($c) )
          !!
          Nil;
      },
      STORE => sub ($, GooCanvas() $canvas is copy) {
        goo_canvas_item_set_canvas($!ci, $canvas);
      }
    );
  }

  method is_static is rw is also<is-static> {
    Proxy.new(
      FETCH => sub ($) {
        so goo_canvas_item_get_is_static($!ci);
      },
      STORE => sub ($, Int() $is_static is copy) {
        my gboolean $i = $is_static.so.Int;

        goo_canvas_item_set_is_static($!ci, $i);
      }
    );
  }

  method style is rw {
    Proxy.new(
      FETCH => sub ($) {
        goo_canvas_item_get_style($!ci);
      },
      STORE => sub ($, GooCanvasStyle $style is copy) {
        goo_canvas_item_set_style($!ci, $style);
      }
    );
  }

  # Type: gboolean
  method can-focus is rw  {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('can-focus', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('can-focus', $gv);
      }
    );
  }

  # Type: gchar
  method description is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('description', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('description', $gv);
      }
    );
  }

  # Type: GooCanvasPointerEvents
  method pointer-events is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('pointer-events', $gv)
        );
        GooCanvasPointerEventsEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('pointer-events', $gv);
      }
    );
  }

  # Type: gchar
  method title is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('title', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('title', $gv);
      }
    );
  }

  # Type: gchar
  method tooltip is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tooltip', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('tooltip', $gv);
      }
    );
  }

  # Type: GooCairoMatrix
  method transform (:$raw = False) is rw  {
    my GLib::Value $gv .= new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('transform', $gv)
        );

        return cairo_matrix_t unless $gv.pointer;

        my $m = cast(cairo_matrix_t, $gv.pointer);

        $raw ?? $m !! Cairo::Matrix.new($m);
      },
      STORE => -> $, CairoMatrixObject $val is copy {
        $val .= matrix if $val ~~ Cairo::Matrix;
        $gv.pointer = $val;
        self.prop_set('transform', $gv);
      }
    );
  }

  # Type: GooCanvasItemVisibility
  method visibility is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('visibility', $gv)
        );
        GooCanvasItemVisibilityEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('visibility', $gv);
      }
    );
  }

  # Type: gdouble
  method visibility-threshold is also<visibility_threshold> is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('visibility-threshold', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('visibility-threshold', $gv);
      }
    );
  }

  method add_child (GooCanvasItem() $child, Int() $position = -1)
    is also<add-child>
  {
    my gint $p = $position;

    goo_canvas_item_add_child($!ci, $child, $p);
  }

  method allocate_area (
    CairoContextObject $cr is copy,
    GooCanvasBounds()  $requested_area,
    GooCanvasBounds()  $allocated_area,
    Num() $x_offset,
    Num() $y_offset
  )
    is also<allocate-area>
  {
    my gdouble ($xo, $yo) = ($x_offset, $y_offset);

    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_allocate_area(
      $!ci,
      $cr,
      $requested_area,
      $allocated_area,
      $xo,
      $yo
    );
  }

  method animate (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $degrees,
    Int() $absolute,
    Int() $duration,
    Int() $step_time,
    Int() $type
  ) {
    my gdouble ($xx, $yy, $s, $d) = ($x, $y, $scale, $degrees);
    my gint    ($dur, $st)        = ($duration, $step_time);

    my guint    $t = $type;
    my gboolean $a = $absolute.so.Int;

    goo_canvas_item_animate($!ci, $xx, $yy, $s, $d, $a, $dur, $st, $t);
  }

  method ensure_updated is also<ensure-updated> {
    goo_canvas_item_ensure_updated($!ci);
  }

  method find_child (GooCanvasItem() $child) is also<find-child> {
    goo_canvas_item_find_child($!ci, $child);
  }

  proto method get_bounds (|)
    is also<get-bounds>
  { * }

  multi method get_bounds is also<bounds> {
    my $b = GooCanvasBounds.new;
    self.get_bounds($b);
    $b;
  }
  multi method get_bounds (GooCanvasBounds() $bounds)  {
    goo_canvas_item_get_bounds($!ci, $bounds);
  }

  method get_child (Int() $child_num) is also<get-child> {
    my gint $c = $child_num;

    goo_canvas_item_get_child($!ci, $c);
  }

  method get_child_property (
    GooCanvasItem() $child,
    Str() $property_name,
    GValue() $value
  )
    is also<get-child-property>
  {
    goo_canvas_item_get_child_property($!ci, $child, $property_name, $value);
  }

  proto method get_items_at
    is also<get-items-at>
  { * }

  multi method get_items_at (
    Num()               $x,
    Num()               $y,
    CairoContextObject  $cr                  is copy,
    Int()               $is_pointer_event,
    Int()               $parent_is_visible,
                       :$glist                        = False;
                       :$raw                          = False
  ) {
    my $fi = GList.new;

    samewith(
      $x,
      $y,
      $cr,
      $is_pointer_event,
      $parent_is_visible,
      GList,
      :$glist,
      :$raw
    );
  }
  multi method get_items_at (
    Num()               $x,
    Num()               $y,
    CairoContextObject  $cr                  is copy,
    Int()               $is_pointer_event,
    Int()               $parent_is_visible,
    GList()             $found_items,
                       :$glist                        = False,
                       :$raw                          = False
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    my gboolean ($i, $p) =
      ($is_pointer_event, $parent_is_visible).map( *.so.Int );

    $cr .= context if $cr ~~ Cairo::Context;
    my $cil = goo_canvas_item_get_items_at(
      $!ci,
      $x,
      $y,
      $cr,
      $i,
      $p,
      $found_items
    );

    return GList unless $cil;
    return $cil  if $glist;

    my $l = GLib::List.new($cil) but GLib::Roles::ListData[GooCanvasItem];
    $raw ?? $l.Array !! $l.Array.map({ Goo::CanvasItem.new($_) });
  }

  method get_model (:$raw = False)
    is also<
      get-model
      model
    >
  {
    my $sm = goo_canvas_item_get_model($!ci);

    $sm ??
      ( $raw ?? $sm !! Goo::Model::Simple.new($sm) )
      !!
      GooCanvasItemModel;
  }

  method get_n_children is also<
    get-n-children
    n_children
    n-children
    elems
  > {
    goo_canvas_item_get_n_children($!ci);
  }

  method get_parent (:$raw = False)
    is also<
      get-parent
      parent
    >
  {
    # Determine a method that will allow an object to keep a copy of its
    # parent for the lifetime of the actual backing pointer.
    my $p = goo_canvas_item_get_parent($!ci);

    $p ??
      ( $raw ?? $p !! ::('Goo::CanvasItem').new($p) )
      !!
      Nil;
  }

  method get_requested_area (
    CairoContextObject $cr             is copy,
    GooCanvasBounds()  $requested_area
  )
    is also<get-requested-area>
  {
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_requested_area($!ci, $cr, $requested_area);
  }

  method get_requested_area_for_width (
    CairoContextObject $cr              is copy,
    Num()              $width,
    GooCanvasBounds()  $requested_area
  )
    is also<get-requested-area-for-width>
  {
    my gdouble $w = $width;

    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_requested_area_for_width(
      $!ci,
      $cr,
      $w,
      $requested_area
    );
  }

  method get_requested_height (
    CairoContextObject $cr    is copy,
    Num()              $width
  )
    is also<get-requested-height>
  {
    my gdouble $w = $width;

    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_get_requested_height($!ci, $cr, $w);
  }

  proto method get_simple_transform (|)
    is also<get-simple-transform>
  { * }

  multi method get_simple_transform {
    samewith($, $, $, $);
  }
  multi method get_simple_transform (
    $x        is rw,
    $y        is rw,
    $scale    is rw,
    $rotation is rw
  ) {
    my gdouble ($xx, $yy, $s, $r) = 0e0 xx 4;

    goo_canvas_item_get_simple_transform($!ci, $xx, $yy, $s, $r);
    ($x, $y, $scale, $rotation) = ($xx, $yy, $s, $r);
  }

  method get_transform (CairoMatrixObject $transform is copy)
    is also<get-transform>
  {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_get_transform($!ci, $transform);
  }

  method get_transform_for_child (
    GooCanvasItem()   $child,
    CairoMatrixObject $transform
  )
    is also<get-transform-for-child>
  {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_get_transform_for_child($!ci, $child, $transform);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_item_get_type, $n, $t );
  }

  method goo_canvas_bounds_get_type is also<goo-canvas-bounds-get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &goo_canvas_bounds_get_type, $n, $t );
  }

  method is_visible is also<is-visible> {
    so goo_canvas_item_is_visible($!ci);
  }

  method lower (GooCanvasItem() $below) {
    goo_canvas_item_lower($!ci, $below);
  }

  method move_child (Int() $old_position, Int() $new_position)
    is also<move-child>
  {
    my gint ($op, $np) = ($old_position, $new_position);

    goo_canvas_item_move_child($!ci, $op, $np);
  }

  method paint (
    CairoContextObject $cr      is copy,
    GooCanvasBounds()  $bounds,
    Num()              $scale
  ) {
    my gdouble $s = $scale;
    $cr .= context if $cr ~~ Cairo::Context;
    goo_canvas_item_paint($!ci, $cr, $bounds, $s);
  }

  method raise (GooCanvasItem() $above) {
    goo_canvas_item_raise($!ci, $above);
  }

  method remove {
    goo_canvas_item_remove($!ci);
  }

  method remove_child (Int() $child_num) is also<remove-child> {
    my gint $c = $child_num;

    goo_canvas_item_remove_child($!ci, $c);
  }

  method request_update is also<request-update> {
    goo_canvas_item_request_update($!ci);
  }

  method rotate (Num() $degrees, Num() $cx, Num() $cy) {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);

    goo_canvas_item_rotate($!ci, $d, $cxx, $cyy);
  }

  method scale (Num() $sx, Num() $sy) {
    my gdouble ($sxx, $syy) = ($sx, $sy);

    goo_canvas_item_scale($!ci, $sxx, $syy);
  }

  proto method set_child_property (|)
    is also<set-child-property>
  { * }

  multi method set_child_property (
    GooCanvasItem() $child,
    Str()           $property_name,
    GValue()        $value
  ) {
    goo_canvas_item_set_child_property($!ci, $child, $property_name, $value);
  }

  method set_simple_transform (
    Num() $x,
    Num() $y,
    Num() $scale,
    Num() $rotation
  )
    is also<set-simple-transform>
  {
    my gdouble ($xx, $yy, $s, $r) = ($x, $y, $scale, $rotation);

    goo_canvas_item_set_simple_transform($!ci, $xx, $yy, $s, $r);
  }

  method set_transform (CairoMatrixObject $transform) is also<set-transform> {
    $transform .= matrix if $transform ~~ Cairo::Matrix;
    goo_canvas_item_set_transform($!ci, $transform);
  }

  method skew_x (Num() $degrees, Num() $cx, Num() $cy) is also<skew-x> {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);

    goo_canvas_item_skew_x($!ci, $degrees, $cx, $cy);
  }

  method skew_y (Num() $degrees, Num() $cx, Num() $cy) is also<skew-y> {
    my gdouble ($d, $cxx, $cyy) = ($degrees, $cx, $cy);

    goo_canvas_item_skew_y($!ci, $degrees, $cx, $cy);
  }

  method stop_animation is also<stop-animation> {
    goo_canvas_item_stop_animation($!ci);
  }

  method translate (Num() $tx, Num() $ty) {
    my gdouble ($txx, $tyy) = ($tx, $ty);

    goo_canvas_item_translate($!ci, $txx, $tyy);
  }

}
