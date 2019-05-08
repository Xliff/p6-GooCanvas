use v6.c;

use lib 't';

use Goo::Rect;
use Goo::Table;

use Demo::Table11;

sub MAIN {
  Table_11_MAIN(
    'org.genex.goo.table_11', Goo::Rect, Goo::Table
  ).run;
}
