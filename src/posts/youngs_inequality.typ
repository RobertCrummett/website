This proof leverages properties of convex functions and Hölder conjugates. I
like the proof because it is small, and reasonable.

Define $f(t) = t^q slash q$, a convex function on the interval $[0, oo)$.

One characterization of convex functions is that they are everywhere
above their tangent lines. For our convex function $f(t)$, this means
that for any $b, c >= 0$,

$ f(b) >= f(c) + f'(c) (b - c). $

Let $p$ and $q$ be Hölder conjugates (i.e.~$1 slash p + 1 slash q = 1$ and
$p, q > 1$).

Now let $c = a^(p - 1)$.

$
b^q / q &>= a^((p - 1) q) / q + a^((p - 1)(q - 1))(b - a^(p - 1)) \
&= a^p / q + a (b - a^(p - 1)) = a^p / q + a b - a^p = (1 - q) a^p / q + a b \
&= - a^p / p + a b.
$

The inequality follows by rearrangement. The jumps between the lines are made by
recognizing Hölder conjugate identities. The jump from the first line to the
second line follows after recognizing $(p - 1) q = p$ and $(p - 1)(q - 1) = 1$.
The jump from the second line to the third line follows after seeing $(1 - q)
slash q = -1 slash p$. This fits in my head!
