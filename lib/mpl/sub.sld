;;; (mpl sub) — symbolic subtraction and negation.
(define-library (mpl sub)
  (export - simplify-difference)
  (import (except (scheme base) + * -)
          (mpl match)
          (mpl sum-product-power))
  (begin

    (define (simplify-difference u)
      (match u
        ( ('- x)   (* -1 x) )
        ( ('- x y) (+ x (* -1 y)) )))

    (define (- . elts)
      (simplify-difference `(- ,@elts)))))
