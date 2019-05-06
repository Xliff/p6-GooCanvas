use v6.c;

use lib 't';

use Goo::Model::Ellipse;
use Goo::Model::Group;
use Goo::Model::Rect;

use Demo::Reparenting04;

sub MAIN {
  Reparenting_04_MAIN(
    Goo::Model::Ellipse,
    Goo::Model::Group,
    Goo::Model::Rect
  ).run;
}
