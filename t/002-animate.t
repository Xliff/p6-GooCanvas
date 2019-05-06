
use v6.c;

use lib 't';

use Demo::Animate02;

use Goo::Ellipse;
use Goo::Polyline;
use Goo::Rect;

sub MAIN {
  Animate_02_MAIN(Goo::Rect, Goo::Ellipse).run;
}
