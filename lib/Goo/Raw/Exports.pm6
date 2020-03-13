use v6.c;

unit package Goo::Raw::Exports;

our @goo-exports is export;

BEGIN {
  @goo-exports = <
    Goo::Raw::Definitions
    Goo::Raw::Enums
    Goo::Raw::Structs
  >;
}
