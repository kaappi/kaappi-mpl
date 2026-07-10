;;; (mpl monomial-gpe) — general monomial expression predicates.
(define-library (mpl monomial-gpe)
  (export monomial-gpe?
          monomial-gpe-in?
          is-monomial-gpe?)
  (import (scheme base)
          (only (srfi 1) every)
          (mpl misc)
          (mpl contains))
  (begin

    (define (monomial-gpe? u v)
      (or (every (is-free? u) v) ;; GME-1
          (member u v) ;; GME-2
          (and (power? u)
               (member (list-ref u 1) v)
               (integer? (list-ref u 2))
               (> (list-ref u 2) 1))
          (and (product? u)
               (every (is-monomial-gpe? v)
                      (cdr u)))))

    (define (monomial-gpe-in? v)
      (lambda (u)
        (monomial-gpe? u v)))

    (define (is-monomial-gpe? v)
      (lambda (u)
        (monomial-gpe? u v)))))
