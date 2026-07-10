;;; (mpl polynomial-expansion) — expand u in terms of v.
(define-library (mpl polynomial-expansion)
  (export polynomial-expansion)
  (import (except (scheme base) + - * / numerator denominator quotient remainder)
          (mpl arithmetic)
          (mpl algebraic-expand)
          (mpl polynomial-division))
  (begin

    (define (polynomial-expansion u v x t)
      (if (equal? u 0)
          0
          (let ((d (polynomial-division u v x)))
            (let ((q (list-ref d 0))
                  (r (list-ref d 1)))
              (algebraic-expand (+ (* t (polynomial-expansion q v x t))
                                   r))))))))
