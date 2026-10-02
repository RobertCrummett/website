Monotonic sequences are sequences that are non-increasing or non-decreasing. For
the purposes of this write-up, I will work with non-decreasing
sequences specifically for concreteness; however, the results hold for non-increasing sequences as well.

The behavior of any non-decreasing sequence that is bounded above will converge (point-wise) to its
supremum. This statement goes both ways --- a convergent
monotone sequence must be bounded. The monotone convergence theorem establishes this equivalence,
and provides the limit of the sequence is the supremum for non-decreasing sequences. For
non-increasing sequences, the limit is respectively the infimum.

This result holds for sequences of real numbers, but also has application more
widely in functional analysis. The result can be proved using #link("https://en.wikipedia.org/wiki/Fatou%27s_lemma")[Fatou's lemma],
or by using monotonicity of integrals and simple functions to bound the sequences.

This theorem is arguably the simplest way to exchange integration and limits. It comes
with no assumptions about integrability; however, the functions in question must be measurable.
And because the result holds point-wise, it will hold almost surely as well.

Monotone convergence provides some insight into the design of the Lebesgue integral. Lebesgue
integration was _designed_ to work naturally with sequences of increasing (simple) functions.
