;;; (mpl div) — symbolic division.
(define-library (mpl div)
  (export / simplify-quotient)
  (import (except (scheme base) + - * /)
          (mpl match)
          (mpl sum-product-power))
  (begin

    (define (simplify-quotient u)
      (match u
        ( ('/ x y)
          (* x (^ y -1)) )))

    (define (/ u v)
      (simplify-quotient `(/ ,u ,v)))))
