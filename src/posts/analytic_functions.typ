I have just discovered that infinite differentiability
at all points in its domain is not enough to show that
a function is analytic. Here differentiability is performed
in the real sense, not complex. An analytic function is defined
as a function with a power series that converges to the
function at all points in its domain. This is remarkable
to me.

In other words, it is not enough for the real derivative of
a function to exist at the point, but it also must
exist in the neighborhood of the point! If this is true
for all points in the function's domain, then the function
is analytic.

Imagine there is just one point of the function that is
being difficult. If the function is analytic, one can
cover the point by Taylor series expansions of the
neighboring points. Like patching a bike tire, and
the patch would be like the Taylor series approximation.

Recall that a complex function is analytic if and only
if it is holomorphic --- that is, if it is complex
differentiable. The terms are used interchangably. If one
can show that a complex function is complex differentiable
on an open set, then this does imply analyticity.

```scheme
(require racket/format)
(require racket/flonum)

(define (prod-m m)
  ;; Compute the product
  ;;                      m
  ;;  prod-m = sqrt(3) * prod sqrt((2i + 1) / (2i))     for all m >= 1
  ;;                     i=2
  ;;
  ;; reasonably fast. I could not speed this up by implementing it in terms
  ;; of a centered binomial coefficient, although this is possible. To see,
  ;; expand product into double factorials.
  (if (= m 0)
      1.0
      (let loop ([i 2] [acc 1.0])
        (if (> i m)
            (flsqrt (fl* 3.0 acc))
            (let* ([fl-i (exact->inexact i)]
                   [two-i (fl* 2.0 fl-i)]
                   [term (fl/ (fl+ two-i 1.0) two-i)])
              (loop (+ i 1) (fl* acc term)))))))

(define (a-nm n m)
  (let* ([fl-n (exact->inexact n)]
         [fl-m (exact->inexact m)]
         [two-n (fl* 2.0 fl-n)])
    (flsqrt (fl/ (fl* (fl- two-n 1.0) (fl+ two-n 1.0))
                 (fl* (fl- fl-n fl-m) (fl+ fl-n fl-m))))))

(define (b-nm n m)
  (let* ([fl-n (exact->inexact n)]
         [fl-m (exact->inexact m)]
         [two-n (fl* 2.0 fl-n)]
         [n-plus-m (fl+ fl-n fl-m)]
         [n-minus-m (fl- fl-n fl-m)])
    (flsqrt (fl/ (fl* (fl+ two-n 1.0)
                      (fl* (fl- n-plus-m 1.0) (fl- n-minus-m 1.0)))
                 (fl* n-minus-m (fl* n-plus-m (fl- two-n 3.0)))))))

(define (f-nm n m)
  (let* ([fl-n (exact->inexact n)]
         [fl-m (exact->inexact m)]
         [two-n (fl* 2.0 fl-n)])
    (flsqrt (fl/ (fl* (fl- (fl* fl-n fl-n) (fl* fl-m fl-m)) (fl+ two-n 1.0))
                 (fl- two-n 1.0)))))

(define (compute-scaled-alf degree order theta)
  ;; Implements the Holmes & Featherstone (2002) first modified forward column
  ;; technique to compute scaled, stable high order and degree fully normalized
  ;; associated legendre functions (alf's).
  ;;
  ;; Returns a float scaled-alf, which is the value of the associated legendre
  ;; function scaled by 1e-280 and with u^m factored out.
  (let* ([fl-theta (exact->inexact theta)]
         [t (flcos fl-theta)]
         [u (flsin fl-theta)]
         [fl-order (exact->inexact order)]
         [pi-m (fl* (prod-m order) 1e-280)])

    (define (iter n previous-alf-1 previous-alf-2)
      (let* ([fl-n (exact->inexact n)]
             [current-alf
              (if (fl= previous-alf-2 0.0)
                  (fl* (a-nm n order) (fl* t previous-alf-1))
                  (fl- (fl* (a-nm n order) (fl* t previous-alf-1))
                       (fl* (b-nm n order) previous-alf-2)))])
        (if (= n degree)
            current-alf
            (iter (+ n 1) current-alf previous-alf-1))))

    (if (= degree order)
        pi-m
        (iter (+ order 1) pi-m 0.0))))


(define (alf degree order theta)
  ;; High order and degree, fully-normalized associated legendre functions,
  ;; stable up to degree and order ~2700.
  ;;
  ;; The majority of the logic is contained in the routine
  ;; compute-scaled-alf, which implements the first modified
  ;; forward column routine provided by Holmes & Featherstone (2002)
  ;;
  ;; Paper: https://doi.org/10.1007/s00190-002-0216-2
  (unless (<= 0.0 theta pi)
    (error 'theta-out-of-range
           "Colatitude theta must be in range [0.0, pi] (got ~a)" theta))
  (when (< degree 0)
    (error 'invalid-degree "degree cannot be negative (got ~a)" degree))
  (when (> (abs order) degree)
    (error 'invalid-order
           "magnitude of order |m| (got ~a) cannot be greater than degree n (got ~a)"
           order degree))
  (let* ([fl-theta (exact->inexact theta)]
         [scaled-alf (compute-scaled-alf degree order fl-theta)]
         [um (flexpt (flsin fl-theta) (exact->inexact order))])
    (fl* scaled-alf (fl* um 1e280))))
```
