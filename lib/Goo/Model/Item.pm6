use v6.c;

use Goo::Raw::Types;

use Goo::Model::Raw::Item;

use GLib::Roles::Object;
use Goo::Model::Roles::Item;

role Goo::Model::Roles::ItemObject {
  also does GLib::Roles::Object;
  also does Goo::Model::Roles::Item;

  submethod BUILD (:$model) {
    #self.ADD-PREFIX('Goo::');
    self.setModelItem($model);
  }

  multi method new (GooCanvasItemModel $model) {
    $model ?? self.bless(:$model) !! Nil;
  }

}
