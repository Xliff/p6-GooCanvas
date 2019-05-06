use v6.c;

use lib 't';

use Goo::Model::Image;
use Goo::Model::Rect;

use Demo::Image08;

sub MAIN {
  Image_08_MAIN(Goo::Model::Image, Goo::Model::Rect).run;
}
