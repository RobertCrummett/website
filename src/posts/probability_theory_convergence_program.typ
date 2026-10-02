#import "../theme.typ": hr

Here we write a simple program that demonstrates that a sequence
of random variables converging in probability will demonstrate
_practical_ differences, when compared to a sequence that
converges almost surely. This post was inspired by a lecture given
Dr. Luis Tenorio in mathematical statistics on January 14#super[th],
2026\.

#hr

Sequences of random variables that converge in probability and
sequences of random variables that converge almost surely are
practically distinguishable. We can tell them apart simply by
looking at the sequences for long enough.

The following program will output `n` random
variable's from a sequence that converges in probability, but
not almost surely. If the output is redirected to a plotting
application, one will see for large values `n`, the
function `random_sequence(n)` will still
occasionally return non-zero values that increase in size.

If the function converged in probability to zero, eventually
the values of the function would be bounded above after some
index `n`. Clearly this is not the case for random
sequences that converge in probability. The practical
difference in these sequences is the "spikes" in the values of
the sequence.

#hr

```c
#include <stdio.h>
typedef unsigned long long uint; /* 64-bit integer. */

/* Xorshift pseudo random number generator. */
static uint x = 0x94D34A34EC98EEF3; /* Seed value. */
uint rand(void) {
    return x = (x ^= ((x ^= ((x ^= (x << 13)) >> 7)) << 17));
}

/* Standard uniform distribution. */
double uniform(void) {
    return (double)rand() / 0xFFFFFFFFFFFFFFFF;
}

/* A random sequence that converges in probability,
 * but will not converge almost surely. */
uint random_sequence(uint n) {
    return uniform() < 1.0 / n ? n : 0;
}

int main(void) {
    const uint n = 10000; /* Length of sequence to observe. */

    /* Even for very large values of n, there will still be
     * "spikes". If this random sequence converged almost
     * surely, these spikes would not happen. */
    for (uint i = 1; i < n; i++) {
        printf("%llu\n", random_sequence(i));
    }

    return 0;
}
```
