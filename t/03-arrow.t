use v6.c;

use lib 't';

use Goo::Polyline;
use Goo::Rect;
use Goo::Text;

use Demo::Arrow03;

sub MAIN {
  Arrow_03_MAIN(Goo::Rect, Goo::Polyline, Goo::Text).run;
}
