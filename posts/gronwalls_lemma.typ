I had to use this lemma in a recent homework assignment. My professor is
emailing me, trying to prompt me to finish the task. I am three weeks late, and
still have not proved the first question. The teacher seems to understand I am
tracking with the course content, so she tolerates me being a month late on my
assignments.

Instead of doing the assignment, I am writing this post about my homework
assigment.

= Gronwall's Lemma

Also known as Gronwall's inqeuality. Suppose that there is a function $g(t)$ such that

$ g(t) <= C + K integral_0^t g(s) dif s, $

where $C, K > 0$ and $g(t) >= 0$ for all $t in [0, a]$. In this case, the following
inequality is true:

$ g(t) <= C e^(K t). $

= Proof ($1 slash 2$)

This proof will leverage recursion and interchange of variables of integration. I think
this proof is very clear, although maybe not as clean as the next proof.

First, take the assumed inequality and substitute the definition of $g(s)$ recursively
under the integral:

$ g(t) <=& C + K integral_0^t g(s) dif s \
        =& C + K integral_0^t (C + K integral_0^s g(u) dif u) dif s \
        =& C + C K t + K^2 integral_0^t integral_0^s g(u) dif u dif s. $

This is the step that caused me to stumble. I forgot how to think through
the interchange of variables of integration. The trick is to draw a picture
of the $s$-$u$ plane, and figure out what the region of integration looks like.
Reordering leads to

$ g(t) <=& C + C K t + K^2 integral_0^t integral_0^s g(u) dif u dif s \
        =& C + C K t + K^2 integral_0^t (t - u) g(u) dif u \
        =& C + C K t + C K^2 t^2 / 2 + integral_0^t (t - u) K integral_0^u g(s) dif s dif u. $

By induction, one can show continued subsitutions generate the terms of the
matrix exponential,

$ g(t) <=& C sum_(k=0)^oo (t K)^k / (k!) = C e^(K t). quad qed $

Which is the bound desired. At this point, I will add an auxillary observation.
The interchange of the $s$ and $u$ integrals turns a double integral into a
convolution between $g$ and the identity function $f(x) = x$. This behavior
of repeated integration may deserve its own post in the future.

= Proof ($2 slash 2$)

This proof will leverage the logarithmic derivative. In my opiniion, this proof
is not as intuitive as the former, although it is just as clear, if not more
so. I just would not have invented the bound like this myself.

Let $G(t) = C + K integral_0^t g(s) dif s$. Now it follows that $0 < G(t)$ and
$g(t) <= G(t)$.

$ (G^(prime)(t)) / G(t) = (K g(t)) / G(t) <= (K G(t)) / G(t) = K $

The second step follows by invokation of the fundamental theorem of calculus.
But notice the first ratio is the logarithmic derivative, so it follows that

$ dif / (dif t) log(G(t)) <= K. $

Integrating both sides and identifying $G(0) = C$ yields the result. $quad qed$
