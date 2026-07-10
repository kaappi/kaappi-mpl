;;; (mpl partial-fraction-1) — two-factor partial fraction expansion.
(define-library (mpl partial-fraction-1)
  (export partial-fraction-1)
  (import (except (scheme base) + - * / numerator denominator quotient remainder)
          (mpl arithmetic)
          (mpl algebraic-expand)
          (mpl polynomial-division)
          (mpl extended-euclidean-algorithm))
  (begin

    (define (partial-fraction-1 u v1 v2 x)
      (let ((s (extended-euclidean-algorithm v1 v2 x)))
        (let ((A (list-ref s 1))
              (B (list-ref s 2)))
          (list (remainder (algebraic-expand (* B u)) v1 x)
                (remainder (algebraic-expand (* A u)) v2 x)))))))
