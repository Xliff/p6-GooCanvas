use v6.c;

unit package GTK::Raw::Exports;

our @goo-exports is export;

BEGIN {
  @goo-exports = <
    Goo::Raw::Definitions
    Goo::Raw::Enums
    Goo::Raw::Structs
  >;
}
