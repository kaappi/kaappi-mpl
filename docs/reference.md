# API Reference

## Core arithmetic

Exported by `(mpl all)`. Shadow `(scheme base)` operators with `except`.

| Procedure | Description |
|-----------|-------------|
| `(+ expr ...)` | Symbolic addition with auto-simplification |
| `(- expr)` | Symbolic negation: `(* -1 expr)` |
| `(- a b)` | Symbolic subtraction: `(+ a (* -1 b))` |
| `(* expr ...)` | Symbolic multiplication with auto-simplification |
| `(/ a b)` | Symbolic division: `(* a (^ b -1))` |
| `(^ base exp)` | Symbolic exponentiation |

## Infix parser

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(alg str)` | `(mpl infix)` | Parse infix string to prefix s-expression |
| `(alge str-or-expr)` | `(mpl alge)` | Parse and auto-simplify |

## Transcendental functions

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(sin x)` | `(mpl sin)` | Symbolic sine (exact at special angles) |
| `(cos x)` | `(mpl cos)` | Symbolic cosine (exact at special angles) |
| `(tan x)` | `(mpl tan)` | Symbolic tangent |
| `(exp x)` | `(mpl exp)` | Symbolic exponential (`exp(0)` => `1`) |
| `(log x)` | `(mpl log)` | Symbolic natural logarithm |
| `(log x y)` | `(mpl log)` | Logarithm base y |
| `(sqrt x)` | `(mpl sqrt)` | Symbolic square root (exact for perfect squares) |
| `(! n)` | `(mpl factorial)` | Symbolic factorial |

## Variables and predicates

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(vars name ...)` | `(mpl misc)` | Macro: define symbolic variables |
| `(sum? expr)` | `(mpl misc)` | `#t` if `(+ ...)` |
| `(product? expr)` | `(mpl misc)` | `#t` if `(* ...)` |
| `(power? expr)` | `(mpl misc)` | `#t` if `(^ ...)` |
| `(quotient? expr)` | `(mpl misc)` | `#t` if `(/ ...)` |
| `(difference? expr)` | `(mpl misc)` | `#t` if `(- ...)` |
| `(function? expr)` | `(mpl misc)` | `#t` for `(f ...)` where f is not an operator |
| `(factorial? expr)` | `(mpl misc)` | `#t` if `(! ...)` |
| `(sin? expr)` | `(mpl misc)` | `#t` if `(sin ...)` |
| `(cos? expr)` | `(mpl misc)` | `#t` if `(cos ...)` |
| `(exp? expr)` | `(mpl misc)` | `#t` if `(exp ...)` |
| `(base expr)` | `(mpl misc)` | Base of a power, or `expr` itself |
| `(exponent expr)` | `(mpl misc)` | Exponent of a power, or `1` |

## Simplification

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(automatic-simplify expr)` | `(mpl automatic-simplify)` | Full bottom-up simplification of a raw s-expression |
| `(numerator expr)` | `(mpl numerator)` | Symbolic numerator |
| `(denominator expr)` | `(mpl denominator)` | Symbolic denominator |

## Containment

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(contains? u t)` | `(mpl contains)` | `#t` if `u` contains sub-expression `t` |
| `(free? u t)` | `(mpl contains)` | `#t` if `u` does not contain `t` |

## Substitution

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(substitute u t r)` | `(mpl substitute)` | Replace `t` with `r` in `u` |
| `(sequential-substitute u L)` | `(mpl substitute)` | Apply substitutions left-to-right |
| `(concurrent-substitute u S)` | `(mpl substitute)` | Apply all substitutions simultaneously |

## Algebraic expansion

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(algebraic-expand u)` | `(mpl algebraic-expand)` | Fully expand products and powers |
| `(expand-main-op u)` | `(mpl expand-main-op)` | Expand outermost operator only |
| `(collect-terms u vars)` | `(mpl collect-terms)` | Group by variable set |

## Polynomial analysis

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(variables u)` | `(mpl variables)` | Generalized variables of `u` |
| `(monomial-gpe? u vars)` | `(mpl monomial-gpe)` | Monomial test |
| `(polynomial-gpe? u vars)` | `(mpl polynomial-gpe)` | Polynomial test |
| `(degree-gpe u vars)` | `(mpl degree-gpe)` | Degree in given variables |
| `(coefficient-gpe u x j)` | `(mpl coefficient-gpe)` | Coefficient of x^j |
| `(leading-coefficient-gpe u x)` | `(mpl leading-coefficient-gpe)` | Coefficient of highest-degree term |
| `(coeff-var-monomial u vars)` | `(mpl coeff-var-monomial)` | Split monomial into (coeff, var-part) |

## Polynomial operations

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(polynomial-division u v x)` | `(mpl polynomial-division)` | Returns `(quotient remainder)` |
| `(quotient u v x)` | `(mpl polynomial-division)` | Quotient only |
| `(remainder u v x)` | `(mpl polynomial-division)` | Remainder only |
| `(polynomial-expansion u v x t)` | `(mpl polynomial-expansion)` | Re-express `u` in base `v` |
| `(polynomial-gcd u v x)` | `(mpl polynomial-gcd)` | Polynomial GCD |
| `(extended-euclidean-algorithm u v x)` | `(mpl extended-euclidean-algorithm)` | Returns `(gcd A B)` |

## Algebraic number field operations

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(alg-polynomial-division u v x p a)` | `(mpl alg-polynomial-division)` | Division mod p(a)=0 |
| `(alg-polynomial-gcd u v x p a)` | `(mpl alg-polynomial-gcd)` | GCD mod p(a)=0 |

## Rational expressions

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(rational-gre? u vars)` | `(mpl rational-gre)` | Test for rational GRE; returns vars or `#f` |
| `(rational-variables u)` | `(mpl rational-variables)` | Variables of a rational expression |
| `(rationalize-expression u)` | `(mpl rationalize-expression)` | Combine into single fraction |
| `(rational-expand u)` | `(mpl rational-expand)` | Full rational simplification |
| `(partial-fraction-1 u v1 v2 x)` | `(mpl partial-fraction-1)` | Two-factor partial fraction decomposition |

## Trigonometric manipulation

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(expand-trig u)` | `(mpl expand-trig)` | Expand sin/cos of sums and multiples |
| `(contract-trig u)` | `(mpl contract-trig)` | Contract products/powers of sin/cos |
| `(simplify-trig u)` | `(mpl simplify-trig)` | Full trig simplification pipeline |
| `(trig-substitute u)` | `(mpl trig-substitute)` | Rewrite tan/cot/sec/csc as sin/cos |
| `(separate-sin-cos u)` | `(mpl separate-sin-cos)` | Split product into trig and non-trig parts |

## Exponential manipulation

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(expand-exp u)` | `(mpl expand-exp)` | Expand exp of sums into products |
| `(contract-exp u)` | `(mpl contract-exp)` | Contract products of exp into single exp |

## Calculus

| Procedure | Module | Description |
|-----------|--------|-------------|
| `(derivative u x)` | `(mpl derivative)` | Symbolic derivative of `u` w.r.t. `x` |
