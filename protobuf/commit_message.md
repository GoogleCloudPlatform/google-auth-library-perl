Refactor: Rename namespace from ProtoBuf to Protobuf

This commit refactors the entire Perl module namespace to align with the
official Protobuf style guide, changing from `ProtoBuf` to `Protobuf`.

-   Renamed directories and files under `perl/lib/`.
-   Updated all `package` declarations in `.pm` files.
-   Updated `MODULE` and `PACKAGE` in `.xs` files.
-   Updated `NAME`, `*_FROM` in `perl/Makefile.PL`.
-   Replaced all instances of `ProtoBuf` with `Protobuf` in `perl/typemap`.
-   Updated test files in `perl/t/` to use the new namespace.
-   Updated documentation files in `perl/doc/` to reflect the namespace change.
-   Updated `.gitignore` to use the new namespace.

Additionally, this commit includes:
- New test files: `t/01-load-protobuf-descriptor.t`, `t/02-descriptor.t`
- New C test file: `t/c/load_test.c`
- New XS type conversion helpers: `xs/types.c`, `xs/types.h`
- New architecture document: `doc/architecture/upb-interfacing.md`
- Updates to other architecture documents.
- Removal of old test files.