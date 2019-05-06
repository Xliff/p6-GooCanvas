use v6.c;

use lib 't';

use Goo::Ellipse;
use Goo::Rect;
use Goo::Table;
use Goo::Text;

use Demo::Clipping06;

sub MAIN {
  Clipping_06_MAIN(Goo::Ellipse, Goo::Rect, Goo::Table, Goo::Text).run;
}
