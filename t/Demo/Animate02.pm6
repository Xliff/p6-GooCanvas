use v6.c;

use GTK::Raw::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::ScrolledWindow;

use Goo::Canvas;

use Goo::Model::Group;

my (%shapes, %widgets);

sub start_animation {
  %shapes<ellipse1>.set_simple_transform(100, 100, 1, 0);
  %shapes<ellipse1>.animate(
    500, 100, 2, 720, True, 2000, 40, GOO_CANVAS_ANIMATE_BOUNCE
  );
  %shapes<rect1>.set_simple_transform(100, 200, 1, 0);
  %shapes<rect1>.animate(
    100, 200, 1, 350, True, 40 * 36, 40, GOO_CANVAS_ANIMATE_RESTART
  );
  %shapes<rect3>.set_simple_transform(200, 200, 1, 0);
  %shapes<rect3>.animate(
    200, 200, 3, 0, True, 400, 40, GOO_CANVAS_ANIMATE_BOUNCE
  );

  %shapes<ellipse2>.set_simple_transform(100, 400, 1, 0);
  %shapes<ellipse2>.animate(
    400, 0, 2, 720, False, 2000, 40, GOO_CANVAS_ANIMATE_BOUNCE
  );
  %shapes<rect2>.set_simple_transform(100, 500, 1, 0);
  %shapes<rect2>.animate(
    0, 0, 1, 350, False, 40 * 36, 40, GOO_CANVAS_ANIMATE_RESTART
  );
  %shapes<rect4>.set_simple_transform(200, 500, 1, 0);
  %shapes<rect4>.animate(
    0, 0, 3, 0, False, 400, 40, GOO_CANVAS_ANIMATE_BOUNCE
  );
}

sub setup_canvas($rect-obj, $ellipse-obj) {
  my $root = $rect-obj.^name.contains('::Model') ??
    (%widgets<canvas>.root_item_model = Goo::Model::Group.new) !!
    %widgets<canvas>.get_root_item;

  %shapes<ellipse1> = $ellipse-obj.new($root, 0, 0, 25, 15);
  with %shapes<ellipse1> {
    .translate(100, 100);
    .animation-finished.tap(-> *@a { say 'Animation finished' });
  }
  %shapes<rect1> = $rect-obj.new($root, -10, -10, 20, 20);
    %shapes<rect1>.translate(100, 200);
  %shapes<rect3> = $rect-obj.new($root, -10, -10, 20, 20);
    %shapes<rect3>.translate(200, 200);

  %shapes<ellipse2> = $ellipse-obj.new($root, 0, 0, 25, 15);
  %shapes<ellipse2>.translate(100, 400);
  %shapes<rect2> = $rect-obj.new($root, -10, -10, 20, 20);
  %shapes<rect2>.translate(100, 500);
  %shapes<rect4> = $rect-obj.new($root, -10, -10, 20, 20);
  %shapes<rect4>.translate(200, 500);

  %shapes{$_}.fill-color = 'blue' for <ellipse1 rect1 rect3>;
  %shapes{$_}.fill-color = 'red'  for <ellipse2 rect2 rect4>;
}

sub create_animation_page($rect-obj, $ellipse-obj) is export {
  %widgets<vbox> = GTK::Box.new-vbox(4);
  %widgets<hbox> = GTK::Box.new-hbox(4);
  %widgets<vbox>.margins = 4;
  %widgets<vbox>.pack_start(%widgets<hbox>);

  %widgets<button1> = GTK::Button.new_with_label('Start Animation');
  %widgets<hbox>.pack_start(%widgets<button1>);
  %widgets<button1>.clicked.tap( -> *@a { start_animation });

  %widgets<button2> = GTK::Button.new_with_label('Stop Animation');
  %widgets<hbox>.pack_start(%widgets<button2>);
  %widgets<button2>.clicked.tap( -> *@a { .stop_animation for %shapes.values });

  %widgets<scrolled_win> = GTK::ScrolledWindow.new;
  %widgets<scrolled_win>.set_size_request(599, 449);
  %widgets<scrolled_win>.shadow_type = GTK_SHADOW_IN;
  %widgets<vbox>.pack_start(%widgets<scrolled_win>);
  .halign  = .valign  = GTK_ALIGN_FILL with %widgets<scrolled_win>;
  .hexpand = .vexpand = True           with %widgets<scrolled_win>;

  %widgets<canvas> = Goo::Canvas.new;
  %widgets<canvas>.set_size_request(600, 450);
  %widgets<canvas>.set_bounds(0, 0, 1000, 1000);
  %widgets<scrolled_win>.add(%widgets<canvas>);
  setup_canvas($rect-obj, $ellipse-obj);
  %widgets<vbox>
}

sub Animate_02_MAIN($rect-obj, $ellipse-obj) is export {
  my $app = GTK::Application.new( title => 'org.genex.goo.animate' );

  $app.activate.tap( -> *@a {
    $app.wait-for-init;

    $app.window.set_default_size(640, 480);
    $app.window.add( create_animation_page($rect-obj, $ellipse-obj) );
    $app.window.destroy-signal.tap( -> *@a { $app.exit });
    $app.window.show-all;
  });

  $app;
}
