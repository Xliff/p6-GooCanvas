use v6.c;

use Goo::Raw::Types;

use Goo::Model::Raw::Item;

use GLib::Roles::Object;
use Goo::Model::Roles::Item;

class Goo::Model::Item {
  also does GLib::Roles::Object;
  also does Goo::Model::Roles::Item;

  submethod BUILD (:$model) {
    #self.ADD-PREFIX('Goo::');
    self.setModelItem($model);

    self.roleInit-Object;
  }

  multi method new (GooCanvasItemModel $model) {
    $model ?? self.bless(:$model) !! GooCanvasItemModel;
  }

}
