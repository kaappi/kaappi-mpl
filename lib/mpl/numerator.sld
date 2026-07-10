;;; (mpl numerator) — numerator of a symbolic expression.
(define-library (mpl numerator)
  (export numerator)
  (import (except (scheme base) + - * / numerator denominator)
          (rename (only (scheme base) numerator) (numerator rnrs:numerator))
          (mpl match)
          (mpl arithmetic))
  (begin

    (define (numerator u)
      (match u
        ( (? number?) (rnrs:numerator u) )
        ( ('^ x y)
          (if (and (number? y)
                   (negative? y))
              1
              u) )
        ( ('* v . rest)
          (* (numerator v)
             (numerator (/ u v))) )
        ( else u )))))
