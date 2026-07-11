# Algebraic Operations

## Expansion

### `algebraic-expand`

Fully expands products and positive integer powers:

```scheme
(algebraic-expand (alge "(x+2)*(x+3)*(x+4)"))
;=> (+ 24 (* 26 x) (* 9 (^ x 2)) (^ x 3))

(algebraic-expand (alge "(x+y+z)^3"))
;=> (+ (^ x 3) (^ y 3) (^ z 3)
       (* 3 (^ x 2) y) (* 3 (^ x 2) z)
       (* 3 x (^ y 2)) (* 3 x (^ z 2))
       (* 3 (^ y 2) z) (* 3 y (^ z 2))
       (* 6 x y z))

(algebraic-expand (alge "(x+1)^2 + (y+1)^2"))
;=> (+ 2 (* 2 x) (^ x 2) (* 2 y) (^ y 2))
```

It also distributes inside function arguments:

```scheme
(algebraic-expand (sin (* x (+ y z))))
;=> (sin (+ (* x y) (* x z)))
```

### `expand-main-op`

Expands only the top-level operator, leaving sub-expressions intact:

```scheme
(expand-main-op (alge "x * (2 + (1+x)^2)"))
;=> (+ (* 2 x) (* x (^ (+ 1 x) 2)))

(expand-main-op (alge "(x + (1+x)^2)^2"))
;=> (+ (^ x 2) (* 2 x (^ (+ 1 x) 2)) (^ (+ 1 x) 4))
```

## Substitution

### `substitute`

Replace occurrences of a sub-expression:

```scheme
(substitute (alg "a+b") b x)           ;=> (+ a x)
(substitute (alg "1/a+a") a x)         ;=> (+ (^ x -1) x)
(substitute (alg "(a+b)^2 + 1") (alg "a+b") x)  ;=> (+ 1 (^ x 2))
```

Substitution matches complete sub-expressions, not partial sums:

```scheme
(substitute '(+ a b c) '(+ a b) x)    ;=> (+ a b c)  — no match
```

### `sequential-substitute`

Apply substitutions one after another (each sees the result of the
previous one):

```scheme
(sequential-substitute (alg "x+y")
  `((x ,(alg "a+1"))
    (y ,(alg "b+2"))))
;=> (+ 3 a b)

;; Order matters:
(sequential-substitute (alg "x+y")
  `((x ,(alg "a+1"))
    (a ,(alg "b+2"))))
;=> (+ 3 b y)   — a was substituted in the already-modified expression
```

### `concurrent-substitute`

Apply all substitutions simultaneously (each sees the original):

```scheme
(concurrent-substitute (alg "(a+b)*x")
  `((,(alg "a+b") ,(alg "x+c"))
    (x d)))
