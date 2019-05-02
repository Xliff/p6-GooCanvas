use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;

use Goo::Raw::Enums;

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::Dialog::Message;
use GTK::Frame;

use Goo::Canvas;
use Goo::Model::Group;
use Goo::Model::Rect;
use Goo::Model::Text;

use Goo::Rect;

constant PIECE_SIZE     = 50;
constant SCRAMBLE_MOVES = 256;

my (%data, @board);
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

sub test_win {
  for @board {
    return False if .defined.not || get-data($_, 'num') != 1
  }
  True;
}

sub get_piece_color ($piece) {
  my ($x, $y) = ($piece % 4, $piece div 4);
  my ($r, $g, $b) = ( ((4 - $x) * 255) div 4, ((4 - $y) * 255) div 4, 128);
  "#{ ($r, $g, $b).map( *.fmt('%02x') ).join }";
}

enum Direction <UP DOWN LEFT RIGHT>;

sub piece-button-press ($item, $r) {
  my ($model, $canvas) = ($item.model, $item.canvas);
  my ($num, $pos) = ( get-data($model, 'num'), get-data($model, 'pos') );
  my ($x, $y, $text, $move) = ($pos % 4, $pos div 4, $model.text, True);
  my ($dx, $dy);

  if      $y > 0 && @board[$pos - 4].defined.not {
    ($dx, $dy) = ( 0, -1); $y--;
  } elsif $y < 3 && @board[$pos + 4].defined.not {
    ($dx, $dy) = ( 0,  1); $y++;
  } elsif $x > 0 && @board[$pos - 1].defined.not {
    ($dx, $dy) = (-1,  0); $x--;
  } elsif $x < 3 && @board[$pos + 1].defined.not {
    ($dx, $dy) = ( 1,  0); $x++;
  } else {
    $move .= not;
  }

  if $move {
    my $newpos = $y * 4 + $x;
    @board[$pos, $newpos] = (Nil, $model);
    set-data($model, 'pos', $newpos);
    $model.translate($dx * PIECE_SIZE, $dy * PIECE_SIZE);
    test_win;
  }

  $r.r = 0;
}

sub item-created ($i, $m) {
  say 'Item created';
  if Goo::Model.new($m).parent.defined {
    my $item = Goo::CanvasItem.new($i);

    $item.enter-notify-event.tap(-> *@a {
      $item.model.text.fill-color = 'white';
      @a[*-1].r = 0
    });

    $item.leave-notify-event.tap(-> *@a {
      $item.model.text.fill-color = 'black';
      @a[*-1].r = 0
    });

    $item.button-press-event.tap(-> *@a {
      piece-button-press( $item, @a[*-1] );
    });
  }
}

sub scramble {
  my $pos = 0;

  while @board[$pos].defined && $pos < 16 { $pos++ }

  # Move the blank spot around in ordefr to scramble the pieces;
  for ^SCRAMBLE_MOVES {
    my ($x, $y) = 0 xx 2;
    my $dir = Direction.pick;

    {
  		when $dir == UP    && $pos > 3       { --$y }
  		when $dir == DOWN  && $pos < 12      { ++$y }
      when $dir == LEFT  && $pos % 4 != 0  { --$x }
  		when $dir == RIGHT && $pos % 4 != 3  { ++$x }
      default                              { redo }
    }

    # say "Board {$_} state:";
    # .fmt('%4s').say
    #   for @board.map({ .defined ?? get-data($_, 'text').text !! '' }).batch(4);

    my $oldpos = $pos + $y * 4 + $x;
    @board[$pos] = @board[$oldpos];
    @board[$oldpos] = Nil;
    set-data( @board[$pos], 'pos', $pos );
    @board[$pos].translate(-$x * PIECE_SIZE, -$y * PIECE_SIZE);
    $pos = $oldpos;
  }
}

sub create_canvas_fifteen {
  my $vbox = GTK::Box.new-vbox(4);
  $vbox.margins = 4;

  my $frame = GTK::Frame.new;
  $frame.shadow_type = GTK_SHADOW_IN;
  $frame.halign  = $frame.valign  = GTK_ALIGN_CENTER;
  $frame.hexpand = $frame.vexpand = True;
  $vbox.pack_start($frame);

  my $canvas = Goo::Canvas.new;
  (.automatic-bounds, .bounds-from-origin) = (True, False) with $canvas;
  $canvas.item-created.tap(-> *@a { item-created( $canvas, |@a[1,2] ) });

  my $root = Goo::Model::Group.new;
  $canvas.root_item_model = $root;
  $canvas.set_size_request(PIECE_SIZE * 4 + 1, PIECE_SIZE * 4 + 1);
  $canvas.set_bounds(0, 0, PIECE_SIZE * 4 + 1, PIECE_SIZE * 4 + 1);
  $frame.add($canvas);

  for ^15 {
    my ($x, $y) = ($_ % 4, $_ div 4);
    @board[$_] = Goo::Model::Group.new($root);
    @board[$_].translate($x * PIECE_SIZE, $y * PIECE_SIZE);

    my $rect = Goo::Model::Rect.new(@board[$_], 0, 0, PIECE_SIZE, PIECE_SIZE);
    ($rect.line-width, $rect.stroke-color, $rect.fill-color) =
      ( 1, 'black', get_piece_color($_) );

    my $text = Goo::Model::Text.new(
      @board[$_],
      "{ $_  + 1 }",
      PIECE_SIZE / 2, PIECE_SIZE / 2,
      -1, GOO_CANVAS_ANCHOR_CENTER
    );
    (.font, .fill-color) = ('Sans bold 24', 'black') with $text;
    set-data(@board[$_], 'text', $text);
    set-data(@board[$_], 'num', $_);
    set-data(@board[$_], 'pos', $_);
  }

  # Scramble button
  my $button = GTK::Button.new_with_label('Scramble');
  $button.clicked.tap({ scramble });
  $vbox.pack_start($button);

  $vbox;
}

sub MAIN {
  my $app = GTK::Application.new( title => 'org.genex.goo.fifteen' );

  $app.activate.tap({
    $app.wait-for-init;
    $app.window.add( create_canvas_fifteen );
    $app.window.show-all;
  });

  $app.run;
}
