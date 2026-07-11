# Getting Started

## Installation

```bash
thottam install kaappi-mpl
```

Requires Kaappi >= 0.15.0.

## Importing

MPL replaces the standard arithmetic operators with symbolic versions.
Import `(scheme base)` with `except` to avoid conflicts, then import
`(mpl all)`:

```scheme
(import (except (scheme base) + - * / sqrt)
        (mpl all))
```

`(mpl all)` re-exports the most commonly used procedures: `+ - * / ^
sqrt vars alge substitute collect-terms algebraic-expand expand-exp
expand-trig contract-exp contract-trig derivative polynomial-division
polynomial-expansion`.

For finer control, import individual modules:

```scheme
(import (except (scheme base) + - * /)
        (mpl sum-product-power)   ; + * ^
        (mpl sub)                 ; -
        (mpl div)                 ; /
        (mpl derivative))
```

## Declaring variables

Use `vars` to declare symbolic variables:

```scheme
(vars a b x y z)
```

This defines each name as a self-evaluating symbol. `vars` is a macro
that expands to `(define a 'a) (define b 'b) ...`.

## Symbolic arithmetic

Once imported, `+`, `-`, `*`, `/`, and `^` operate symbolically. They
auto-simplify their results:

```scheme
(* z y x 2)         ;=> (* 2 x y z)       — sorted, coefficient first
(+ x y x z 5 z)     ;=> (+ 5 (* 2 x) y (* 2 z))  — like terms combined
(^ (^ x 1/2) 4)     ;=> (^ x 2)           — power-of-power
(/ x x)              ;=> 1                 — cancellation
(* (/ x y) (/ y x))  ;=> 1
(- (/ (* x y) 3))    ;=> (* -1/3 x y)
```

When all arguments are numbers, the result is a number:

```scheme
(* 2 3)   ;=> 6
(+ 1 2)   ;=> 3
(^ 2 10)  ;=> 1024
```

## S-expression representation

MPL represents expressions as nested lists:

| Math        | S-expression          |
|-------------|-----------------------|
| x + y       | `(+ x y)`             |
| 2xy         | `(* 2 x y)`           |
| x^2         | `(^ x 2)`            |
| x/y         | `(* x (^ y -1))`      |
| sin(x)      | `(sin x)`             |
| f(x, y)     | `(f x y)`             |

Sums and products are n-ary (flat): `(+ a b c)`, not `(+ a (+ b c))`.
Division is represented as multiplication by a negative power.

## Infix parser

MPL includes an infix expression parser for convenient input. `alg`
parses a string and auto-simplifies, returning a symbolic expression:

```scheme
(alg "x^2 + 2*x + 1")    ;=> (+ 1 (* 2 x) (^ x 2))
(alg "sin(x) * cos(y)")   ;=> (* (cos y) (sin x))
(alg "a*x^2 + b*x + c")   ;=> (+ c (* b x) (* a (^ x 2)))
```

`alge` is the same as `alg` but runs `automatic-simplify` on the result,
which is useful when constructing expected values in tests:

```scheme
(alge " (x+2) * (x+3) ")  ;=> (* (+ 2 x) (+ 3 x))
```

Supported infix syntax:

- Juxtaposition for multiplication: `2 x`, `a x^2`
- Standard operators: `+`, `-`, `*`, `/`, `^`
- Parentheses for grouping
- Function application: `sin(x)`, `exp(2*x)`, `f(x, y)`
- Equation syntax: `f(x) = a*x + b`

## A complete example

```scheme
(import (except (scheme base) + - * / sqrt)
        (mpl all))

(vars a b x)

;; Expand (x + 1)^3
(algebraic-expand (alge "(x+1)^3"))
;=> (+ 1 (* 3 x) (* 3 (^ x 2)) (^ x 3))

;; Differentiate a*x^2 + b*x with respect to x
(derivative (alge "a*x^2 + b*x") 'x)
;=> (+ b (* 2 a x))

;; Prove a trig identity equals zero
(simplify-trig (alge "sin(x)^2 + cos(x)^2 - 1"))
;=> 0
```