;=> (* d (+ c x))
```

## Collecting terms

### `collect-terms`

Group an expanded polynomial by specified variables:

```scheme
(collect-terms (alge "2*a*x*y + 3*b*x*y + 4*a*x + 5*b*x")
               '(x y))
;=> (+ (* (+ (* 2 a) (* 3 b)) x y)
       (* (+ (* 4 a) (* 5 b)) x))
```

## Polynomial analysis

### `monomial-gpe?` / `polynomial-gpe?`

Test whether an expression is a monomial or polynomial in given variables:

```scheme
(monomial-gpe? (alg "a*x^2*y^2") '(x y))     ;=> #t
(monomial-gpe? (alg "x^2 + y^2") '(x y))      ;=> #f

(polynomial-gpe? (alg "x^2 + y^2") '(x y))              ;=> #t
(polynomial-gpe? (alg "sin(x)^2 + 2*sin(x) + 3")
                 (list (alg "sin(x)")))                   ;=> #t
(polynomial-gpe? (alg "x/y + 2*y") '(x y))               ;=> #f
```

### `variables`

Return the generalized variables of an expression:

```scheme
(variables (alg "x^3 + 3*x^2*y + 3*x*y^2 + y^3"))
;=> (x y)   — as a set (order may vary)

(variables (alg "a*sin(x)^2 + 2*b*sin(x) + 3*c"))
;=> (a b (sin x) c)

(variables 1/2)  ;=> ()
```

### `degree-gpe`

Degree of a polynomial in specified variables:

```scheme
(degree-gpe (alg "3*w*x^2*y^3*z^4") '(x z))    ;=> 6
(degree-gpe (alg "a*x^2 + b*x + c") '(x))       ;=> 2
```

### `coefficient-gpe`

Extract the coefficient of a given power:

```scheme
(coefficient-gpe (alg "a*x^2 + b*x + c") x 2)     ;=> a
(coefficient-gpe (alg "a*x^2 + b*x + c") x 1)     ;=> b
(coefficient-gpe (alg "a*x^2 + b*x + c") x 3)     ;=> 0

;; Returns 'undefined when expression is not a GPE in x:
(coefficient-gpe (alg "3*sin(x)*x^2 + 2*ln(x)*x + 4") x 2)
;=> undefined
```

### `leading-coefficient-gpe`

The coefficient of the highest-degree term:

```scheme
(leading-coefficient-gpe
  (alg "3*x*y^2 + 5*x^2*y + 7*x^2*y^3 + 9") x)
;=> (+ (* 5 y) (* 7 (^ y 3)))
```

### `coeff-var-monomial`

Split a monomial into coefficient and variable parts relative to a
variable set:

```scheme
(coeff-var-monomial (alg "3*x*y") '(x))    ;=> ((* 3 y) x)
(coeff-var-monomial (alg "3*x*y") '(y))    ;=> ((* 3 x) y)
(coeff-var-monomial (alg "3*x*y") '(x y))  ;=> (3 (* x y))
```

## Polynomial division

### `polynomial-division`

Divides two univariate polynomials, returning `(quotient remainder)`:

```scheme
(polynomial-division (alge "5*x^2 + 4*x + 1")
                     (alge "2*x + 3")
                     x)
;=> ((+ (* 5/2 x) -7/4) 25/4)

(polynomial-division (alge "x^2 - 4") (alge "x+2") x)
;=> ((+ -2 x) 0)
```

### `quotient` / `remainder`

Convenience wrappers:

```scheme
(remainder (alge "3*x^3 + x^2 - 4")
           (alge "x^2 - 4*x + 2")
           x)
;=> (+ -30 (* 46 x))
```

### `polynomial-expansion`

Re-express a polynomial in terms of a new base polynomial:

```scheme
(polynomial-expansion
  (alge "x^5 + 11*x^4 + 51*x^3 + 124*x^2 + 159*x + 86")
  (alge "x^2 + 4*x + 5")
  x t)
;=> (+ (* x (^ t 2)) (* 3 (^ t 2)) (* t x) (* 2 t) x 1)
```

## Polynomial GCD

### `polynomial-gcd`

Greatest common divisor of two polynomials:

```scheme
(polynomial-gcd (alge "2*x^3 + 12*x^2 + 22*x + 12")
                (alge "2*x^3 + 18*x^2 + 52*x + 48")
                x)
;=> (+ 6 (* 5 x) (^ x 2))
```

### `extended-euclidean-algorithm`

Returns `(gcd s t)` such that `s*u + t*v = gcd`:

```scheme
(extended-euclidean-algorithm
  (alge "x^7 - 4*x^5 - x^2 + 4")
  (alge "x^5 - 4*x^3 - x^2 + 4")
  x)
;=> ((+ 4 (* -1 (^ x 2)) (* -4 x) (^ x 3))
     (* -1 x)
     (+ 1 (^ x 3)))
```

## Algebraic number field operations

### `alg-polynomial-division` / `alg-polynomial-gcd`

Polynomial division and GCD over algebraic number fields, with
coefficients reduced modulo a minimal polynomial:

```scheme
(alg-polynomial-division (alge "2*x^2 + a*x")
                         (alge "a*x + a")
                         x
                         (alge "a^2 - 2")
                         a)
;=> ((+ 1 (* -1 a) (* a x)) (+ -1 a (* 2 x)))

(alg-polynomial-gcd (alge "x^2 + (-1 - a)*x")
                    (alge "x^2 + (-2 - 2*a)*x + 3 + 2*a")
                    x
                    (alge "a^2 - 2")
                    a)
;=> (+ -1 (* -1 a) x)
```

## Rational expressions

### `rational-gre?`

Test if an expression is a generalized rational expression in the
given variables. Returns the variable list on success, `#f` on failure:

```scheme
(rational-gre? (alge "(x^2+1)/(2*x+3)") '(x))    ;=> (x)
(rational-gre? (alge "1/x + 1/y") '(x y))         ;=> #f
```

### `rationalize-expression`

Convert an expression to a single fraction:

```scheme
(rationalize-expression (alge "(1+1/x)^2"))
;=> (/ (^ (+ 1 x) 2) (^ x 2))

(rationalize-expression (alge "a + b/2"))
;=> (/ (+ (* 2 a) b) 2)
```

### `rational-expand`

Full rational simplification — expand, combine, and cancel:

```scheme
(rational-expand
  (alge "1/(1/a + c/(a*b)) + (a*b*c + a*c^2)/(b+c)^2 - a"))
;=> 0
```

### `partial-fraction-1`

Partial fraction decomposition (single-factor denominator):

```scheme
(partial-fraction-1 (alge "x^2+2") (alge "x+2") (alge "x^2-1") x)
;=> (2 (+ 2 (* -1 x)))
```
