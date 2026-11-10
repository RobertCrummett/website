Most inequalities in the thoery of probability follow from Markov's inequality.
It is a fundamental starting point for other results, so it pays to know it
carefully.

= Markov's Inequality

Let $Z$ be a random variable, $Z >= 0$ almost surely. For all $t > 0$,
 
$ bb(P)(Z >= t) <= (bb(E) Z) / t. $

This proof I learned from John Duchi of Stanford. By definition, $bb(P)(Z >= t)
= bb(E) bb(I)_({Z >= t})$. The key here is to notice that $Z slash t >=
bb(I)_({Z >= t})$ for all $Z >= 0$ and $t > 0$. Consider the case $Z slash t >=
1$ and $Z slash t < 1$, and the result follows. Thus $bb(E) bb(I)_({Z >= t}) <=
bb(E)(Z slash t) = bb(E) Z slash t$, the result. $qed$

What is so powerful about this? What I have observed is that folks leverage
this inequality in one chief way: transformations. Given some transform $f$
which maps to the positive reals, it follows $bb(P)(f(Z) >= f(t)) <= bb(E) f(Z)
slash f(t)$. For instance, observe the next example --- it is really nothing
more than Markov's inequality dressed up pretty.

= Chebyshev's Inequality

#let Var = math.op("Var") /* variance operator */

Let $Z in cal(L)^2$ (i.e. $Var(Z)$ is finite). Then

$ bb(P)(Z >= bb(E) Z + t quad "or" quad Z <= bb(E) Z - t) <= Var(Z) / t^2. $

Whoa! Is that really Markov's inequality? Sure is. Notice we did not require $Z
>= 0$. We use the trick mentioned above:

$ bb(P)(Z >= bb(E) Z + t quad "or" quad Z <= bb(E) Z - t) = bb(P)((Z - bb(E) Z)^2 >= t^2 ). $

Now it is clear we are dealing with a non-negative random variable. For $t^2 >
0$, we invoke Markov's ineqality and $Z in cal(L)^2$ to see the famous result
in a new light

$ bb(P)((Z - bb(E) Z)^2 >= t^2 ) <= ( bb(E) (Z - bb(E) Z)^2 ) / t^2 = Var(Z) / t^2. quad qed $

So we see that Chebyshev's inequality follows directly from Markov's
inequality.

= Chernoff Bounds

The proof involves another application of Markov's inequality (big suprise).
This bound is interesting because it is exponential in $t$.

Let $Z in cal(L)^1$ an $t >= 0$. Then

$ bb(P)(Z >= bb(E) Z + t) <= min_(lambda >= 0) M_(Z - bb(E) Z)(lambda) e^(-lambda t), $

where $M_(Z - bb(E) Z)(lambda)$ is the moment generating function of $Z - bb(E) Z$,

$ M_(X)(lambda) = bb(E)[e^(-lambda X)], $

which can be identified as a linear combination of Laplace transform. I have
also heard it called a _double sided_ Laplace transform. Unlike the
characteristic function, the moment generating function is not garunteed to
exist. The integrand must decay sufficiently fast.

Proof of the above follows by application of $f(x) = e^(-lambda x)$ with
$lambda >= 0$ and invokation of Markov's inequality. Since $lambda$ is a free
parameter, we are free to minimize it to find the tightest bound possible.
