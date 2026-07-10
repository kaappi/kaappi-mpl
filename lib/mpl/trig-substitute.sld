;;; (mpl trig-substitute) — rewrite tan/cot/sec/csc in terms of sin and cos.
(define-library (mpl trig-substitute)
  (export trig-substitute)
  (import (except (scheme base) + - * / numerator denominator)
          (mpl match)
          (mpl arithmetic)
          (mpl sin)
          (mpl cos))
  (begin

    (define (trig-substitute u)
      (if (or (number? u)
              (symbol? u))
          u
          (let ((v (map trig-substitute u)))
            (match v
              (('tan x) (/ (sin x) (cos x)))
              (('cot x) (/ (cos x) (sin x)))
              (('sec x) (/ 1 (cos x)))
              (('csc x) (/ 1 (sin x)))
              (else v)))))))
