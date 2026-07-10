;;; (mpl expand-main-op) — expand only the top-level operator.
(define-library (mpl expand-main-op)
  (export expand-main-op)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl match)
          (mpl arithmetic)
          (mpl misc)
          (mpl expand-product)
          (mpl expand-power))
  (begin

    (define (expand-main-op u)
      (match u
        ( ('* a . rest)
          (expand-product a
                          (expand-main-op (apply * rest))) )
        ( ('^ a b)
          (expand-power a b) )
        ( else u )))))
