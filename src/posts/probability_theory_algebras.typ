A probability space $(Omega, cal(A), PP)$ consists of three elements.

The first element is the _sample space_ $Omega$. It
is the space of all possible events. The second
element is the _$sigma$-algebra_, $cal(A)$. This is a
collection of combinations of events in the sample space. In a
sense, it is a set of sets. The final element is a function
$PP$, which assigns a value to every element in $cal(A)$.
Each element of the probaility space deserves discussion.
This article is dedicated to properties of the $sigma$-algebra
$cal(A)$.

Algebras are collections of sets of $Omega$ satisfying three properties:

- $Omega$ is a member of the algebra. That is,
  the realization of all possible events is contained
  in the algebra.
- The algebra is closed under compliments. The
  compliment (with respect to the set $Omega$) of any
  element in the algebra will yield another element
  in the algebra.
- The algebra is closed under *finite* unions.

The last property is significant, because it is what distinguishes
any algebra on $Omega$ from a _$sigma$-algebra_ on $Omega$.
An algebra is called a $sigma$-algebra if it satisfies the
additional property:

- The algebra is closed under *countable* unions.

This final restriction distinguishes $cal(A)$ from more general
algebras that could be formed on $Omega$.

The collection $cal(A)$ must be a $sigma$-algebra if the triple
$(Omega, cal(A), PP)$ is to be a probability space.
The following results about algebras apply to probability spaces:

*algebras contain $emptyset$* \
All algebras contain the entire sample space $Omega$. All
algebras are also closed under compliment. Therefore, all
algebras contain the compliment of the entire sample space,
$Omega^c$. This set is the empty set $emptyset$.

*algebras are closed under intersection* \
Take a finite union of elements of an algebra. The set formed by
the union is in the contained in the algebra, because of closure under
finite unions. Call this set $B$. The compliment of this set $B^c$ is
also contained in $cal(A)$, because of closure under compliments. By
#link("https://en.wikipedia.org/wiki/De_Morgan%27s_laws")[De Morgan's law],
the compliment of a union of sets (i.e. $B^c$) is equivalent to the
intersection of the compliments of the sets. This shows
that algebras are closed under finite intersections.

Since
#link("https://en.wikipedia.org/wiki/De_Morgan%27s_laws")[De Morgan's law]
extends to countable unions, $sigma$-algebras can be said to be
closed under countably many intersections. Algebras can
generally only be said to be closed under finite intersections.

*algebras are closed under differences* \
Set differences can be stated in terms of intersections, and the result follows.
