;;; (mpl arithmetic) — re-exports the symbolic arithmetic operators.
(define-library (mpl arithmetic)
  (export + - * / ^)
  (import (mpl sum-product-power)
          (mpl sub)
          (mpl div)))
