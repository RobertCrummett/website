// 

= Successive Approximations

Consider the linear initial value problem

$ dot(x) = A x, quad x(0) = x_0, quad A in RR^(n times n). $

Integrating both sides from $0$ to $t$:

$ integral_0^t dot(x)(s) dif s = integral_0^t A x(s) dif s. $

By the
#link("https://en.wikipedia.org/wiki/Fundamental_theorem_of_calculus")[Fundamental
Theorem of Calculus], this gives a Volterra integral equation of the second
kind:

$ x(t) = x_0 + integral_0^t A x(s) dif s $

We solve this using successive approximations (Picard iteration) by plugging
each estimate back into the integral:

$
u_0(t) &= x_0 \
u_1(t) &= x_0 + integral_0^t A x_0 dif s = x_0 + A x_0 t \
u_2(t) &= x_0 + integral_0^t A (x_0 + A x_0 s) dif s = x_0 + A x_0 t + A^2 x_0 t^2 / 2 \ \
u_3(t) &= ... \ \
u_(k)(t) &= sum_(m=0)^k (A^m t^m) / m! x_0
$

Taking $k -> oo$, we find the solution of the initial value problem
is the matrix exponential:

$ x(t) = e^(A t) x_0 = sum_(m=0)^oo (A^m t^m) / m! x_0 $

The series of infinite matrix operators, raised to increasing powers, reminds me
of the Neumann series I first learned when solving Fredholm integral equations
of the second kind. In that context, the series arose from a generalized
geometric series, which converged only when the operator norm of the integral
operator was less than one. This memory raised convergence questions in me.

= Connection to Neumann Series

Define the linear integral operator $(cal(K) x)(t) = integral_0^t A x(s) dif s$.
The Volterra integral equation of the second kind $x = x_0 + cal(K) x$ can be
written as

$ (I - cal(K)) x = x_0. $

Formally inverting $(I - cal(K))$ gives the Neumann series:

$ x = (I - cal(K))^(-1) x_0 = sum_(m=0)^oo cal(K)^m x_0 $

= Some Remarks

It turns out the series Volterra integral equations generate always converge.
From what we have seen above, you can think of this as being a consequence of
the $1 slash m!$ factor in the denominator of the series terms. There exist more
rigorous proofs of this. but I do not fully understand them yet. Fredholm
integral equations do not have this property --- convergence must be checked.

The initial value problem posed can be naturally transformed into a Volterra
integral equation. Boundary value problems are usually transformed into Fredholm
integral equations via Green's functions.
