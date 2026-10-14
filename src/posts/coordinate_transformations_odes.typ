I just learned a new trick to transform systems of ordinary differential
equations in Cartesian coordinates into polar coordinates. It is kind of basic,
but leads to interesting physical interpretations, so I will record it here.

As everyone knows, $x = r cos(theta)$ and $y = r sin(theta)$. We will use
these formula below.

By definition $r^2 = x^2 + y^2$. Taking the derivative with respect to time $t$,

$
2 r dot(r) = 2 x dot(x) + 2 y dot(y) quad arrow.r.double quad r dot(r) = x dot(x) + y dot(y).
$

A formula for $dot(r)$. We can derive a similar formula for $dot(theta)$. Differentiate
the definitions of $x$ and $y$ with respect to $t$:

$
dot(x) &= dot(r) cos(theta) - r dot(theta) sin(theta) \
dot(y) &= dot(r) sin(theta) + r dot(theta) cos(theta),
$

which follows from application of the product rule and chain rule. To isolate $dot(theta)$,
we use a technique. We multiply the equation for $dot(x)$ by a term proportional to
$sin(theta)$, and the equation for $dot(y)$ with a term proportional to $cos(theta)$. We
do this so we can apply the well known identity $cos^2(theta) + sin^2(theta) = 1$.

$
dot(x) y &= dot(r) cos(theta) r sin(theta) - r^2 dot(theta) sin^2(theta) \
dot(y) x &= dot(r) sin(theta) r cos(theta) + r^2 dot(theta) cos^2(theta),
$

Now, subtracting the two expressions allows us to isolate $dot(theta)$ with the
identity:

$
dot(y) x - dot(x) y &= 
dot(r) sin(theta) r cos(theta) + r^2 dot(theta) cos^2(theta) - 
(dot(r) cos(theta) r sin(theta) - r^2 dot(theta) sin^2(theta)) \
&= r^2 dot(theta) cos^2(theta) + r^2 dot(theta) sin^2(theta) \
&= r^2 dot(theta) (cos^2(theta) + sin^2(theta)) \
&= r^2 dot(theta).
$

Relatively simple combinations of the original expressions in terms of $x$, $y$,
$dot(x)$, and $dot(y)$ yield simple expressions in polar coordinates. The term
$r^2 dot(theta)$ bears similarity to the $z$-component of a cross product
$arrow(r) times arrow(v)$, where $arrow(r)$ is the position vector and
$arrow(v)$ is the velocity vector. The term $r dot(r)$ bears similarity to a dot
product $arrow(r) dot arrow(v)$. These are fascinating similarities to me.
