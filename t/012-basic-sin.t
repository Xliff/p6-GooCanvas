use v6.c;

# Lifted from a BASIC example, found here:
# https://www.freebasic.net/forum/viewtopic.php?t=18544

use Goo::Raw::Types;

use GDK::RGBA;
use Goo::Canvas;
use Goo::Grid;
use Goo::Group;
use Goo::Points;
use Goo::Polyline;
use Goo::Rect;
use Goo::Text;
use GTK::Application;
use GTK::ScrolledWindow;

my %c = (
  Xmax  => 1000, Ymax  => 1000, Smin  => 0.1,
  GridX => 100,  GridY => 100,  GridW => 400, GridH => 300, line-group => 0.8
);

my $app = GTK::Application.new( title => 'org.genex.basic-sine' );

$app.activate.tap({
  $app.wait-for-init;
  $app.window.set-default-size(640, 600);

  my $sw = GTK::ScrolledWindow.new;
  $sw.shadow-type = GTK_SHADOW_IN;

  my $canvas = Goo::Canvas.new;
  $canvas.set-size-request(600, 450);

  $sw.add($canvas);
  $app.window.add($sw);

  my $root = $canvas.get_root_item;
  given ( my $title = Goo::Text.new($root) ) {
    .text = '<span size="xx-large">GooCanvas Raku Example</span>';
    .use-markup = True;
    .font = 'Times bold 14';
  }
  given ( my $group = Goo::Group.new($root) ) {
    .font = 'Sans 14';
  }

  my $n = 2 * (my $az = 100) - 1;
  my ($sx, $dx) = ( ($az - 1) / π, 0.25 * (my $fx = %c<GridW> / $n - 1) );
  my $oy = %c<GridY> + 0.5 * (my $fy = %c<GridH> * 0.45);

  my $grid = Goo::Grid.new($group,
    %c<GridX>, %c<GridY>, %c<GridW>, %c<GridH>,
    $dx, $fy * 0.5, $dx * 1.001, 0.05 * %c<GridH>
  );
  given $grid {
    .border-width = %c<line-group> * 2;
    .horz-grid-line-width = .vert-grid-line-width = %c<line-group>;
    .horz-grid-line-color = .vert-grid-line-color = GDK::RGBA.parse('gray');
  }

  my $CanPoi = Goo::Points.new($az);

  #for 0, 2 ... ($n - 1) {
  for ^$az {
    #$CanPoi[$_    ] = %c<GridX> + $_ * $fx;
    #$CanPoi[$_ + 1] = $oy - ($_ / $sx).sin * $fy;
    $CanPoi[$_] = $oy - ($_ / $sx).sin * $fy;
  }
  given ( my $poly = Goo::Polyline.new($group, False, $CanPoi.points) ) {
    .stroke-color = 'red';
    .line-width = %c<line-group> * 4;
    .tooltip = 'Test Polyline';
  }

  my $ox    = %c<GridX> - 8 * %c<line-group>;
  my $one   = Goo::Text.new($group,  '1', $ox, $oy + $fy, -1, GTK_ANCHOR_E);
  my $n-one = Goo::Text.new($group, '-1', $ox, $oy - $fy, -1, GTK_ANCHOR_E);
  my %text;

  $fy /= 2;
  ( %text{$_} = Goo::Text.new($group) for <+h -h p ½-π φ 1½-π click-me> )
    .map({ .use-markup = True });

  given %text<+h> {
    .text = '<small>0.5</small>';
    (.x, .y, .width, .anchor) = ($ox, $oy - $fy, -1, GTK_ANCHOR_E);
  }
  given %text<-h> {
    .text = '<small>-0.5</small>';
    (.x, .y, .width, .anchor) = ($ox, $oy + $fy, -1, GTK_ANCHOR_E);
  }
  given %text<p> {
    .text = 'f(<i>φ</i>) = sin(<i>φ</i>)';
    (.x, .y, .width, .anchor) = ($ox, $oy, -1, GTK_ANCHOR_S);
    .rotate(-90, $ox, $oy);
  }

  ($ox, $oy) = (%c<GridX>, %c<GridY> + %c<GridH> + 8 * %c<line-group>);
  my $z = Goo::Text.new($group, '0', $ox, $oy, -1, GTK_ANCHOR_N);

  given %text<½-π> {
    .text = '<small>0.5π</small>';
    (.x, .y, .width, .anchor) = ( ($ox += $dx), $oy, -1, GTK_ANCHOR_N);
  }
  my $π = Goo::Text.new($group, 'π', ($ox += $dx), $oy, -1, GTK_ANCHOR_N);
  given %text<φ> {
    .text = 'This <i>φ</i> looks like an <i>angel</i>';
    (.x, .y, .width, .anchor) = ($ox, $oy + 25, -1,  GTK_ANCHOR_N);
  }
  given %text<1½-π> {
    .text = '<small>1.5π</small>';
    (.x, .y, .width, .anchor) = ( ($ox += $dx), $oy, -1, GTK_ANCHOR_N);
  }
  my $tπ = Goo::Text.new($group, '2π', ($ox += $dx), $oy, -1, GTK_ANCHOR_N);

  given %text<click-me> {
    .text = qq:to/SPAN/;
      <span size="x-small"><span foreground="blue">!Click me!</span>
      <span background="yellow">l · m · r </span></span>
      SPAN
    (.x, .y) = ($ox - 0.5 * $dx, %c<GridY> + 0.05 * %c<GridH> * 0.5 * $fy);
    (.width, .anchor, .alignment) = (-1, GTK_ANCHOR_N, PANGO_ALIGN_CENTER);
  }

  given ( my $rect = Goo::Rect.new($group, |%c<GridX GridY GridW GridH>) ) {
    .fill-color-rgba = 0xff000000;
    .unset-stroke-pattern;
  }

  $group.button-press-event.tap(-> *@a {
    state $mo = 0;
    my $e = GDK::Event.new( @a[2] ).get-typed-event;

    @a[* - 1].r = 1;
    if $e.button == 2 {
      $title.stop-animation;
      $title.set-simple-transform(0, 0, 1, 0);
      $group.stop-animation;
      $group.set-simple-transform(0, 0, 1, 0);
      $mo = 0;
    } elsif $mo.not {
      $title.animate(
        %c<GridX> + 0.5 * %c<GridW>, %c<GridY> - 25,
        %c<Smin>, -7,
        False, 8 * 40, 40, GOO_CANVAS_ANIMATE_BOUNCE;
      );
      $group.animate(
        %c<Xmax>, %c<Ymax>, %c<Smin>, 90, False, $e.button * 50 * 40, 40,
        GOO_CANVAS_ANIMATE_BOUNCE
      );
      $mo = 1;
    } else {
      $title.stop-animation;
      $title.set-simple-transform(0, 0, 1, 0);
      $group.stop-animation;
      $mo = 0;
    }
  });

  $app.window.show_all;
});

$app.run;
