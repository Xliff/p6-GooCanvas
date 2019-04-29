use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use Goo::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Frame;
use GTK::Label;

use Goo::Ellipse;
use Goo::Group;
use Goo::Rect;

my ($app, %data);

# Aren't these already a part of GObject? If not, they REALLY SHOULD BE!
our subset ObjectOrPointer of Mu where * ~~ (
  GTK::Compat::Roles::Object,
  GTK::Roles::Pointers,
  GTK::Roles::Properties
).any;

sub get-data (ObjectOrPointer $i is copy, $k) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GTK::Compat::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k};
}
sub set-data (ObjectOrPointer $i is copy, $k, $v) {
  return unless $i.defined;
  $i .= GObject
    if $i ~~ (GTK::Compat::Roles::Object, GTK::Roles::Properties).any;
  %data{+$i.p}{$k} = $v;
}

sub button-press ($item, $event, $r) {
  CATCH { default { .message.say; $app.exit } }

  my $b-event = cast(GdkEventButton, $event);
  return ($r.r = 0)
    unless $b-event.button == 1 && $b-event.type == GDK_BUTTON_PRESS;

  say 'In button-press()';

  my ($p1, $p2) = ( get-data($item, 'parent1'), get-data($item, 'parent2') );
  my $parent = $item.parent;
  $item.remove;
  +$parent.GObject.p == +$p1.GObject.p ??
    $p2.add_child($item) !! $p1.add_child($item);

  $r.r = 1;
}

sub create_canvas_features {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  my $l1 = GTK::Label.new(
    'Reparent test:  click on the items to switch them between parents'
  );
  $vbox.pack_start($l1);

  my $frame = GTK::Frame.new;
  $frame.shadow-type = GTK_SHADOW_IN;
  $frame.halign = $frame.valign = GTK_ALIGN_FILL;
  $vbox.pack_start($frame);

  my $canvas = Goo::Canvas.new;
  my $root = $canvas.get_root_item;
  $canvas.set_bounds(0, 0, 400, 200);
  $canvas.set_size_request(400, 200);
  $frame.set_size_request(400, 200);
  $frame.add($canvas);

  my ($parent1, $parent2) = Goo::Group.new($root) xx 2;

  my $r1 = Goo::Rect.new($parent1, 0, 0, 200, 200);
  $r1.fill-color = 'tan';

  $parent2.translate(200, 0);
  my $r2 = Goo::Rect.new($parent2, 0, 0, 200, 200);
  $r2.fill-color = '#204060';

  my $e1 = Goo::Ellipse.new($parent1, 100, 100, 90, 90);
  ($e1.stroke-color, $e1.fill-color) = <black mediumseagreen>;
  $e1.line-width = 3;
  set-data($e1, .VAR.name.substr(1), $_) for $parent1, $parent2;
  $e1.button-press-event.tap(-> *@a { button-press($e1, |@a[2, *-1]) });

  my $group = Goo::Group.new($parent2);
  $group.translate(100, 100);

  my $e2 = Goo::Ellipse.new($group, 0, 0, 50, 50);
  ($e2.stroke-color, $e2.fill-color) = <black wheat>;
  $e2.line-width = 3;

  my $e3 = Goo::Ellipse.new($group, 0, 0, 25, 25);
  $e3.fill-color = 'steelblue';

  set-data($group, .VAR.name.substr(1), $_) for $parent1, $parent2;
  $group.button-press-event.tap(-> *@a { button-press($group, |@a[2, *-1]) });

  $vbox;
}

sub MAIN {
  $app = GTK::Application.new( title => 'org.genex.goo.reparenting' );

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.add(create_canvas_features);
    $app.window.show-all;
  });

  $app.run;
}
