use v6.c;

use NativeCall;

use GLib::Raw::Exports;
use Pango::Raw::Exports;
use GIO::Raw::Exports;
use GDK::Raw::Exports;
use GTK::Raw::Exports;
use Goo::Raw::Exports;

unit package Goo::Raw::Types;

need Cairo;
need GLib::Raw::Debug;
need GLib::Raw::Definitions;
need GLib::Raw::Enums;
need GLib::Raw::Exceptions;
need GLib::Raw::Object;
need GLib::Raw::Structs;
need GLib::Raw::Subs;
need GLib::Raw::Struct_Subs;
need GLib::Roles::Pointers;
need GLib::Roles::Implementor;
need Pango::Raw::Definitions;
need Pango::Raw::Enums;
need Pango::Raw::Structs;
need Pango::Raw::Subs;
need GIO::DBus::Raw::Types;
need GIO::Raw::Definitions;
need GIO::Raw::Enums;
need GIO::Raw::Quarks;
need GIO::Raw::Structs;
need GIO::Raw::Subs;
need GDK::Raw::Definitions;
need GDK::Raw::Enums;
need GDK::Raw::Structs;
need GDK::Raw::Subs;
need GTK::Raw::Definitions;
need GTK::Raw::Enums;
need GTK::Raw::Requisition;
need GTK::Raw::Structs;
need GTK::Raw::Subs;
need GTK::Raw::Requisition;
need Goo::Raw::Definitions;
need Goo::Raw::Enums;
need Goo::Raw::Structs;

BEGIN {
  glib-re-export($_) for |@glib-exports,
                         |@pango-exports,
                         |@gio-exports,
                         |@gdk-exports,
                         |@gtk-exports,
                         |@goo-exports;
}
