#import "../theme.typ": hr

When we intend to say a sequence of random variables converges,
it is important to specify in what manner they converge. Here I
will describe *some* of the different types of convergence.
Recall a random variable is hosted in a probability space
$(Omega, cal(A), PP)$.

#hr

== Modes of Convergence

*Pointwise convergence.* \
For each point in the space $Omega$, a sequence of random variables
$X_n$ will converge to a random variable $X$. Or in other words,
for every $omega$ in $Omega$, the sequence $X_n (omega)$
approaches $X(omega)$.

Although point-wise convergence is intuitive, it is not very useful
for probability theory. Because equality in probability theory is
almost always defined _almost surely_, the strict equality is
too strong a requirement to meet. In practice, point-wise convergence
is not often used.

*Almost sure convergence.* \
This is a way of saying that the probability that the sequence
$X_n$ approaches $X$ is almost certain, or has a probability
equal to one. In math speak, we can write this as
$PP(X_n "approaches" X) = 1$.

This mode of convergence can be written in another way as well,
which is analogous to the definition of point-wise convergence.
Let $F$ be a set in $cal(A)$ such that $PP(F) = 1$. Then
a sequence converges almost surely if and only if
$X_n (omega)$ approaches $X(omega)$ for all $omega$
contained in $F$.

This is the strongest mode of convergence listed here. We will
see that it is useful in probability theory, because it allows
us to neglect sets of measure zero.

*Convergence in probability.* \
In this mode of convergence, random variables become arbitrarily
close to one another, such that the probability of them being
a certain non-zero distance from one another is zero. This
can be written as $PP(|X_n - X| "greater than" epsilon)
= 0$ for all $epsilon$ greater than 0.

*Convergence in $L^r$.* \
This is reminciant of convergence in probability, but instead of
using the probability measure we use the expectation of the
$r^"th"$ moment to determine when random variables draw
near eachother. The expectation is denoted $EE$, and this mode
of convergence is written: $EE(|X_n - X|^r) = 0$
for some fixed $r$.

*Convergence in distribution (or weakly).* \
This is when the distribution functions, or cumulative distribution
functions, are equal to eachother in the limit. This is written
as $lim_n F_n (x) = F(x)$ for all $x$
_where $F$ is continuous_. Note the condition in the last part
--- it is easy to forget.

This is the weakest of all the modes of convergence, hence the
alternative name _convergence weakly_.
