use v6.c;

use lib 't';

use Goo::Model::Rect;
use Goo::Model::Text;

use Demo::Simple01;

sub MAIN {

  Simple_01_MAIN(
    'org.genex.goo.simple_model',
    Goo::Model::Rect,
    Goo::Model::Text
  ).run;
  
}
