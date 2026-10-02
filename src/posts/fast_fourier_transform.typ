#import "../theme.typ": hr

I provide a simple example code to compute the Fast Fourier Transform (FFT) of a
sequence of length $2^n$ where $n$ is an integer. The implementation
only computes the forward transform, discretized in time. The routine does not
precompute the twiddle factors (aka the roots of unity).

This is a discretization in time (DIT) implementation of the FFT.
You can also discretize in frequency (DIF). One would have to slightly
modify the internals of the `fast_fourier_transform` function, but the
changes would be minor.

If the inverse transform is desired, you can compute it using the forward
transform multiple different ways. I prefer to conjugate the series, next
forward transform, and finally conjugate the resulting series. Then I can apply
whatever normalization I desire. But if this is too complicated, you can always
copy and paste the code below, change the function name to `inverse_fast_fourier_transform`
(whatever you prefer) and finally swap the sign of the `angle` variable.
Then that will be an unnormalized inverse FFT.

#hr

```c
/* Fast Fourier Transform (FFT) */
#include <math.h>
#include <stddef.h>
#include <stdint.h>

typedef struct complex_double {
    double real;
    double imag;
} complex_double;

void complex_add_inplace(complex_double *a, complex_double b) {
    a->real += b.real;
    a->imag += b.imag;
}

complex_double complex_sub(complex_double a, complex_double b) {
    return (complex_double){a.real - b.real, a.imag - b.imag};
}

complex_double complex_mul(complex_double a, complex_double b) {
    return (complex_double){a.real * b.real - a.imag * b.imag, a.imag * b.real + a.real * b.imag};
}

void complex_swap(complex_double *a, complex_double *b) {
    uint64_t *ar = (uint64_t *)&a->real;
    uint64_t *ai = (uint64_t *)&a->imag;
    uint64_t *br = (uint64_t *)&b->real;
    uint64_t *bi = (uint64_t *)&b->imag;

    /* Because XOR operates bit-wise, I can independantly swap the real and
     * imaginary components of a and b separately. */
    *br ^= *ar;
    *ar ^= *br;
    *br ^= *ar;

    *bi ^= *ai;
    *ai ^= *bi;
    *bi ^= *ai;
}

/* Fast fourier transform, decimated-in-time (DIT) */
void fast_fourier_transform(complex_double *data, size_t n_samples, size_t stride) {
    /* Bit-wise reversal */
    size_t position, target = 0, half_samples = n_samples >> 1;

    for (position = 0; position < n_samples; position++) {
        if (target > position) {
            size_t ip = position * stride, it = target * stride;
            complex_swap(data + ip, data + it);
        }

        size_t mask = half_samples;

        while (target & mask) {
            target &= ~mask;
            mask >>= 1;
        }
        target |= mask;
    }

    /* Butterfly loops */
    for (size_t span = 1; span < n_samples; span <<= 1) {
        size_t group_step = span << 1;

        for (size_t wing_idx = 0; wing_idx < span; wing_idx++) {

            /* Twiddle factors are the roots of unity. They could be precomputed for speed, but that
             * requires memory management, so I do not want to deal with it now. */
            double angle = -M_PI * wing_idx / span;
            complex_double twiddle = {cos(angle), sin(angle)};

            for (size_t node = wing_idx; node < n_samples; node += group_step) {
                size_t upper_idx = node * stride, lower_idx = (node + span) * stride;

                /* This the the butterfly step. There is only one complex
                 * multiplication to compute two new values. */
                complex_double product = complex_mul(twiddle, data[lower_idx]);
                data[lower_idx] = complex_sub(data[upper_idx], product);
                complex_add_inplace(data + upper_idx, product);
            }
        }
    }
}
```
