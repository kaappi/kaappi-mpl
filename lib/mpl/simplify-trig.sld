;;; (mpl simplify-trig) — trig simplification pipeline.
(define-library (mpl simplify-trig)
  (export simplify-trig)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl arithmetic)
          (mpl numerator)
          (mpl denominator)
          (mpl rationalize-expression)
          (mpl expand-trig)
          (mpl contract-trig)
          (mpl trig-substitute)
          (mpl algebraic-expand))
  (begin

    ;; This version calls 'algebraic-expand' between 'contract-trig' and
    ;; 'expand-trig'. This enables 'simplify-trig' to work on EA Example 7.16.
    (define (simplify-trig u)
      (let ((w (rationalize-expression (trig-substitute u))))
        (/ (contract-trig (algebraic-expand (expand-trig (numerator   w))))
           (contract-trig (algebraic-expand (expand-trig (denominator w)))))))))
