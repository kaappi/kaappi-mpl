# Calculus

## Symbolic differentiation

`derivative` computes the symbolic derivative of an expression with
respect to a variable:

```scheme
(import (except (scheme base) + - * / sqrt)
        (mpl all))

(vars a b x)

(derivative (alge "2x - 7") x)            ;=> 2
(derivative (alge "x^3") x)               ;=> (* 3 (^ x 2))
(derivative (alge "a*x^2 + b*x") x)       ;=> (+ b (* 2 a x))
```

## Differentiation rules

### Power rule

Handles the general case d/dx[v^w] using logarithmic differentiation,
which covers both constant exponents and variable exponents:

```scheme
(derivative (alge "x^3") x)               ;=> (* 3 (^ x 2))
(derivative (alge "7*x^5 - 3*x^4 + 6*x^2 + 3*x + 4") x)
;=> (+ 3 (* 12 x) (* -12 (^ x 3)) (* 35 (^ x 4)))
```

### Sum rule

```scheme
(derivative (alge "2*x^2 - 3*x + 5") x)   ;=> (+ -3 (* 4 x))
```

### Product rule

```scheme
(derivative
  (alge "(5*x^3 - 20*x + 13) * (4*x^6 + 2*x^5 - 7*x^2 + 2*x)")
  x)
;=> (+ (* (+ -20 (* 15 (^ x 2)))
          (+ (* 2 x) (* -7 (^ x 2)) (* 2 (^ x 5)) (* 4 (^ x 6))))
       (* (+ 2 (* -14 x) (* 10 (^ x 4)) (* 24 (^ x 5)))
          (+ 13 (* -20 x) (* 5 (^ x 3)))))
```

### Quotient rule

```scheme
(derivative (alge "(3*x - 2) / (x^2 + 7)") x)
;=> (+ (* -1 (* 2 x) (* -1 (+ -2 (* 3 x)))
          (^ (+ 7 (^ x 2)) -2))
       (* 3 (^ (+ 7 (^ x 2)) -1)))
```

### Trigonometric functions

```scheme
(derivative (sin x) x)    ;=> (cos x)
(derivative (cos x) x)    ;=> (* -1 (sin x))
(derivative (tan x) x)    ;=> (^ (sec x) 2)
```

The chain rule is applied automatically:

```scheme
(derivative (sin (alge "x^2")) x)
;=> (* 2 x (cos (^ x 2)))
```

### Constants

Expressions free of the differentiation variable return 0:

```scheme
(derivative a x)   ;=> 0
(derivative 5 x)   ;=> 0
```
