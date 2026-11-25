#let meta = (
  title: "Adjoint — Inverse — Transpose",
  date: "11-23-26",
  summary: "Clarification of these operations, for my own sanity.",
)

#import "../theme.typ": hr

#show math.equation.where(block: false): box // Prevent inline math from breaking across lines.

This post defines the three operations, where they connect, and why. I noticed
in my own thinking that there was definition-level confusion regarding the role
each plays in certain scenarios. Here I clarify these points.

#hr

= Adjoint

Let $A: X arrow.r Y$ be any operation between spaces $X$ and $Y$ that have
inner-products $chevron.l dot, dot chevron.r_X$ and $chevron.l dot, dot
chevron.r_Y$ respectively. $A$ could be a matrix, an integral operator, anything
really --- it just has to be an action taking elements in $X$ to $Y$.

The adjoint of $A$ is $A^*$. The adjoint is defined by the inner products
$chevron.l dot, dot chevron.r_X$ and $chevron.l dot, dot chevron.r_Y$. By
definition

$ chevron.l A x, y chevron.r_X = chevron.l x, A^* y chevron.r_Y quad quad forall x in X, y in Y. $

The inner-products on $X$ and $Y$ _define_ the adjoint operator. That
is a crucial point.

= Inverse

The inverse operator $A^(-1): Y arrow.r X$ undoes the operation of $A$. It is
defined such that

$ A^(-1)(A(x)) = x quad quad forall x in X. $

The inverse operator $A^(-1)$ _undoes_ the operation of $A$. By contrast, the
adjoint operator _reverses_ the action of $A$ from the inner-product space $Y$
to the space $X$. The adjoint seems to require more structure than the inverse;
it is defined above using inner products, while an inverse operation makes sense
on general Banach spaces.

Technically, we can define an adjoint on a Banach space in terms of a dual
operator on dual spaces. This may be the subject of a future extension of this
post.

= Transpose

So this here is the first major aspect of my previous confusion. So often, I
witnessed people identify the adjoint operator as the matrix transpose:

$ chevron.l A x, y chevron.r = chevron.l x, A^T y chevron.r, $

where $A in bb(R)^(n times m)$ is a matrix and $chevron.l dot, dot chevron.r$
are Euclidean inner-products. By inspection, the adjoint operator of $A$
is identified as $A^* = A^T$.

Proof of the statement above is almost as clear as the identification of $A^*$:

$ chevron.l A x, y chevron.r = (A x)^T y = x^T (A^T y) = chevron.l x, A^T y chevron.r. $

So what is so confusing here? I failed to recognize two implicit assumptions in
the identification of the adjoint operator as the transpose above. The first
observation I failed to make was that the operator $A$ need not be a matrix in
general. It could be a nonlinear forward operator --- an integral operator --- a
differential operator --- or literally anything else, just so long as it
satisfies the definition above. The identification $A^* = A^T$ follows from the
fact that $A in bb(R)^(n times m)$.

Second, I failed to observe the dependence of the definition of $A^*$ on the
inner-products themselves. The above identification relies on the fact that our
inner-products on $X$ and $Y$ are not weighted. Numerically, if we were using
inner-products with some weighting matrix $W$,

$ chevron.l x, y chevron.r_W = x^T W y quad quad forall x in X, y in Y, $

then the adjoint operator would need to be modified.

#hr

= Continuous vs.~Discrete

My first encounter of the adjoint operator was in a class on integral equations.
But because almost all discussion of adjoint operators in my field practically
happens in discrete settings, it took me a bit to build the mental bridge between
continuous adjoints in integral equations and discrete adjoints in neural networks
and inversions.

Let the operator $A$ be an integral operator, such that

$ (A f)(s) = integral_0^1 K(t, s) f(t) dif t, $

and let the inner-product on $L^2[0,1]$ be defined as
$chevron.l f, g chevron.r = integral_0^1 f(t) g(t) dif t$. Then we can solve
for the adjoint of $A$ via the definition

$ chevron.l A f, g chevron.r = chevron.l f, A^* g chevron.r. $

Unraveling,

$
chevron.l A f, g chevron.r &= integral_0^1 (A f)(s) g(s) dif s \
&= integral_0^1 [integral_0^1 K(t, s) f(t) dif t] thin g(s) dif s \
&= integral_0^1 f(t) [integral_0^1 K(t, s) g(s) dif s] dif t \
&= integral_0^1 f(t) (A^* g)(t) dif t \
&= chevron.l f, A^* g chevron.r. 
$

Fubini's theorem is the muscle we use to find the adjoint operator in the
continuous setting. The change of variables of integration is the continuous
analogue of the discrete transpose.
