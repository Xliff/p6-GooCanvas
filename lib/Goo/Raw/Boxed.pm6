use NativeCall;

use GTK::Compat::Types;
use Goo::Raw::Types;

class Goo::Raw::Boxed {

  method pattern_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Pattern',
      &goo_cairo_pattern_get_type,
      $n, $t
    );
  }

  method fill_rule_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.FillRule',
      &goo_cairo_fill_rule_get_type,
      $n, $t
    );
  }

  method operator_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Operator',
      &goo_cairo_operator_get_type,
      $n, $t
    );
  }

  method antialias_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.AntiAlias',
      &goo_cairo_antialias_get_type,
      $n, $t
    );
  }

  method line_cap_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Line_Cap',
      &goo_cairo_line_cap_get_type,
      $n, $t
    );
  }

  method line_join_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Line_Join',
      &goo_cairo_line_join_get_type,
      $n, $t
    );
  }

  method hint_metrics_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Hint_Metrics',
      &goo_cairo_hint_metrics_get_type,
      $n, $t
    );
  }

  method line_dash_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Line_Dash',
      &goo_canvas_line_dash_get_type,
      $n, $t
    );
  }

  method matrix_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Matrix',
      &goo_cairo_matrix_get_type,
      $n, $t
    );
  }

  method bounds_get_type {
    state ($n, $t);
    unstable_get_type(
      ::?CLASS.^name ~ '.Bounds',
      &goo_canvas_bounds_get_type,
      $n, $t
    );
  }

}

sub goo_cairo_pattern_get_type (void)
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_fill_rule_get_type (void)
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_operator_get_type (void)
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_antialias_get_type (void)
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_line_cap_get_type ()
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_line_join_get_type ()
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_hint_metrics_get_type ()
  returns GType
  is native(goo)
  is export
{ * }

sub goo_canvas_line_dash_get_type ()
  returns GType
  is native(goo)
  is export
{ * }

sub goo_cairo_matrix_get_type ()
  returns GType
  is native(goo)
  is export
{ * }

sub goo_canvas_bounds_get_type ()
  returns GType
  is native(goo)
  is export
{ * }
