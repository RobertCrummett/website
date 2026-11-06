Weierstrass's M-test is a way to guarantee an infinite series of functions
converges absolutely and uniformly. The M-test is important, because convergence
in one of these modes does not necessarily imply convergence in the other.

= Weierstrass M-test

Let $(f_(n)(x))$ be an infinite sequence of functions. We are going to make a
convergence statement for all $x in E$, where $E$ is just some set.

Our job is to supply a sequence of non-negative numbers $M_n$, for each $n$,
such that $|f_(n)(x)| <= M_n$ for all $n$ and $x in E$. So, independent of
the value of $x$, we need to find a constant upper bound.

If we can show that

$ sum_(n=1)^oo M_n < oo $

then the series

$ S(x) = sum_(n=1)^oo f_(n)(x) $

converges absolutely and uniformly on the set $E$. That is the entire result:
if we can find a sequence of real numbers that converge and provide a constant upper
bound for each $f_(n)(x)$ on $E$, then we get very powerful convergence properties.

== Absolute Convergence

The sequence of functions $(f_(n)(x))$ over $E$ remains the same throughout this post.
The series $S(x)$ converges absolutely at a point $x_p in E$ if the series of numbers

$ sum_(n=1)^oo |f_(n)(x_p)| $

converges. This is a point-wise property of functions, found for each $x_p in E$.
If the series converges for every $x in E$, then the series $S(x)$ converges
absolutely on the set $E$.

== Uniform Convergence

Absolute convergence implies point-wise convergence, but it says nothing about the
rates at which neighboring points converge. Uniform convergence will say something
about how the entire function sequence converges.

Let the partial sums be defined as $S_(N)(x) = sum_(n=1)^N f_(n)(x)$. The limit of
$S_(N)(x)$ as $N arrow.r oo$ for $x in E$ is just the infinite series $S(x)$.

The sequence of partial sums $S_(N)(x)$ converges uniformly to $S(x)$ if for every
$epsilon > 0$ there is an index $N$ such that for all $n >= N$ (that is, for the
tail series),

$ |S_(n)(x) - S(x)| < epsilon $

for all $x in E$. What does this do? Effectively, after a certain $N$ point which is
independent of $x$ (but maybe dependent on $epsilon$), we are always within $epsilon$
of convergence. The lack of dependence on $x in E$ is critical --- it is what allows
us to say the entire function over $E$ is getting closer to the limit.

= Passing Thoughts

The Weierstrass's M-test seems to me similar in spirit to Lebesgue's dominated
convergence theorem. Above, Weierstrass is concerned primarily by the convergence
of infinite series of functions. In contrast, Lebesgue's celebrated theorem is about
swapping limits and integrals in measure theory. So they really are different, but
the machinery in both seems to be the same.

Both theorems take wild sequences of $(f_n)$ and seek a tamer alternative over $E$.
Lebesgue requires an integrable function $g(x)$, which needs to be larger than $|f_(n)(x)|$.
Weierstrass requires a numeric sequence $M_n$, which is greater or equal to $|f_(n)(x)|$.
Lebesgue's dominating function is independent of $n$; Weierstrass's M is independent of
$x$; both are simpler than their original sequence, and are greater to or equal to the
elements of the sequence in question.
