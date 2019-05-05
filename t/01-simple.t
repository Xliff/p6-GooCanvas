use v6.c;

use lib 't';

use Goo::Rect;
use Goo::Text;

use Goo::Roles::CanvasItem;

use Demo::Simple01;

sub MAIN {

  Simple_01_MAIN(
    'org.genex.goo.simple',
    Goo::Rect,
    Goo::Text
  ).run;

}
