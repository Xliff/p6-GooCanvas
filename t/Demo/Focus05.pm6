use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Label;
use GTK::ScrolledWindow;

use Goo::Canvas;
use Goo::CanvasItemSimple;

use Goo::Model::Group;

my (%globals, %data, $app);

sub get-data (GObject() $i, $k) {
  %data{+$i.p}{$k};
}
sub set-data (GObject() $i, $k, $v) {
  %data{+$i.p}{$k} = $v;
}

sub on_focus_in ($item, $r) {
  CATCH { default { .message.say; $app.exit } }

  my $i = $item;
  $i .= model if %globals<model-mode>;
  my $id = get-data($i, 'id');

  say "{ $id // '<unknown>' } received focus-in event";
  $i.stroke-color = 'black';
  $i.line-width = 5;
  $r.r = 0
}

sub on_focus_out ($item, $r) {
  CATCH { default { .message.say; $app.exit } }

  my $i = $item;
  $i .= model if %globals<model-mode>;
  my $id = get-data($i, 'id');

  say "{ $id // '<unknown>' } received focus-out event";

  # Do NOT know the proper way this is supposed to work. :/
  # Using line with to denote selection, instead.
  #$item.stroke-pattern = cairo_pattern_t;

  $i.line-width = 2;
  $r.r = 0;
}

sub on_button_press ($item, $r) {
  CATCH { default { .message.say; $app.exit } }

  my $i = $item;
  $i .= model if %globals<model-mode>;
  my $id = get-data($i, 'id');

  say "{ $id // 'unknwon' } received button-press event";
  $item.canvas.grab_focus($item);
  $r.r = 1;
}

sub on_key_press ($item, $r) {
  CATCH { default { .message.say; $app.exit } }

  my $i = $item;
  $i .= model if %globals<model-mode>;
  my $id = get-data($i, 'id');

  say "{ $id // 'unknown' } received key-press event";
  $r.r = 0;
}

sub on-item-created($item, $m) {
  CATCH { default { .message.say; $app.exit } }

  return unless %globals<rect-obj>.is_type($m);
  $item.focus-in-event.tap(->     *@a { on_focus_in(    $item, @a[*-1] ) });
  $item.focus-out-event.tap(->    *@a { on_focus_out(   $item, @a[*-1] ) });
  $item.button-press-event.tap(-> *@a { on_button_press($item, @a[*-1] ) });
  $item.key-press-event.tap(->    *@a { on_key_press(   $item, @a[*-1] ) });
}

sub create_focus_box ($can, $x, $y, $w, $h, $c) {
  my $root = %globals<model-mode> ??
    $can.root_item_model!! $can.root_item;

  my $item = %globals<rect-obj>.new($root, $x, $y, $w, $h);
  #$item.stroke-pattern = CairoPatternObject;
  $item.fill-color = $c;
  $item.line-width = 2;
  $item.can-focus  = True;
  set-data($item, 'id', $c);

  unless %globals<model-mode> {
    $item.focus-in-event.tap(->     *@a { on_focus_in(    $item, @a[*-1] ) });
    $item.focus-out-event.tap(->    *@a { on_focus_out(   $item, @a[*-1] ) });
    $item.button-press-event.tap(-> *@a { on_button_press($item, @a[*-1] ) });
    $item.key-press-event.tap(->    *@a { on_key_press(   $item, @a[*-1] ) });
  }
}

sub setup_canvas($canvas) {
  $canvas.root-item-model = Goo::Model::Group.new if %globals<model-mode>;

  create_focus_box($canvas, |@( .[^2] ), 50, 30, .[2]) for (
    [ 110,  80, 'red'      ],
    [ 300, 160, 'orange'   ],
    [ 500,  50, 'yellow'   ],
    [  70, 400, 'blue'     ],
    [ 130, 200, 'magenta'  ],
    [ 200, 100, 'green'    ],
    [ 450, 450, 'cyan'     ],
    [ 300, 350, 'grey'     ],
    [ 900, 900, 'gold'     ],
    [ 800, 150, 'thistle'  ],
    [ 600, 800, 'azure'    ],
    [ 700, 250, 'moccasin' ],
    [ 500, 100, 'cornsilk' ],
    [ 200, 750, 'plum'     ],
    [ 400, 800, 'orchid'   ]
  );
}

sub create_focus {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  my $l = GTK::Label.new(q:to/LABEL/.chomp);
Shift+Tab or the arrow keys to move the keyboard focus between the canvas items.
LABEL

  $vbox.pack_start($l);

  my $sw = GTK::ScrolledWindow.new;
  $sw.shadow_type = GTK_SHADOW_IN;
  $sw.halign  = $sw.valign  = GTK_ALIGN_FILL;
  $sw.hexpand = $sw.vexpand = True;
  $vbox.pack_start($sw);

  my $canvas = Goo::Canvas.new;
  $canvas.can_focus = True;
  $canvas.set_size_request(600, 450);
  $canvas.set_bounds(0, 0, 1000, 1000);
  $sw.add($canvas);
  $sw.set_size_request(600, 450);

  $canvas.item-created.tap(-> *@a {
    CATCH { default { .message.say } }
    on-item-created( Goo::CanvasItemSimple.new( @a[1] ), @a[2] );
  }) if %globals<model-mode>;

  setup_canvas($canvas);

  $vbox;
}

sub setupObjects($rect-obj) is export {
  %globals<rect-obj>   = $rect-obj;
  %globals<model-mode> = $rect-obj.^name.contains('::Model');
}

sub Focus_05_MAIN($rect-obj) is export {
  $app = GTK::Application.new( title => 'org.genex.goo.fifteen' );

  setupObjects($rect-obj);

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.add(create_focus);
    $app.window.show_all;
  });

  $app;
}
