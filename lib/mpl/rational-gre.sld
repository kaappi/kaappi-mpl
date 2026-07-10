;;; (mpl rational-gre) — rational general expression predicate.
(define-library (mpl rational-gre)
  (export rational-gre?)
  (import (except (scheme base) numerator denominator)
          (mpl polynomial-gpe)
          (mpl numerator)
          (mpl denominator))
  (begin

    (define (rational-gre? u v)
      (and (polynomial-gpe? (numerator   u) v)
           (polynomial-gpe? (denominator u) v)))))
