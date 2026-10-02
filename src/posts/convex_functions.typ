In preparation for a post about the gamma function, I thought
it would be fitting to first review _convex functions_ and
their properties. First, a definition.

// Definition of a convex function
*A function is convex if and only if the function is less than
or equal to a straight line between any two points in its
domain.*

In other words, convex functions are bowl shaped in between any
two points, such that if a straight line were drawn in between
these two points, the function would never cross the line. This
definition is good for functions that map to the real numbers
$RR$.

A function that maps to the extended real numbers (i.e. the
real numbers and plus infinity and negative infinity) can also
be convex. But one has to be careful about the points selected.

First of all, the line joining two points along the function
can get us into trouble. The easiest way to define a line
between two points is to use a parameterization. But if the
parameterization variable is zero, then we could potentially
multiply infinity by zero! This is undefined behavior. The
remedy is to exclude the two end points from the definition of
convexity --- so convexity is defined on the open set
between any two points of a function. The two points will form
a set of measure zero, so we do not get into too much trouble
doing this.

The second issue is the addition in the parameterization,
because the sum of positive infinity and negative infinity is
undefined. To remedy this, we permit the function that maps to
the extended real numbers is not allowed to take both positive
*and* negative infinity as values. Take your pick, only
one is usually allowed.

Sometimes, people emphasize whether or not the convex function
ever touches the bounding line. Recall, a convex function is
defined as a function less than _or equal to_ a line
joining any two points along the function. If the function is
never equal to the straight line, then the function is a
_strictly-convex_ function.

== Properties

Convexity is a powerful property, and much can be said about
convex functions. I will cover some basic results about convex
functions that are useful to know.

*The sum of convex functions is a convex function.* \
This is intuitive. Two bowl shaped functions, when summed, will
still appear to be bowl shaped.

*The limit of a convergent sequence of convex functions is a convex function.* \
This is merely the limiting case of the previous argument.

*The limit of a convergent series of convex functions is a convex function.* \
Each partial sum of the series will be a convex function. Since
the limit of the series is defined as the limit of the sequence of
partial sums, the series will converge to a convex function.

*A function is convex if and only if the function has monotonically increasing one-sided derivatives.* \
A convex function's derivatives can only go up or stay
constant. If the derivatives ever got smaller, then there would
be a location where we could fit a line under the function.
This result is often stated a little more loosely: a function
is convex if an only if its second derivative, or curvature, is
greater than or equal to zero.

*A minimum of a convex function is the global minimum.* \
Think bowl shaped. There can only be one bottom.

*Jensen's inequality applies to every convex function.* \
Jensen's inequality says that the value of a convex function at
an integral will be less than or equal to the integral of the
convex function. This statement is a generalization of the
definition of a convex function --- that is, that the
function will live below a straight line joining two points. So
we can change what it means to measure some function, but we do
not have to leave behind the ideas of convexity.

*A constant function is convex.* \
