Markov's inequality places an upper bound on the probability that a non-negative
random variable will be greater than a fixed value. Actually, this is a special
case of the more general form of the inequality: Markov is capable of
placing an upper bound on the probability that a non-negative *function*
of a random variable will be greater than a fixed value. This is very useful
when we are interested in estimating the worst-case scenario that a non-negative
random variable exceeds a value.

Formally, Markov's inequality states that the probability that a non-negative
random variable exceeds a fixed value is less than or equal to the expectation
of the random variable divided by the fixed value. If there is a non-negative
function of a random variable involved, the definition changes just slightly:
the probability that a non-negative function of a random variable exceeds a
fixed value is less than or equal to the expectation of the non-negative function
divided by the fixed value. Let's see how this upper bound works in practice,
with this example taken from Wikipedia:

Imagine everyone has a (non-negative) income. Markov's inequality informs
us that no more than ten percent of the population can make more than ten times
the average income. The non-negative random variable in this situation is the
income. The expectation of the income is just the average income. And the fixed
value in this case is ten times the average income. Dividing the expectation of
the income by the fixed value (ten times the expectation of the income) yields
one tenth, or ten percent, as an upper bound.

In the example above, there was no non-negative function applied to the random
variable. But we could apply one to the random variable, and Markov's inequality
would still apply.

In practice, people often invoke Markov's inequality when they want to place an
upper bound on the probability a non-negative random variable can exceed a fixed
value. When showing convergence, this can be useful tool to show that the
upper bound of the magnitude of the difference of two random variables is zero.
Note the magnitude of the difference between two random variables is a non-negative
function.
