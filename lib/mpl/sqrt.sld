;;; (mpl sqrt) — symbolic square root: exact when possible, else (^ x 1/2).
(define-library (mpl sqrt)
  (export sqrt)
  (import (except (scheme base) + - * / numerator denominator)
          (rename (only (scheme inexact) sqrt) (sqrt rnrs:sqrt))
          (mpl arithmetic))
  (begin

    (define (sqrt x)
      (if (and (number? x)
               (exact? (rnrs:sqrt x)))
          (rnrs:sqrt x)
          (^ x 1/2)))))
