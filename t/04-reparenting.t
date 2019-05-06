use v6.c;

use lib 't';

use Goo::Ellipse;
use Goo::Group;
use Goo::Rect;

use Demo::Reparenting04;

sub MAIN {
  Reparenting_04_MAIN(Goo::Ellipse, Goo::Group, Goo::Rect).run;
}
