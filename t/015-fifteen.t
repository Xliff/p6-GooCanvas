use v6.c;

use Goo::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::Dialog::Message;
use GTK::Frame;
use Goo::Canvas;
use Goo::Group;
use Goo::Rect;
use Goo::Text;
use Goo::Rect;

use GLib::Roles::Object;
use GLib::Roles::Pointers;

constant PIECE_SIZE     = 50;
constant SCRAMBLE_MOVES = 256;

my (%data, @board);

sub test_win {
  # Should not return True unless board has been scrambled!
  for @board.reverse.skip(1).reverse.kv -> $k, $v {
    return False if $v.defined.not;
    return False unless $v.get-data('num') == $k;
  }
  True;
}

sub get_piece_color ($piece) {
  my ($x, $y) = ($piece % 4, $piece div 4);
  my ($r, $g, $b) = ( ((4 - $x) * 255) div 4, ((4 - $y) * 255) div 4, 128);
  "#{ ($r, $g, $b).map( *.fmt('%02x') ).join }";
}

enum Direction <UP DOWN LEFT RIGHT>;

# For non-mv, this is just the item.
sub get-canvas-model($item) { $item }

sub piece-button-press ($item, $r) {
  CATCH { default { .message.say } }

  my ($model, $canvas) = (get-canvas-model($item), $item.canvas );
  my ($num, $pos, $text) = (
    $model.get-data('num'), $model.get-data('pos'), $model.get-data('text')
  );
  my ($x, $y, $move) = ($pos % 4, $pos div 4, True);
  my ($dx, $dy);

  if      $y > 0 && @board[$pos - 4].not {
    ($dx, $dy) = ( 0, -1); $y--;
  } elsif $y < 3 && @board[$pos + 4].not {
    ($dx, $dy) = ( 0,  1); $y++;
  } elsif $x > 0 && @board[$pos - 1].not {
    ($dx, $dy) = (-1,  0); $x--;
  } elsif $x < 3 && @board[$pos + 1].not {
    ($dx, $dy) = ( 1,  0); $x++;
  } else {
    $move .= not;
  }

  if $move {
    my $newpos = $y * 4 + $x;
    @board[$pos, $newpos] = (Nil, $model);
    $model.set-data('pos', $newpos);
    $model.translate($dx * PIECE_SIZE, $dy * PIECE_SIZE);
    say 'You win!' if test_win;
  }

  $r.r = 0;
}

sub create-canvas-root {
  my $canvas = Goo::Canvas.new;
  my $root = $canvas.get_root_item;
  ($canvas, $root);
}

sub create-piece ($root, $num) {
  my $piece = Goo::Group.new($root);
  my $rect  = Goo::Rect.new($piece, 0, 0, PIECE_SIZE, PIECE_SIZE);
  my $text  = Goo::Text.new(
    $piece,
    "{ $num  + 1 }",
    PIECE_SIZE / 2, PIECE_SIZE / 2,
    -1, GOO_CANVAS_ANCHOR_CENTER
  );

  ($piece, $rect, $text);
}

sub setup-signals ($item) {
  $item.enter-notify-event.tap(-> *@a {
    $item.get-data('text').fill-color = 'white';
    @a[*-1].r = 0
  });

  $item.leave-notify-event.tap(-> *@a {
    $item.get-data('text').fill-color = 'black';
    @a[*-1].r = 0
  });

  $item.button-press-event.tap(-> *@a {
    piece-button-press( $item, @a[*-1] );
  });
}

sub scramble {
  my $pos = 0;

  while @board[$pos] && $pos < 16 { $pos++ }

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
    @board[$pos].set-data('pos', $pos);
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

  my ($canvas, $root) = create-canvas-root;
  (.automatic-bounds, .bounds-from-origin) = (True, False) given $canvas;

  $canvas.set_size_request(PIECE_SIZE * 4 + 1, PIECE_SIZE * 4 + 1);
  $canvas.set_bounds(0, 0, PIECE_SIZE * 4 + 1, PIECE_SIZE * 4 + 1);
  $frame.add($canvas);

  for ^15 -> $i {
    my ($rect, $text);
    my ($x, $y)  = ($i % 4, $i div 4);
    (@board[$i], $rect, $text) = create-piece($root, $i);
    (.font, .fill-color) = ('Sans bold 24', 'black') given $text;
    ($rect.line-width, $rect.stroke-color, $rect.fill-color) =
      ( 1, 'black', get_piece_color($i) );
    given @board[$i] {
      setup-signals($_);
      .translate($x * PIECE_SIZE, $y * PIECE_SIZE);
      .set-data('text', $text);
      .set-data('num', $i);
      .set-data('pos', $i);
    }
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
