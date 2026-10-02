#import "../theme.typ": hr

The change of variables formulas enable one to derive the probability distribution
of a random variable transformed by a continuous monotonic function. Or sections of
a function that is continuous and monotonic piecewise. This can be done to distributions
of random vectors as well as distributions of random variables --- the rules do
not change majorly.

Using change of variables in the real world is usually tedious, so it usually gets
a bad reputation as a result. It is almost never elegant. The deteminant of the inverse
Jacobian has an interesting geometrical interpretation, but to be frank, the interesting
quality wears thin quickly. Thus my thoughts of this technique for manipulating
probability density functions were not so very high in the past.

But my opinion of this technique has recently flipped upside-down. The change of
variables formula is extremely practical from an engineering standpoint because it
enables on to transform simple probability distributions into very complicated
distributions with minimal dependencies.

Take for instance the uniform distribution. One may implement this distribution
with the #link("https://en.wikipedia.org/wiki/Mersenne_Twister")[Mersenne Twister] algorithm,
or maybe a #link("https://en.wikipedia.org/wiki/Xorshift")[Xorshift], or maybe even something
else. The algorithm is really not of consequence to this discussion. By only implementing one
pseudo-random number generator, an engineer can create normal distributions, log-normal distributions,
exponential distributions, you name it. Just transform the uniform random variable appropriately.

The change of variables formula allow the average engineer to remove dependencies in
their projects. This eliminates surface area for bugs to creep in, complex APIs from
stalling development and maintenance, and a place to focus energy for optimization purposes.
And to top it all off, application of these formulas usually requires nothing more than standard
vector calculus!

For all these reasons, I am beginning to appreciate the change of variables formulas more.

#hr

Example of the Box-Muller transform.

```c
/* Example of the Box-Muller transform */
#include <stdio.h>
#include <stdint.h>
#include <math.h>

/* Mersenne-Twister 64-bit pseudo-random number generator */
#define W 64ULL
#define N 312ULL
#define M 156ULL
#define R 31ULL
#define A 0xB5026F5AA96619E9
#define U 29ULL
#define D 0x5555555555555555
#define S 29ULL
#define B 0x71D67FFFEDA60000
#define T 37ULL
#define C 0xFFF7EEE000000000
#define L 43ULL
#define F 6364136223846793005ULL
#define UMASK (0xFFFFFFFFFFFFFFFF << (R))
#define LMASK (0xFFFFFFFFFFFFFFFF >> ((W)-(R)))

static uint64_t state[N] = {0};
static int index = 0;

void seed_mt64_rand(uint64_t seed) {
    state[0] = seed;
    for (uint64_t i = 1; i < N; i++) {
    seed = F * (seed ^ (seed >> (W - 2))) + i;
    state[i] = seed;
    }
    index = 0;
}

uint64_t mt64_rand(void) {
    int k = index;

    int j = k - (N - 1);
    if (j < 0) j += N;

    uint64_t x = (state[k] & UMASK) | (state[j] & LMASK);
    uint64_t xA = x >> 1;
    if (x & 1) xA ^= A;

    j = k - (N - M);
    if (j < 0) j += N;

    x = state[j] ^ xA;
    state[k++] = x;

    if (k >= N) k = 0;
    index = k;

    x ^= x >> U;
    x ^= (x << S) & B;
    x ^= (x << T) & C;
    x ^= x >> L;
    return x;
}

#undef W
#undef N
#undef M
#undef R
#undef A
#undef U
#undef D
#undef S
#undef B
#undef T
#undef C
#undef L
#undef F
#undef UMASK
#undef LMASK

/* Uniform distribution on interval [0.0, 1.0) */
double uniform(void) {
    return (double)(mt64_rand() >> 11) / (1ULL << 53);
}

/* Exponential distribution parameterized by lambda */
double exponential(double lambda) {
    return -1.0 / lambda * log(uniform());
}

/* Standard normal distribution */
static double saved_normal_realization = 0;
static int box_muller_transform_needs_to_be_computed = 1;
double normal(void) {
    if (box_muller_transform_needs_to_be_computed) {
    box_muller_transform_needs_to_be_computed = 0;

    double r = exponential(0.5);              /* Distribution of radius */
    double t = uniform() * 6.283185307179586; /* Distribution of angles */

    double s = sqrt(r);
    saved_normal_realization = s * sin(t);
    return s * cos(t);
    }
    box_muller_transform_needs_to_be_computed = 1;
    return saved_normal_realization;
}

/* Generate 'SAMPLES' number of standard normal random variable realizations */
#define SAMPLES 10000
int main(void) {
    const uint64_t seed = 12345;
    seed_mt64_rand(seed);

    for (int i = 0; i < samples; i++) {
    printf("%lf\n", normal());
    }

    return 0;
}
```
