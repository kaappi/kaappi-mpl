# Trigonometric Functions

## Symbolic sin, cos, tan

MPL provides symbolic versions of `sin`, `cos`, and `tan` that return
exact results for special angles and simplify symbolically.

### Exact values

`sin` and `cos` return exact results for multiples of pi/6, pi/4, pi/3,
pi/2, and pi:

```scheme
(sin 0)              ;=> 0
(sin pi)             ;=> 0
(sin (* 1/2 pi))     ;=> 1
(sin (* 1/4 pi))     ;=> (^ (^ 2 1/2) -1)   — i.e. 1/sqrt(2)
(sin (* 1/3 pi))     ;=> (* 1/2 (^ 3 1/2))   — i.e. sqrt(3)/2
(sin (* 1/6 pi))     ;=> 1/2

(cos 0)              ;=> 1
(cos pi)             ;=> -1
(cos (* 1/2 pi))     ;=> 0
(cos (* 1/3 pi))     ;=> 1/2
```

### Parity

`sin` is odd, `cos` is even:

```scheme
(sin (- x))          ;=> (* -1 (sin x))
(sin (* -5 x))       ;=> (* -1 (sin (* 5 x)))
(cos (- x))          ;=> (cos x)
(cos (* -5 x))       ;=> (cos (* 5 x))
```

### Period reduction

Arguments are reduced modulo 2*pi, and half-pi shifts are applied:

```scheme
(sin (+ x (* 2 pi)))      ;=> (sin x)
(sin (+ x (* 1/2 pi)))    ;=> (cos x)
(sin (+ x (* -1/2 pi)))   ;=> (* -1 (cos x))
(cos (+ x (* 1/2 pi)))    ;=> (* -1 (sin x))
(cos (+ x (* -1/2 pi)))   ;=> (sin x)
```

## `expand-trig`

Expands `sin` and `cos` of sums and integer multiples using
angle-addition formulas:

```scheme
(expand-trig (alge "sin(x+y)"))
;=> (+ (* (cos y) (sin x)) (* (cos x) (sin y)))

(expand-trig (alge "cos(x+y)"))
;=> (+ (* (cos x) (cos y)) (* -1 (sin x) (sin y)))

(expand-trig (alge "sin(2x + 3y)"))
;=> 2*sin(x)*cos(x)*(cos(y)^3 - 3*cos(y)*sin(y)^2) + ...

(expand-trig (alge "cos(5x)"))
;=> (+ (^ (cos x) 5) (* -10 (^ (cos x) 3) (^ (sin x) 2))
       (* 5 (cos x) (^ (sin x) 4)))
```

## `contract-trig`

The inverse of `expand-trig` — contracts products and powers of `sin`
and `cos` into sums of single trig functions:

```scheme
(contract-trig (alge "sin(x) * sin(y)"))
;=> (+ (* 1/2 (cos (+ x (* -1 y)))) (* -1/2 (cos (+ x y))))

(contract-trig (alge "cos(x) * cos(y)"))
;=> (+ (* 1/2 (cos (+ x y))) (* 1/2 (cos (+ x (* -1 y)))))

(contract-trig (alge "sin(x) * cos(y)"))
;=> (+ (* 1/2 (sin (+ x y))) (* 1/2 (sin (+ x (* -1 y)))))

(contract-trig (alge "sin(x)^2 * cos(x)^2"))
;=> (+ 1/8 (* -1/8 (cos (* 4 x))))

(contract-trig (alge "cos(x)^4"))
;=> (+ 3/8 (* 1/2 (cos (* 2 x))) (* 1/8 (cos (* 4 x))))
```

## `simplify-trig`

Full trig simplification pipeline. Rewrites secondary trig functions
(tan, cot, sec, csc) to sin/cos, then rationalizes, expands, and
contracts. Useful for proving identities — the result is 0 if the
expression is an identity:

```scheme
(simplify-trig
  (alge "(cos(x)+sin(x))^4 + (cos(x)-sin(x))^4 + cos(4*x) - 3"))
;=> 0

(simplify-trig
  (alge "sin(x) + sin(y) - 2*sin(x/2+y/2)*cos(x/2-y/2)"))
;=> 0

(simplify-trig
  (alge "sin(x)^3 + cos(x+pi/6)^3 - sin(x+pi/3)^3 + 3*sin(3*x)/4"))
;=> 0

(simplify-trig
  (- (/ (alge "sin(x) + sin(3*x) + sin(5*x) + sin(7*x)")
        (alge "cos(x) + cos(3*x) + cos(5*x) + cos(7*x)"))
     '(tan (* 4 x))))
;=> 0
```

## `trig-substitute`

Rewrites `tan`, `cot`, `sec`, and `csc` in terms of `sin` and `cos`:

```scheme
(trig-substitute '(tan x))   ;=> (/ (sin x) (cos x))
(trig-substitute '(cot x))   ;=> (/ (cos x) (sin x))
(trig-substitute '(sec x))   ;=> (/ 1 (cos x))
(trig-substitute '(csc x))   ;=> (/ 1 (sin x))
(trig-substitute x)           ;=> x
```
