use v6.c;

use lib 't';

use Goo::Model::Polyline;
use Goo::Model::Rect;
use Goo::Model::Text;

use Demo::Arrow03;

sub MAIN {
  Arrow_03_MAIN(
    Goo::Model::Rect,
    Goo::Model::Polyline,
    Goo::Model::Text
  ).run;
}
