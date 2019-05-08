use v6.c;

use lib 't';

use Goo::Model::Rect;
use Goo::Model::Table;

use Demo::Table11;

sub MAIN {
  Table_11_MAIN(
    'org.genex.goo.table_11', Goo::Model::Rect, Goo::Model::Table
  ).run;
}
