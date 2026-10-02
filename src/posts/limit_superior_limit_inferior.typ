#import "../theme.typ": hr

Somehow or another I cannot manage to retain the
properties of the limit superior in my head for
more than ten minutes. This has been plaguing me
for _years_. I am writing this blog to help me
understand and remember these operations, and their
significance in applied mathematics.

#hr

A general sequence may accumulate to a certain
point, or to many points, or to no points. The limit
superior is the largest point about which a
sequence accumulates around. The limit inferior is
the smallest point about which a sequence accumulates.

Now, the limit superior is not necessarily equal to
the largest point in the sequence. The limit
superior may not exist in the sequence. Furthermore,
there may be points in the sequence that are larger
than the limit superior. This is expounded next.

The limit superior is not necessarily equal to the largest
point in the sequence. The limit superior is the largest point
_which a sequence accumulates around_. That is, the limit
superior is the largest of all points that occur infinitely
often in the sequence. There may be larger values than the
limit superior in the sequence, but only finitely many of
these values.

_The above exposition is imprecise.
Technically, there may be infinitely many terms
greater than the limit superior. However, within
an arbitrarily small distance above
the limit superior, there can be only finitely
many points. So we can say that the series
does not stay significantly above the limit
superior for ever --- eventually, one will
fall close to it in a certain sense. The sense
depends on context._

The converse is true for the limit inferior.

The limit superior and limit inferior are quite
closely related. For instance, in set theory,
the complement of the limit superior of a sequence
is equivalent to the limit inferior of the
complement sequence. For real numbers, the limit
superior of a negated sequence is equivalent to
the negated limit inferior. There is a sort of
symmetry here.

The limit superior and limit inferior can be
used to define limits. The limit of a sequence
can be defined as the value of the limit
superior or the limit inferior when the limit
superior and the limit inferior are equivalent.
Where the limit superior and limit inferior are
not equal, the limit does not exist.

The limit superior and limit inferior can
conveniently be defined in terms of
_tail sequences_. Consider an arbitrary
sequence. Now throw away the first $n$ terms of
the sequence. The remaining sequence is the
$n^"th"$ tail sequence, or the remaining terms of
the original sequence.

Now the limit superior can be defined with
tail sequences. The limit superior is the
limit (as $n$ grows large) of the supremum value
of the $n$-th tail sequence. So as the tail
sequence shrinks, each sequence will have some
sort of supremum, or upper bound. The limit
of these values is the limit supremum.

The sequences of the supremum's is strictly
decreasing. Therefore, the limit of this
sequence is equivalent to the infimum of the
sequence. The limit superior is therefore
the infimum of the tail sequences's supremums.

The converse is true of the limit inferior
as well. The limit inferior is defined as
the supremum of the tail sequence's infimums.

The limit superior may not be defined. This
is a technical point, which I am still
learning about. But for sequences of real
numbers, if the underlying space is not
_complete_, the limit superior may
not exist. For sequences of sets, if the
space is not a _complete lattice_, then
the limit superior may not exist. From what
I currently understand, some notion of
completeness needs to be defined on the
underlying space for the limit superior
and limit inferior to exist. I think that
this is why analysts will introduce the extended
real numbers (as opposed to just working with the
real numbers).

The properties of limit superior and limit
inferior result in some neat properties that
I will briefly state.

- The limit inferior is always less than
  or equal to the limit superior.
- In general, the limit superior is less
  than or equal to the supremum of the sequence.
- A sequence converges if and only if
  the limit superior equals the limit
  inferior. The above is true assuming
  the underlying space is complete in
  some sense.\*
- The limit superior is subadditive.
  The limit inferior is superadditive.
  The limit superior and limit inferior
  will be additive when one of the
  sequences converges. The above is
  true assuming infinity is never
  subtracted from infinity.

\* The details of completeness are not completely
clear to me currently. Although I understand
completeness of the real numbers, and analogous
ideas of complete lattices are clear, I do not
understand how these ideas generalize to
arbitrary sequences yet, or how it connects to
the idea of _order_. This is something
to look into in the future.
