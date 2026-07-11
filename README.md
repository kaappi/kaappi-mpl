# kaappi-mpl

Symbolic math (computer algebra) library for [Kaappi Scheme](https://kaappi-lang.org)
— an R7RS port of [dharmatech/mpl](https://github.com/dharmatech/mpl).

MPL implements algorithms from Joel S. Cohen's books *Computer Algebra and
Symbolic Computation: Elementary Algorithms* and *Mathematical Methods*:
automatic simplification, algebraic and trigonometric expansion/contraction,
symbolic differentiation, polynomial division/GCD over rationals and
algebraic number fields, and an infix expression parser.

```scheme
(import (except (scheme base) + - * / sqrt)
        (mpl all))

(vars a b x y)

(* z y x 2)                         ; => (* 2 x y z)
(+ x y x 5)                         ; => (+ 5 (* 2 x) y)
(algebraic-expand (alge "(x+2)*(x+3)"))  ; => (+ 6 (* 5 x) (^ x 2))
(derivative (alge "a x^2 + b x") 'x)     ; => (+ b (* 2 a x))
(alge "sin(x)^2 + cos(x)^2")             ; infix strings parse to s-expressions
```

## Libraries

Each component lives in its own `(mpl <name>)` library, mirroring upstream.
`(mpl all)` re-exports the commonly used procedures: `+ - * / ^ sqrt vars
alge substitute collect-terms algebraic-expand expand-exp expand-trig
contract-exp contract-trig derivative polynomial-division
polynomial-expansion`.

Because MPL shadows the arithmetic operators with symbolic versions, import
`(scheme base)` with `except`:

```scheme
(import (except (scheme base) + - * / sqrt) (mpl all))
```

Notable internals:

- `(mpl match)` — Alex Shinn's portable syntax-rules pattern matcher
  (public domain, vendored from chibi-scheme; upstream mpl used the R6RS
  syntax-case adaptation of the same matcher).
- `(mpl infix)` — infix parser (`alg`), a port of dharmalab's shunting-yard
  parser with a hand-written tokenizer replacing the silex-generated one.
- `(mpl util)` — replaces the handful of dharmalab helpers mpl used
  (`equal-to`, `any-are`), plus `while` and a rational-capable `mod`.

## Documentation

See the [docs/](docs/) directory:

- [Getting Started](docs/getting-started.md) — importing, variables, arithmetic, infix parser
- [Automatic Simplification](docs/simplification.md) — simplification rules, predicates, accessors
- [Algebraic Operations](docs/algebra.md) — expansion, substitution, polynomials, GCD, rationals
- [Trigonometry](docs/trigonometry.md) — symbolic trig, expand/contract, identities
- [Calculus](docs/calculus.md) — symbolic differentiation
- [Exponentials & Roots](docs/exponentials.md) — exp, log, sqrt, factorial
- [API Reference](docs/reference.md) — complete procedure listing

## Running the tests

```bash
kaappi --lib-path ./lib tests/test-mpl.scm
```

The suite is the upstream test suite (226 assertions) ported to SRFI 64.
One upstream test ("MM: page 117") is omitted: it divides polynomials with
Gaussian-integer coefficients, which needs exact complex arithmetic;
Kaappi's complex numbers are flonum-based.

## Requirements

Kaappi >= 0.15.0 (earlier versions have `syntax-rules` expander limitations
that break the pattern matcher).

## Differences from upstream

- R7RS `define-library` (`lib/mpl/*.sld`) instead of R6RS `.sls` libraries.
- `(rnrs)` / `(mpl rnrs-sans)` imports replaced with `(scheme base)` +
  `except`; `(surfage s1 lists)` → `(srfi 1)`; `(surfage s64 testing)` →
  `(srfi 64)`; R6RS hashtables → SRFI 69.
- `(dharmalab ...)` dependencies folded into `(mpl util)` and `(mpl infix)`.
- `(mpl exp)` returns exact `1` for `(exp 0)` to match R6RS semantics.

## License

Apache License 2.0, same as upstream mpl and dharmalab (copyright their
respective authors; see LICENSE). The vendored pattern matcher
(`lib/mpl/match-impl.scm`) is public domain.
