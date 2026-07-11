# Automatic Simplification

MPL's arithmetic operators (`+`, `-`, `*`, `/`, `^`) automatically
simplify every expression they produce. This is the core of the
library — all other operations build on it.

## Simplification rules

### Constants

Numeric arguments are evaluated immediately:

```scheme
(* 2 3)     ;=> 6
(+ 1 2 3)   ;=> 6
(^ 2 10)    ;=> 1024
```

### Identity and zero

```scheme
(+ x 0)     ;=> x
(* x 1)     ;=> x
(* x 0)     ;=> 0
(^ x 0)     ;=> 1
(^ x 1)     ;=> x
(^ 1 x)     ;=> 1
```

### Sorting

Products and sums are flattened to n-ary form and sorted into a
canonical order (numbers first, then alphabetical by symbol):

```scheme
(* z y x 2)       ;=> (* 2 x y z)
(+ z y x 5)       ;=> (+ 5 x y z)
```

### Combining like terms and factors

```scheme
(+ x x)           ;=> (* 2 x)
(+ x y x z 5 z)   ;=> (+ 5 (* 2 x) y (* 2 z))
(* (^ x 2) (^ x 3))  ;=> (^ x 5)
```

### Power rules

```scheme
(^ (^ x 1/2) 4)         ;=> (^ x 2)
(^ (* x y z) 2)         ;=> (* (^ x 2) (^ y 2) (^ z 2))
```

### Cancellation

```scheme
(/ x x)                 ;=> 1
(* (/ x y) (/ y x))     ;=> 1
```

### Division

Division is represented as multiplication by negative powers. The
simplifier normalizes fractions:

```scheme
(/ x 2)       ;=> (* 1/2 x)
(- (/ (* x y) 3))  ;=> (* -1/3 x y)
```

## `automatic-simplify`

The `automatic-simplify` procedure applies the full simplification
pipeline to a raw s-expression. This is useful when constructing
expressions manually without going through the symbolic operators:

```scheme
(import (mpl automatic-simplify))

(automatic-simplify '(+ x x))       ;=> (* 2 x)
(automatic-simplify '(* (^ x 2) (^ x 3)))  ;=> (^ x 5)
```

The `alg` and `alge` infix parsers call `automatic-simplify` internally.

## Expression predicates

`(mpl misc)` exports predicates for testing expression structure:

```scheme
(sum? '(+ x y))        ;=> #t
(product? '(* 2 x))    ;=> #t
(power? '(^ x 2))      ;=> #t
(quotient? '(/ x y))   ;=> #t
(function? '(sin x))   ;=> #t
(factorial? '(! 5))     ;=> #t
(sin? '(sin x))         ;=> #t
(cos? '(cos x))         ;=> #t
(exp? '(exp x))         ;=> #t
```

## Structure accessors

Extract parts of an expression:

```scheme
(base '(^ x 2))       ;=> x
(exponent '(^ x 2))   ;=> 2
(base 'x)             ;=> x       — non-powers return themselves
(exponent 'x)          ;=> 1       — with exponent 1
```

## Symbolic `numerator` and `denominator`

`(mpl numerator)` and `(mpl denominator)` extract the numerator and
denominator of a symbolic expression:

```scheme
(import (mpl numerator) (mpl denominator))

(numerator (alge " 2/3 * (x*(x+1)) / (x+2) * y^n "))
;=> (* 2 x (+ 1 x) (^ y n))

(denominator (alge " 2/3 * (x*(x+1)) / (x+2) * y^n "))
;=> (* 3 (+ 2 x))
```
