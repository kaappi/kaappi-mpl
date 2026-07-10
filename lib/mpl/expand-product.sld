;;; (mpl expand-product) — distribute products over sums.
(define-library (mpl expand-product)
  (export expand-product)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl misc)
          (mpl arithmetic))
  (begin

    (define (expand-product r s)
      (cond ( (sum? r)
              (let ((f (list-ref r 1)))
                (+ (expand-product f s)
                   (expand-product (- r f) s))) )
            ( (sum? s) (expand-product s r) )
            ( else (* r s) )))))
