;;; (mpl collect-terms) — collect coefficients of like terms.
;;; R6RS hashtables replaced with SRFI 69.
(define-library (mpl collect-terms)
  (export collect-terms)
  (import (except (scheme base) + - * / numerator denominator)
          (scheme write)
          (only (srfi 1) iota)
          (srfi 69)
          (mpl misc)
          (mpl arithmetic)
          (mpl coeff-var-monomial))
  (begin

    (define-syntax while
      (syntax-rules ()
        ( (while test expr ...)
          (let loop ()
            (if test
                (begin expr
                       ...
                       (loop)))) )))

    (define (print . elts)
      (for-each display elts))

    (define (say . elts)
      (for-each display elts)
      (newline))

    (define (collect-terms u S)
      (cond ( (not (sum? u)) u )
            ( (member u S) u )
            ( else
              (let ((N 0)
                    (T (make-hash-table eq?)))
                (for-each
                 (lambda (i)
                   (let ((f (coeff-var-monomial (list-ref u i) S)))
                     (let ((j 1)
                           (combined #f))
                       (while (and (not combined)
                                   (<= j N))
                         (if (equal? (list-ref f 1)
                                     (list-ref (hash-table-ref/default T j '(#f #f)) 1))
                             (begin
                               (hash-table-set! T
                                                j
                                                (list (+ (list-ref f 0)
                                                         (list-ref (hash-table-ref/default T j #f)
                                                                   0))
                                                      (list-ref f 1)))
                               (set! combined #t)))
                         (set! j (+ j 1)))
                       (if (not combined)
                           (begin
                             (hash-table-set! T (+ N 1) f)
                             (set! N (+ N 1)))))))
                 (cdr (iota (length u))))
                (apply +
                       (map
                        (lambda (val)
                          (apply * val))
                        (hash-table-values T))))))) ))
