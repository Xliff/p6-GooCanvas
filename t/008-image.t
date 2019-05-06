use v6.c;

use lib 't';

use Goo::Image;
use Goo::Rect;

use Demo::Image08;

sub MAIN {
  Image_08_MAIN(Goo::Image, Goo::Rect).run;
}
