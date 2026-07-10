;;; (mpl rational-expand) — expand numerator and denominator.
(define-library (mpl rational-expand)
  (export rational-expand)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl arithmetic)
          (mpl algebraic-expand)
          (mpl numerator)
          (mpl denominator)
          (mpl rational-gre)
          (mpl rationalize-expression))
  (begin

    (define (rational-expand u)
      (let ((f (algebraic-expand (numerator   u)))
            (g (algebraic-expand (denominator u))))
        (if (equal? g 0)
            #f
            (let ((h (rationalize-expression (/ f g))))
              (if (equal? h u)
                  u
                  (rational-expand h))))))))
