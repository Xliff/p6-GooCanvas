use v6.c;

use lib 't';

use Goo::Model::Ellipse;
use Goo::Model::Rect;
use Goo::Model::Table;
use Goo::Model::Text;

use Demo::Clipping06;

sub MAIN {
  Clipping_06_MAIN(
    Goo::Model::Ellipse,
    Goo::Model::Rect,
    Goo::Model::Table,
    Goo::Model::Text
  ).run;
}
