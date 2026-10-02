#import "../theme.typ": hr

The basic intuition of the singular value decomposition (SVD) is elaborated.
Some geophysical perspective is drawn in as well, following Dr. William Menke's
book #link("https://www.ldeo.columbia.edu/~menke/www_users_menke/gdadit/index.htm")[Geophysical Data Analysis: Discrete Inverse Theory]
and class notes from Dr. Yaoguo Li's course "Machine Learning and Inverse Theory".

#hr

= Intuition

The SVD can be performed on any real or complex matrix. I am sure it can be performed
on other fields as well, although one may have to write it from scratch. But in essence, the SVD
does not have any special requirements about the dimension or the values of components of the
matrix. It could be a random matrix for all it cares!

The SVD breaks a matrix up into the matrix product of three other matrices. If $G$ is a matrix of
size $N times M$, the SVD of $G = U S V^T$. The matrix $U$ is called the left singular vectors, of size
$N times N$. The singular values are ordered along the diagonal of the matrix $S$ --- otherwise the matrix
is zero. The singular value matrix is of size $N times M$. The last matrix $V$ is the right singular vectors.
It has size $M times M$.

The left and right singular vector matrices ($U$ and $V$ respectively) are both unitary matrices.
Arguably the most important property of unitary matrices is that their transpose is equal to their
own inverse. So $U^H = U^(-1)$ or equivalently $U^H U = U U^H = I$. The
same follows for $V$. Real unitary matrices are usually called orthogonal matrices.

The structure of the singular vector matrices facilitate geometric intuition. A unitary transformation
can be interpreted geometrically as a rotation. (Strictly, this is true only if the determinant is 1. If the
determinant is -1, it can be interpreted as a rotation and a reflection about some hyperplane). Rotations
change the values of components, but not the distances between points.

Based on our intuition about unitary transforms, we can interpret the SVD. The SVD says a matrix
can be interpreted as a rotation, followed by a scaling and reprojection, and finally another rotation.
The interpretation of the singular value matrix $S$ as a scaling and reprojection follows from the
observation that only diagonal values are non zero, they are positive, and always real.
Since the SVD applies to any matrix, it says that any matrix can be interpreted as a rotation,
rescaling, reprojection, and rotation.

#hr

= Relationship to the Eigenvalue Decomposition

While these two transformations look similar, they are only the same when the matrix
in question is positive semi-definite. A simple way to understand they are in general
different is that eigenvalues can be complex and negative --- however, singular
values are always real and strictly non-negative.

If $G$ is the matrix in question, then $U$ corresponds to the eigenvectors of $G G^*$,
where $G^* = V S^(-1) U^T$ is the generalized inverse of the matrix $G$.
The right singular vectors correspond to the eigenvectors of the matrix $G^* G$.

#hr

= Uniqueness

The singular values can be repeated, but the set of singular values is unique.

The singular vectors are another story. They are unique up to a
global multiplication of columns of $U$ and $V$ by a complex phase factor
(or sign for real matrix). But there is another case of non-uniqueness
that plauges singular values regarding degenerate singular values. When
the singular values are repeated, the subspaces of identical singular
values can be rotated by some unitary matrix. (The details are slightly
above my head, so I am not going to elaborate on this technically).

And of course the matrix columns can be permuted, but usually we
prevent this degree of freedom by specifying that the singular values
must be sorted along the diagonal of $S$ in non-increasing order.

Long story short, the SVD decomposition is not unique. The set of singular values are unique.

#hr

= Algorithmic Concerns

Computationally, there are several different ways to compute the SVD. But in general, the
algorithms have cubic temporal complexity and square spatial complexity. So for practical problems,
the SVD can be extremely expensive. Truncating the SVD can save us a lot in space and time, but
asymptotically the cost of the SVD does not change. The algorithms usually solve for the singular
vectors and singular values in decreasing order --- so the smallest singular value is usually the
most expensive to solve for. The largest singular value is usually the cheapest to compute.

// To be written: SVD, Data Null Space, Model Null Space.
