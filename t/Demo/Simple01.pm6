use v6.c;

use GTK::Raw::Types;
use Goo::Raw::Types;
use Goo::Raw::Enums;

use GTK::Application;
use GTK::ScrolledWindow;

use Goo::Model::Group;

use Goo::Canvas;

my $app;

sub Simple_01_MAIN ($title, $rect-obj, $text-obj) is export {
  my $model-mode = $rect-obj.^name.contains('::Model');

  $app = GTK::Application.new( :$title );

  $app.activate.tap( -> *@a {
    $app.wait-for-init;
    $app.window.set_default_size(640, 480);

    my $sw = GTK::ScrolledWindow.new;
    $sw.shadow_type = GTK_SHADOW_IN;
    $app.window.add($sw);

    my $canvas = Goo::Canvas.new;
    $canvas.set_size_request(600, 450);
    $canvas.set_bounds(0, 0, 1000, 1000);
    $sw.add($canvas);

    # Need a model to assign to $canvas in $model-mode!!
    my $root = $model-mode ??
      ($canvas.root_item_model = Goo::Model::Group.new)
      !!
      $canvas.get_root_item;

    my $rect = $rect-obj.new($root, 100, 100, 400, 400);
    $rect.line-width = 10;
    ($rect.radius-x, $rect.radius-y) = (20, 10);
    ($rect.stroke-color, $rect.fill-color) = <yellow red>;

    my $text = $text-obj.new(
      $root,  'Hello World', 300, 300, -1, GOO_CANVAS_ANCHOR_CENTER
    );
    $text.font = 'Sans 24';
    $text.rotate(45, 300, 300);

    # YYY - Currently, events on model modef are not working.
    unless $model-mode {
      $rect.button-press-event.tap(-> *@a {
        say 'Goo::Rect received button press event';
        @a[*-1].r = 1;
      });
    }

    $app.window.destroy-signal.tap({ $app.exit });
    $app.window.show-all;
  });

  $app;
}
