use v6.c;

use Goo::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Frame;
use GTK::Label;

use Goo::Canvas;
use Goo::CanvasItemSimple;

use Goo::Model::Group;

use GLib::Roles::Object;
use GLib::Roles::Pointers;

my ($app, %data, %globals);

unit package Demo::Reparenting04;

# Aren't these already a part of GObject? If not, they REALLY SHOULD BE!
our subset ObjectOrPointer of Mu where * ~~ (
  GLib::Roles::Object,
  GLib::Roles::Pointers,
).any;

sub get-data (ObjectOrPointer $i is copy, $k) {
  return unless $i.defined;

  $i .= GObject if $i ~~ GLib::Roles::Object;
  %data{+$i.p}{$k};
}
sub set-data (ObjectOrPointer $i is copy, $k, $v) {
  return unless $i.defined;

  $i .= GObject if $i ~~ GLib::Roles::Object;
  %data{+$i.p}{$k} = $v;
}

sub button-press ($item, $event, $r) {
  CATCH { default { .message.say; $app.exit } }

  my $i = %globals<model-mode> ?? $item.get_model !! $item;

  return ($r.r = 0) unless get-data($i, 'parent1');

  my $b-event = cast(GdkEventButton, $event);
  return ($r.r = 0)
    unless $b-event.button == 1 && $b-event.type == GDK_BUTTON_PRESS;

  say 'In button-press()';

  my ($p1, $p2) = ( get-data($i, 'parent1'), get-data($i, 'parent2') );
  # Change back to .parent when issues with Method::Also have been resolved.
  my $parent = $i.get_parent;
  $i.remove;
  +$parent.GObject.p == +$p1.GObject.p ??
    $p2.add_child($i) !! $p1.add_child($i);

  $r.r = 1;
}

sub create_canvas_features is export {
  %globals<model-mode> = %globals<rect-obj>.^name.contains('::Model');

  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  my $l1 = GTK::Label.new(
    'Reparent test: click on the items to switch them between parents'
  );
  $vbox.pack_start($l1);

  my $frame = GTK::Frame.new;
  $frame.shadow-type = GTK_SHADOW_IN;
  $frame.halign = $frame.valign = GTK_ALIGN_FILL;
  $vbox.pack_start($frame);

  my $canvas = Goo::Canvas.new;
  my $root = %globals<model-mode> ??
    Goo::Model::Group.new !! $canvas.get_root_item;

  $canvas.root-item-model = $root if %globals<model-mode>;
  $canvas.set_bounds(0, 0, 400, 200);
  $canvas.set_size_request(400, 200);
  $frame.set_size_request(400, 200);
  $frame.add($canvas);

  $canvas.item-created.tap(-> *@a {
    CATCH { default { .message.say; $app.exit } }

    my $d = @a[ %globals<model-mode> ?? 2 !! 1 ];
    my $item = Goo::CanvasItemSimple.new(@a[1]);

    $item.button-press-event.tap(-> *@b { button-press($item, |@b[2, *-1]) });
  }) if %globals<model-mode>;

  my ($parent1, $parent2) = %globals<group-obj>.new($root) xx 2;

  my $r1 = %globals<rect-obj>.new($parent1, 0, 0, 200, 200);
  $r1.fill-color = 'tan';

  $parent2.translate(200, 0);
  my $r2 = %globals<rect-obj>.new($parent2, 0, 0, 200, 200);
  $r2.fill-color = '#204060';

  my $e1 = %globals<ellipse-obj>.new($parent1, 100, 100, 90, 90);
  ($e1.stroke-color, $e1.fill-color) = <black mediumseagreen>;
  $e1.line-width = 3;
  set-data($e1, .VAR.name.substr(1), $_) for $parent1, $parent2;
  $e1.button-press-event.tap(-> *@a { button-press($e1, |@a[2, *-1]) })
    unless %globals<model-mode>;

  my $group = %globals<group-obj>.new($parent2);
  $group.translate(100, 100);

  my $e2 = %globals<ellipse-obj>.new($group, 0, 0, 50, 50);
  ($e2.stroke-color, $e2.fill-color) = <black wheat>;
  $e2.line-width = 3;

  my $e3 = %globals<ellipse-obj>.new($group, 0, 0, 25, 25);
  $e3.fill-color = 'steelblue';

  set-data($group, .VAR.name.substr(1), $_) for $parent1, $parent2;
  $group.button-press-event.tap(-> *@a { button-press($group, |@a[2, *-1]) })
    unless %globals<model-mode>;

  $vbox;
}

sub setObjects ($ellipse-obj, $group-obj, $rect-obj) is export {
  %globals<ellipse-obj   rect-obj   group-obj> =
    (     $ellipse-obj, $rect-obj, $group-obj );
}

sub Reparenting_04_MAIN ($ellipse-obj, $group-obj, $rect-obj) is export {
  $app = GTK::Application.new( title => 'org.genex.goo.reparenting' );

  setObjects($ellipse-obj, $group-obj, $rect-obj);
  $app.activate.tap( -> *@a {
    $app.wait-for-init;
    $app.window.add(create_canvas_features);
    $app.window.show-all;
  });

  $app;
}
