;;; (mpl log) — symbolic logarithm.
(define-library (mpl log)
  (export log)
  (import (scheme base)
          (scheme case-lambda)
          (rename (only (scheme inexact) log) (log rnrs:log))
          (mpl misc))
  (begin

    (define log
      (case-lambda
       ( (x)
         (cond ( (number? x)
                 (rnrs:log x) )
               ( (exp? x) (list-ref x 1) )
               ( else `(log ,x) )) )
       ( (x y)
         (cond ( (and (number? x) (number? y))
                 (rnrs:log x y) )
               ( else `(log ,x ,y) )) )))))
