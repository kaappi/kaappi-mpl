;;; (mpl alge) — parse infix strings and automatically simplify.
(define-library (mpl alge)
  (export alge)
  (import (scheme base)
          (mpl infix)
          (mpl automatic-simplify))
  (begin

    (define (alge val)
      (automatic-simplify
       (if (string? val)
           (alg val)
           val)))))
