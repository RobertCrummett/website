#import "../theme.typ": hr

#let Bern = math.op("Bernoulli")

A coupling of random variables (which potentially live on different probability
spaces) is a way to relate random variables.

For instance, take $X ~ Bern(p)$ and $Y ~ Bern(q)$. We have described the random
variables, but we have not described the relationship between them. Even if we
specify $p < q$, ambiguity remains about the relationship between these two
random variables.

To couple random variables, we create a shared probability space, and a random
variable who's marginals are equivalent to the original random variables. The
joint distribution on the shared probability space *is* the coupling.

== Example 1 (independent coupling)

Let $X =^d X'$ and $Y =^d Y'$, where $X' ⫫  Y'$.

The random variable $(X', Y')$ has a joint distribution on a new probability
space

$ bb(P)[(X', Y') = (i, j)] = mat(
  (1 - p)(1 - q), q (1 - p);
  p (1 - q), p q
) quad quad i, j in {0, 1}. $

The marginal distributions of the joint distribution match those of $X$ and $Y$
--- one can check by summing across columns and rows respectively. By creating
this joint distribution (this _coupling_), we have described a relationship
between $X$ and $Y$ which can be used to ask questions about the relationship
between them. But this is not the only such coupling. $qed$

== Example 2 (monotone coupling)

Let $U ~ U(0,1)$ a uniform random variable.

Now define $X'' = bb(I)_{U <= p}$ and $Y'' = bb(I)_{U <= q}$. We can define a
new coupling between $X$ and $Y$ in terms of these random variables:

$ bb(P)[(X'', Y'') = (i, j)] = mat(
  1 - q, q - p; 0, p
) quad quad i, j in {0, 1}. $

The marginal distributions again agree with $X$ and $Y$. So we have another,
different relationship between the random variables $X$ and $Y$. This again
can be used to answer questions about their relationship. $qed$

#hr

So we see that couplings are useful when we want to describe the relationship
between two random variables. Simply describing the distribution of random variables
to one another is not sufficient to answer questions like $bb(P)[X = Y]$, etc.
