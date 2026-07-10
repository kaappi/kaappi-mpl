;;; (mpl rational-variables) — variables of a rational expression.
(define-library (mpl rational-variables)
  (export rational-variables)
  (import (except (scheme base) numerator denominator)
          (only (srfi 1) lset-union)
          (mpl variables)
          (mpl numerator)
          (mpl denominator))
  (begin

    (define (rational-variables u)
      (lset-union equal?
                  (variables (numerator   u))
                  (variables (denominator u))))))
