;;; (mpl alg-polynomial-gcd) — polynomial GCD over algebraic number fields.
(define-library (mpl alg-polynomial-gcd)
  (export alg-monic
          alg-polynomial-gcd)
  (import (except (scheme base) + - * / numerator denominator quotient remainder)
          (mpl leading-coefficient-gpe)
          (mpl alg-polynomial-division))
  (begin

    (define (alg-monic u x p a)
      (alg-divide u (leading-coefficient-gpe u x) p a))

    (define (alg-polynomial-gcd u v x p a)
      (let loop ((u u) (v v))
        (if (equal? v 0)
            (alg-monic u x p a)
            (loop v (alg-remainder u v x p a)))))))
