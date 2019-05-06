
use v6.c;

use lib 't';

use Demo::Animate02;

use Goo::Model::Rect;
use Goo::Model::Ellipse;

sub MAIN {
  Animate_02_MAIN(
    Goo::Model::Rect,
    Goo::Model::Ellipse
  ).run;
}
