# kaappi-mpl

Symbolic math (computer algebra) library for Kaappi Scheme — an R7RS port of
[dharmatech/mpl](https://github.com/dharmatech/mpl). Licensed Apache-2.0
(not MIT like other ecosystem repos).

## Quick Start

```bash
# run tests (requires kaappi >= 0.15.0)
kaappi --lib-path ./lib tests/test-mpl.scm

# procedure coverage
kaappi --coverage --lib-path ./lib tests/test-mpl.scm
```

## Repo Layout

```
lib/mpl/           56 library files (*.sld), one per module
lib/mpl/all.sld    re-exports the commonly used procedures
lib/mpl/match.sld  vendored pattern matcher (public domain)
tests/test-mpl.scm 226 SRFI-64 assertions
kaappi.pkg         package manifest
```

## Architecture

MPL shadows the standard arithmetic operators (`+ - * /`) with symbolic
versions that auto-simplify. Users must import `(scheme base)` with `except`:

```scheme
(import (except (scheme base) + - * / sqrt) (mpl all))
```

Key internal libraries:
- `(mpl sum-product-power)` — symbolic `+`, `*`, `^` with auto-simplification
- `(mpl sub)` / `(mpl div)` — symbolic `-` and `/`
- `(mpl match)` — Alex Shinn's syntax-rules pattern matcher (drives most code)
- `(mpl infix)` — `alg`/`alge` infix parser (shunting-yard with hand-written tokenizer)
- `(mpl automatic-simplify)` — top-level simplification dispatch
- `(mpl all)` — umbrella re-export of 16 user-facing procedures

## Tests

The test suite uses SRFI 64 (`test-begin`/`test-equal`/`test-end`). It also
imports SRFI 1 (`lset=`). One upstream test ("MM: page 117") is omitted
because it needs exact complex arithmetic.

## CI

CI downloads the pre-built kaappi binary and portable SRFI libraries from
the latest GitHub release (no Zig build). `KAAPPI_HOME` must point to the
directory containing the extracted `kaappi-lib.tar.gz` so the binary can
find `(srfi 1)` and `(srfi 64)`.

## Conventions

- 2-space indentation for all Scheme files
- Short imperative commit messages
- Library files: one `define-library` per `.sld`, implementation inline in
  `(begin ...)` (no separate include files, except `match-impl.scm`)
