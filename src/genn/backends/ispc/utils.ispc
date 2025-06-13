#include "utils.isph"

// Simple RNG state
static uniform unsigned int g_seed = 12345;

// Simple random number generation functions
// This uses a simple LCG (Linear Congruential Generator)
// A more sophisticated implementation could use PCG or other better RNGs

// Fast random number generation (uniformly distributed 0-1)
inline uniform unsigned int rand()
{
    g_seed = (1103515245 * g_seed + 12345) & 0x7FFFFFFF;
    return g_seed;
}

// Initialize the random number generator
export void initRNG(uniform unsigned int seed)
{
    g_seed = seed;
}

// Uniform random number (0-1)
export uniform float randUniform()
{
    return (float)rand() / (float)0x7FFFFFFF;
}

// Varying version of uniform random
export varying float randUniform_varying()
{
    varying float result;
    foreach_active(i)
    {
        // Extract a uniform random number for each active lane
        uniform float val = randUniform();
        result = extract(val, i);
    }
    return result;
}

// Box-Muller transform for normal distribution
export uniform float randNormal()
{
    uniform float u1 = randUniform();
    uniform float u2 = randUniform();
    uniform float r = sqrt(-2.0f * log(u1));
    uniform float theta = 2.0f * M_PI * u2;
    return r * cos(theta);
}

// Varying version of normal random
export varying float randNormal_varying()
{
    varying float result;
    foreach_active(i)
    {
        // Extract a normal random number for each active lane
        uniform float val = randNormal();
        result = extract(val, i);
    }
    return result;
}

// Exponential distribution
export uniform float randExponential()
{
    return -log(randUniform());
}

// Varying version of exponential random
export varying float randExponential_varying()
{
    varying float result;
    foreach_active(i)
    {
        // Extract an exponential random number for each active lane
        uniform float val = randExponential();
        result = extract(val, i);
    }
    return result;
}

// Log-normal distribution
export uniform float randLogNormal(uniform float mean, uniform float stdev)
{
    uniform float normal = randNormal();
    return exp(mean + stdev * normal);
}

// Varying version of log-normal random
export varying float randLogNormal_varying(varying float mean, varying float stdev)
{
    varying float normal = randNormal_varying();
    return exp(mean + stdev * normal);
}

// Gamma distribution (using Marsaglia and Tsang's method)
// Only works for shape >= 1
export uniform float randGamma(uniform float shape)
{
    if (shape < 1.0f) {
        // For shape < 1, use alpha = shape + 1 and take power
        uniform float alpha = shape + 1.0f;
        uniform float result = randGamma(alpha);
        uniform float p = randUniform();
        return result * pow(p, 1.0f / shape);
    }
    
    uniform float d = shape - 1.0f / 3.0f;
    uniform float c = 1.0f / sqrt(9.0f * d);
    
    uniform float x, v;
    uniform bool cont = true;
    
    while (cont) {
        uniform float z = randNormal();
        v = 1.0f + c * z;
        
        if (v > 0) {
            v = v * v * v;
            x = d * v;
            
            uniform float u = randUniform();
            if (u < 1.0f - 0.0331f * z * z * z * z || 
                log(u) < 0.5f * z * z + d * (1.0f - v + log(v))) {
                cont = false;
            }
        }
    }
    
    return x;
}

// Varying version of gamma random
export varying float randGamma_varying(varying float shape)
{
    varying float result;
    foreach_active(i)
    {
        // Extract a gamma random number for each active lane
        uniform float s = extract(shape, i);
        uniform float val = randGamma(s);
        result = extract(val, i);
    }
    return result;
}

// Binomial distribution (using direct method for small n, normal approximation for large n)
export uniform unsigned int randBinomial(uniform unsigned int n, uniform float p)
{
    // For small n, use direct method
    if (n < 25) {
        uniform unsigned int count = 0;
        for (uniform unsigned int i = 0; i < n; i++) {
            if (randUniform() < p) {
                count++;
            }
        }
        return count;
    }
    // For large n, use normal approximation with continuity correction
    else {
        uniform float mean = n * p;
        uniform float stdev = sqrt(n * p * (1.0f - p));
        
        // Apply continuity correction and ensure result is in valid range
        uniform float normal = randNormal();
        uniform int result = (int)(mean + stdev * normal + 0.5f);
        
        // Clamp to valid range [0, n]
        if (result < 0) return 0;
        if (result > n) return n;
        
        return (unsigned int)result;
    }
}

// Varying version of binomial random
export varying unsigned int randBinomial_varying(varying unsigned int n, varying float p)
{
    varying unsigned int result;
    foreach_active(i)
    {
        // Extract a binomial random number for each active lane
        uniform unsigned int n_val = extract(n, i);
        uniform float p_val = extract(p, i);
        uniform unsigned int val = randBinomial(n_val, p_val);
        result = insert(result, i, val);
    }
    return result;
}

// Atomic operations
// Note: These are simplified implementations and may not be truly atomic in all SIMD contexts
// For proper atomic operations, target-specific intrinsics may be needed

export uniform float atomicAdd(uniform float * uniform location, uniform float value)
{
    uniform float old = *location;
    *location = old + value;
    return old;
}

export varying float atomicAdd_varying(uniform float * varying location, varying float value)
{
    varying float result;
    foreach_active(i)
    {
        // Convert to a varying result from uniform operations
        uniform float *uni_loc = extract(location, i);
        uniform float uni_val = extract(value, i);
        uniform float old = atomicAdd(uni_loc, uni_val);
        result = insert(result, i, old);
    }
    return result;
}

export uniform int atomicOr(uniform int * uniform location, uniform int value)
{
    uniform int old = *location;
    *location = old | value;
    return old;
}

export varying int atomicOr_varying(uniform int * varying location, varying int value)
{
    varying int result;
    foreach_active(i)
    {
        // Convert to a varying result from uniform operations
        uniform int *uni_loc = extract(location, i);
        uniform int uni_val = extract(value, i);
        uniform int old = atomicOr(uni_loc, uni_val);
        result = insert(result, i, old);
    }
    return result;
} 