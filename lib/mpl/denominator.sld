;;; (mpl denominator) — denominator of a symbolic expression.
(define-library (mpl denominator)
  (export denominator)
  (import (except (scheme base) + - * / numerator denominator)
          (rename (only (scheme base) denominator) (denominator rnrs:denominator))
          (mpl match)
          (mpl arithmetic))
  (begin

    (define (denominator u)
      (match u
        ( (? number?) (rnrs:denominator u) )
        ( ('^ x y)
          (if (and (number? y)
                   (negative? y))
              (^ u -1)
              1) )
        ( ('* v . rest)
          (* (denominator v)
             (denominator (/ u v))) )
        ( else 1 )))))
