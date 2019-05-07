use v6.c;

use lib 't';

use Goo::Ellipse;
use Goo::Polyline;
use Goo::Rect;
use Goo::Table;
use Goo::Text;
use Goo::Widget;

use Demo::Table10;

sub MAIN {
  Table_10_MAIN(
    'org.genex.goo.table',
    Goo::Ellipse,
    Goo::Polyline,
    Goo::Rect,
    Goo::Table,
    Goo::Text,
    Goo::Widget
  ).run
}
