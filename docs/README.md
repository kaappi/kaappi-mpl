# kaappi-mpl Documentation

Symbolic math (computer algebra) library for Kaappi Scheme — an R7RS
port of [dharmatech/mpl](https://github.com/dharmatech/mpl), implementing
algorithms from Joel S. Cohen's *Computer Algebra and Symbolic Computation*
textbooks.

## Pages

| Page | Description |
|------|-------------|
| [Getting Started](getting-started.md) | Importing, declaring variables, symbolic arithmetic, infix parser |
| [Automatic Simplification](simplification.md) | Simplification rules, expression predicates, structure accessors |
| [Algebraic Operations](algebra.md) | Expansion, substitution, polynomial analysis, GCD, rational expressions |
| [Trigonometry](trigonometry.md) | Symbolic sin/cos/tan, expand/contract, identity proving |
| [Calculus](calculus.md) | Symbolic differentiation |
| [Exponentials & Roots](exponentials.md) | Symbolic exp, log, sqrt, factorial, expand/contract |
| [API Reference](reference.md) | Complete procedure listing grouped by category |

## Quick example

```scheme
(import (except (scheme base) + - * / sqrt)
        (mpl all))

(vars a b x)

(algebraic-expand (alge "(x+1)^3"))
;=> (+ 1 (* 3 x) (* 3 (^ x 2)) (^ x 3))

(derivative (alge "a*x^2 + b*x") 'x)
;=> (+ b (* 2 a x))

(simplify-trig (alge "sin(x)^2 + cos(x)^2 - 1"))
;=> 0
```
