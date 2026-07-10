;;; (mpl leading-coefficient-gpe) — leading coefficient of a GPE.
(define-library (mpl leading-coefficient-gpe)
  (export leading-coefficient-gpe)
  (import (scheme base)
          (mpl degree-gpe)
          (mpl coefficient-gpe))
  (begin

    (define (leading-coefficient-gpe u x)
      (coefficient-gpe u x (degree-gpe u (list x))))))
