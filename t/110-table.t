use v6.c;

use lib 't';

use Goo::Model::Ellipse;
use Goo::Model::Polyline;
use Goo::Model::Rect;
use Goo::Model::Table;
use Goo::Model::Text;

use Demo::Table10;

sub MAIN {
  Table_10_MAIN(
    'org.genex.goo.table',
    Goo::Model::Ellipse,
    Goo::Model::Polyline,
    Goo::Model::Rect,
    Goo::Model::Table,
    Goo::Model::Text
  ).run
}
