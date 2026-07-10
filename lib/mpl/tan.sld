;;; (mpl tan) — symbolic tangent.
(define-library (mpl tan)
  (export tan)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl match)
          (mpl arithmetic))
  (begin

    (define (simplify-tan u)
      (match u
        ( (and ('tan ('* n . elts))
               (? (lambda (_)
                    (and (number? n)
                         (negative? n)))))
          (- (tan (apply * (append (list -1 n) elts)))) )
        ( else u )))

    (define (tan x)
      (simplify-tan `(tan ,x)))))
