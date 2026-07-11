# Exponentials, Logarithms, and Roots

## Symbolic `exp`

Returns exact `1` for `exp(0)`. Numeric arguments delegate to R7RS
`exp`. Symbolic arguments return the s-expression `(exp u)`:

```scheme
(exp 0)     ;=> 1
(exp x)     ;=> (exp x)
```

## Symbolic `log`

Natural logarithm. Simplifies `log(exp(x))` to `x`. Supports an
optional second argument for change-of-base:

```scheme
(log (exp x))   ;=> x
(log x)         ;=> (log x)
```

## Symbolic `sqrt`

Returns exact results for perfect squares, otherwise `(^ x 1/2)`:

```scheme
(sqrt 4)    ;=> 2
(sqrt 9)    ;=> 3
(sqrt 2)    ;=> (^ 2 1/2)
(sqrt x)    ;=> (^ x 1/2)
```

## Symbolic `!` (factorial)

Computes the result for numeric arguments, returns `(! n)` for
symbolic ones:

```scheme
(! 5)   ;=> 120
(! 0)   ;=> 1
(! x)   ;=> (! x)
```

## `expand-exp`

Expands exponentials of sums into products, and exponentials of integer
multiples into powers:

```scheme
(expand-exp (alge "exp(2*x + y)"))
;=> (* (^ (exp x) 2) (exp y))

(expand-exp (alge "exp(2*w*x + 3*y*z)"))
;=> (* (^ (exp (* w x)) 2) (^ (exp (* y z)) 3))

(expand-exp (alge "exp(2*(x+y))"))
;=> (* (^ (exp x) 2) (^ (exp y) 2))
```

The rules applied are:

- exp(a + b) => exp(a) * exp(b)
- exp(n * x) => exp(x)^n (when n is an integer)

## `contract-exp`

The inverse of `expand-exp` — contracts products of exponentials into
single exponentials:

```scheme
(contract-exp (alge "exp(u) * exp(v)"))
;=> (exp (+ u v))

(contract-exp (alge "exp(u)^w"))
;=> (exp (* u w))

(contract-exp (alge "exp(x) * (exp(x) + exp(y))"))
;=> (+ (exp (* 2 x)) (exp (+ x y)))
```

The rules applied are:

- exp(a) * exp(b) => exp(a + b)
- exp(a)^n => exp(n * a)
