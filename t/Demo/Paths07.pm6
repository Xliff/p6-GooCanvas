use v6.c;

use Cairo;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::ScrolledWindow;

use Goo::Canvas;

use Goo::Model::Group;

my (%data, %globals, $app, $path1);

our subset ObjectOrPointer of Mu where * ~~ (
  GLib::Roles::Object,
  GTK::Roles::Pointers,
  GTK::Roles::Properties
).any;

sub get-data (ObjectOrPointer $i is copy, $k) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GLib::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k};
}
sub set-data (ObjectOrPointer $i is copy, $k, $v) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GLib::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k} = $v;
}

sub background-button-press ($item, $target, $event, $r) {
  CATCH { default { .message.say; $app.exit } }

  say "Button Press Item: { get-data($target, 'id') }" if $target.defined;

  my $b_event = cast(GdkEventButton, $event);
  my $canvas = $item.canvas;
  my $i = $canvas.get_items_at($b_event.x_root, $b_event.y_root, :raw);
  $i .= grep( *.defined );
  say "  clicked items: { $i.map({ get-data($_, 'id') }).join(', ')}"
    if $i.elems;

  $r.r = 1;
}

sub setup-canvas ($canvas) {
  my $root = %globals<model-mode> ??
    Goo::Model::Group.new !! $canvas.get_root_item;
  $canvas.root-item-model = $root if %globals<model-mode>;

  # Could use |@a[1,2,4] but want people to get used to the idiom of using
  # the LAST element of @a.
  $root.button-press-event.tap(-> *@a {
    background-button-press($root, |@a[1, 2, *-1]);
  }) unless %globals<model-mode>;

  # Test th simple commands like moveto and lineto: MmZzLlHhVv.
  my $count = 0;
  set-data($_, 'id', "Line #{ $count++ }") for (
    $path1 = %globals<path-obj>.new($root, 'M 20 20 L 40 40'),
             %globals<path-obj>.new($root, 'M30 20 l20, 20'),
             %globals<path-obj>.new($root, 'M 60 20 H 80'),
             %globals<path-obj>.new($root, 'M60 40 h20'),
             %globals<path-obj>.new($root, 'M 100,20 V 40'),
             %globals<path-obj>.new($root, 'M 120 20 v 20'),
             %globals<path-obj>.new($root, 'M 140 20 h20 v20 h-20 z')
  );
  $path1.line-width = 4;

  with %globals<path-obj>.new($root, 'M 180 20 h20 v20 h-20 z m 5,5 h10 v10 h-10 z') {
    .fill-color = 'red'; .fill-rule = FILL_RULE_EVEN_ODD;
    set-data($_, 'id', "Line #{ $count++ }");
  }

  with %globals<path-obj>.new($root, 'M 220 20 L 260 20 L 240 40 z') {
    .fill-color = 'red'; .stroke-color = 'blue'; .line-width = 3;
    set-data($_, 'id', "Line #{ $count++ }")
  }

  # Test the bezier curve commands: CcSsQqTt.
  $count = 0;
  set-data($_, 'id', "Curve #{ $count++ }") for (
    %globals<path-obj>.new($root, 'M20,100 C20,50 100,50 100,100 S180,150 180,100'),
    %globals<path-obj>.new($root, 'M220,100 c0,-50 80,-50 80,0 s80,50 80,0'),
	  %globals<path-obj>.new($root, 'M20,200 Q60,130 100,200 T180,200'),
    %globals<path-obj>.new($root, 'M220,200 q40,-70 80,0 t80,0')
  );

  # Test the elliptical arc commands: Aa.
  $count = 0;
  with %globals<path-obj>.new($root, 'M200,500 h-150 a150,150 0 1,0 150,-150 z') {
    .fill-color = 'red';    .stroke-color = 'blue'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }
  with %globals<path-obj>.new($root, 'M175,475 v-150 a150,150 0 0,0 -150,150 z') {
    .fill-color = 'yellow'; .stroke-color = 'blue'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }
  with %globals<path-obj>.new($root, q:to/PATH/)
M400,600 l 50,-25
a25,25 -30 0,1 50,-25 l 50,-25
a25,50 -30 0,1 50,-25 l 50,-25
a25,75 -30 0,1 50,-25 l 50,-25
a25,100 -30 0,1 50,-25 l 50,-25
PATH
  {
    .stroke-color = 'red'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }

  with %globals<path-obj>.new($root, 'M 525,75 a100,50 0 0,0 100,50') {
    .stroke-color = 'red'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }
  with %globals<path-obj>.new($root, 'M 725,75 a100,50 0 0,1 100,50') {
    .stroke-color = 'red'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }
  with %globals<path-obj>.new($root, 'M 525,200 a100,50 0 1,0 100,50') {
    .stroke-color = 'red'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }
  with %globals<path-obj>.new($root, 'M 725,200 a100,50 0 1,1 100,50') {
    .stroke-color = 'red'; .line-width = 5;
    set-data($_, 'id', "Arc #{ $count++ }")
  }
}

sub move-path-clicked {
  state $count = 0;

  $path1.data = do given $count++ % 3 {
    when 0 { 'M130, 70 L317, 70' }
    when 1 { 'M130,170 L317,170' }
    when 2 { 'M130,270 L317,270' }
  }
}

sub create-paths-page {
  my $vbox = GTK::Box.new-vbox(4);
  my $hbox = GTK::Box.new-hbox(4);
  $vbox.pack_start($hbox);

  my $sw = GTK::ScrolledWindow.new;
  $sw.shadow_type = GTK_SHADOW_IN;
  $sw.halign  = $sw.valign  = GTK_ALIGN_FILL;
  $sw.hexpand = $sw.vexpand = True;
  $vbox.pack_start($sw);

  my $canvas = Goo::Canvas.new;
  $canvas.set_size_request(600, 450);
  $canvas.set_bounds(0, 0, 1000, 1000);
  $sw.add($canvas);
  $sw.set_size_request(600, 450);
  setup-canvas($canvas);

  my $b = GTK::Button.new_with_label('Move Path');
  $hbox.pack_start($b);
  $b.clicked.tap(-> *@a { move-path-clicked });

  $vbox;
}

sub setupObjects ($path-obj) is export {
  %globals<path-obj>   = $path-obj;
  %globals<model-mode> = $path-obj.^name.contains('::Model');
}

sub Paths_07_MAIN ($path-obj) is export {
  $app = GTK::Application.new( title => 'org.genex.goo.paths' );

  setupObjects($path-obj);

  $app.activate.tap({
    $app.window.set-size-request(800, 600);
    $app.window.add(create-paths-page);
    $app.window.show_all;
  });

  $app;
}
