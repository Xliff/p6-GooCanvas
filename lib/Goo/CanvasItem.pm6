use v6.c;

use Method::Also;

use Cairo;

use Goo::Raw::Types;
use Goo::Raw::CanvasItem;

use GLib::Value;

use Goo::Roles::CanvasItem;

class Goo::CanvasItem {
  also does Goo::Roles::CanvasItem;

  submethod BUILD (:$item) {
    #self.ADD-PREFIX('Goo::');
    self.setCanvasItem($item);
  }

  proto method new (|)
  { * }

  multi method new (GooCanvasItem $item) {
    # my %init;
    # if self ~~ ::('Goo::CanvasItemSimple') {
    #   %init<simplecanvas> = cast(GooCanvasItemSimple, $item);
    # } else {
    #   %init<item>         = $item;
    # }
    $item ?? self.bless(:$item) !! GooCanvasItem;
  }

}
