;;; (mpl factorial) — symbolic factorial.
(define-library (mpl factorial)
  (export ! simplify-factorial)
  (import (rename (scheme base) (- rnrs:-) (* rnrs:*))
          (mpl match))
  (begin

    (define (factorial n)
      (if (= n 0)
          1
          (rnrs:* n (factorial (rnrs:- n 1)))))

    (define (simplify-factorial u)
      (match u
        ( ('! (? number? n)) (factorial n) )
        ( ('! n) u )))

    (define (! n)
      (simplify-factorial `(! ,n)))))
