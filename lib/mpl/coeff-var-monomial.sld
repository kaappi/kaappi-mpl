;;; (mpl coeff-var-monomial) — split a monomial into coefficient and variable parts.
(define-library (mpl coeff-var-monomial)
  (export coeff-var-monomial)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl arithmetic)
          (mpl contains))
  (begin

    (define (coeff-var-monomial u v)
      (let loop ( (coefficient-part u)
                  (variables v) )
        (cond ( (null? variables)
                (let ((variable-part (/ u coefficient-part)))
                  (list coefficient-part variable-part)) )
              ( (free? u (car variables))
                (loop coefficient-part
                      (cdr variables)) )
              ( else
                (loop (/ coefficient-part (car variables))
                      (cdr variables)) ))))))
