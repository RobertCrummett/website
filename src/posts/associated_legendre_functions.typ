#import "../theme.typ": hr

Associated Legendre functions pop up all over the place in
mathematical physics, because they form a complete basis
on the surface of the 3D sphere. Thus, solutions to problems
with radial symmetry are often expressed in them. Because the
Earth is spherical \*cough\*, geodesists often utilize them.
EGM84, EGM96, and EGM2008 were all released as harmonic
coefficients. Ergo, my interest.

But being so popular in so many fields of applied mathematics,
many different customs have arisen around them. Different
normalizations, adjustments, and conventions. When translating
between different fields of physics, or even between different
books in the same field, these conventions can really confuse
me if I do not remember them. Ergo, this post.

#hr

Scaling factors are the first detail covered. Different fields use
different scaling factors. In physics proper, I am under the
impression unnormalized associated Legendre functions (alf's from
now on) are the norm. In geomagnetism, Schmidt semi-normalization is
common. And in geodesy, fully normalized alf's are customary.

Mathematically, scaling factors control what the basis integrates to
over the unit sphere. So it makes sense people would change it to
suit their particular flavor of physics.

Practically, scaling factors control some of the numerical behavior
of alf's.  Unnormalized alf's will overflow quickly (around degree
30 for 32-bit IEEE floats, and around degree 150 for 64-bit IEEE
floats). This is unacceptably low number of basis functions in
fields like geodesy and geomagnetism. Normalizations keep the
alf's from overflowing sooner than they otherwise would.

Phase factors are another issue. I do not quite understand the
origins of the Condon-Shortly phase factor, but occasionally all of
the odd degree alf functions are multiplied by negative one. Watch
out for this, it will cause sign errors everywhere.

// TODO Learn more about the phase factors.

#hr

Below is a routine to compute fully normalized alf's. It is stable
up to degrees \~2700. I have wrote functions like these before, but I
always end up loosing the implementation and needing to rewrite
them. So here it is, once and for all copy and pastable.

Reference:
#link("https://doi.org/10.1007/s00190-002-0216-2")[Holmes and Featherstone, 2002]. Well written paper, if I
may insert my opinion. Of course I can, this is _my_ site!

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
  ;; associated Legendre functions (alf's).
  ;;
  ;; Returns a float scaled-alf, which is the value of the associated Legendre
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
  ;; High order and degree, fully-normalized associated Legendre functions,
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
