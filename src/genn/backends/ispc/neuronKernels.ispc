// Structure for LIF neuron parameters
struct LIFNeuronParams {
    uniform float Vthresh;     // Threshold voltage
    uniform float Vreset;      // Reset voltage
    uniform float Vrest;       // Resting voltage
    uniform float Vinit;       // Initial voltage
    uniform float TauM;        // Membrane time constant (ms)
    uniform float Ioffset;     // Offset current
    uniform float RefracTime;  // Refractory time (ms)
};

// Structure for Poisson neuron parameters
struct PoissonNeuronParams {
    uniform float rate;        // Mean firing rate (Hz)
};

// Structure for RulkovMap neuron parameters
struct RulkovMapParams {
    uniform float Vspike;      // Spike value
    uniform float alpha;       // Controls subthreshold oscillation
    uniform float y;           // Controls spike shape
    uniform float beta;        // Controls effect of input current
};

// Structure for Izhikevich neuron parameters
struct IzhikevichParams {
    uniform float a;           // Time scale of recovery variable
    uniform float b;           // Sensitivity of recovery variable
    uniform float c;           // After-spike reset value of V
    uniform float d;           // After-spike reset increment of U
};

// Structure for IzhikevichVariable neuron parameters. Needs to implemented in a better way using varying.
struct IzhikevichVariableParams {
    uniform float C;           // Membrane capacitance
    uniform float k;           // Scaling factor
    uniform float vr;          // Resting membrane potential
    uniform float vt;          // Threshold 
    uniform float vpeak;       // Spike peak voltage
    uniform float a;           // Recovery time constant
    uniform float b;           // Resonance parameter 
    uniform float c;           // Recovery voltage
    uniform float d;           // Recovery spike increment
};

// Structure for TraubMiles neuron parameters
struct TraubMilesParams {
    uniform float gNa;         // Na conductance in muS
    uniform float ENa;         // Na equi potential in mV
    uniform float gK;          // K conductance in muS
    uniform float EK;          // K equi potential in mV
    uniform float gl;          // Leak conductance in muS
    uniform float El;          // Leak equi potential in mV
    uniform float C;           // Membrane capacity density in microns^F/cm^2
    uniform float Vthresh;     // Spike threshold in mV
};

// Structure for merged LIF neuron group
struct MergedLIFNeuronGroup {
    // Neuron state variables
    varying float *V;           // Membrane voltage
    varying float *RefracTime;  // Refractory time remaining
    varying int *spiked;        // Whether neuron has spiked
    
    // Input current variables
    varying float *Isyn;        // Synaptic input current
    
    // Parameters
    LIFNeuronParams params;
};

// Structure for merged Poisson neuron group
struct MergedPoissonNeuronGroup {
    // Neuron state variables
    varying unsigned int *timeStepToSpike;  // Time steps until next spike
    varying int *spiked;                    // Whether neuron has spiked
    
    // Parameters
    PoissonNeuronParams params;
};

// Structure for merged SpikeSourceArray neuron group
struct MergedSpikeSourceArrayGroup {
    // Neuron state variables
    varying unsigned int *startSpike;       // Index of next spike time
    varying unsigned int *endSpike;         // Index of last spike time + 1
    varying int *spiked;                    // Whether neuron has spiked
    
    // Global parameters
    uniform float * uniform spikeTimes;     // Array of spike times
};

// Structure for merged RulkovMap neuron group
struct MergedRulkovMapGroup {
    // Neuron state variables
    varying float *V;           // Membrane voltage
    varying int *spiked;        // Whether neuron has spiked
    
    // Input current variables
    varying float *Isyn;        // Synaptic input current
    
    // Parameters
    RulkovMapParams params;
};

// Structure for merged Izhikevich neuron group
struct MergedIzhikevichGroup {
    // Neuron state variables
    varying float *V;           // Membrane voltage
    varying float *U;           // Recovery variable
    varying int *spiked;        // Whether neuron has spiked
    
    // Input current variables
    varying float *Isyn;        // Synaptic input current
    
    // Parameters
    IzhikevichParams params;
};

// Structure for merged IzhikevichVariable neuron group
struct MergedIzhikevichVariableGroup {
    // Neuron state variables
    varying float *V;           // Membrane voltage
    varying float *U;           // Recovery variable
    varying int *spiked;        // Whether neuron has spiked
    
    // Input current variables
    varying float *Isyn;        // Synaptic input current
    
    // Parameters
    IzhikevichVariableParams params;
};

// Structure for merged TraubMiles neuron group
struct MergedTraubMilesGroup {
    // Neuron state variables
    varying float *V;           // Membrane voltage
    varying float *h;           // Na inactivation
    varying float *m;           // Na activation
    varying float *n;           // K activation
    varying int *spiked;        // Whether neuron has spiked
    
    // Input current variables
    varying float *Isyn;        // Synaptic input current
    
    // Parameters
    TraubMilesParams params;
};

// Structure for spike queue management
struct SpikeQueueUpdateGroup {
    // Spike queue pointer (circular buffer index)
    uniform unsigned int *spkQuePtr;
    
    // Number of delay slots
    uniform unsigned int numDelaySlots;
    
    // Spike counts for each delay slot
    uniform unsigned int *spkCnt;
    
    // Spike events
    varying unsigned int *spk;
    
    // Whether spike events are delayed
    uniform bool spikeDelayRequired;
};

// Structure for spike event queue management
struct SpikeEventQueueUpdateGroup {
    // Spike event queue pointer (circular buffer index)
    uniform unsigned int *spkQuePtr;
    
    // Number of delay slots
    uniform unsigned int numDelaySlots;
    
    // Spike event counts for each delay slot
    uniform unsigned int *spkCntEvent;
    
    // Spike events
    varying unsigned int *spkEvent;
    
    // Whether spike events are delayed
    uniform bool spikeEventDelayRequired;
};

// Structure for previous spike time updates
struct PrevSpikeTimeUpdateGroup {
    // Spike queue pointer (circular buffer index)
    uniform unsigned int *spkQuePtr;
    
    // Number of delay slots
    uniform unsigned int numDelaySlots;
    
    // Spike counts for each delay slot
    uniform unsigned int *spkCnt;
    
    // Spike indices
    varying unsigned int *spk;
    
    // Previous spike times
    varying float *prevSpikeTime;
    
    // Whether spike times are delayed
    uniform bool spikeDelayRequired;
    
    // Current simulation time
    uniform float t;
    
    // Time step
    uniform float dt;
    
    // Number of neurons
    uniform unsigned int numNeurons;
};

// Structure for previous spike event time updates
struct PrevSpikeEventTimeUpdateGroup {
    // Spike queue pointer (circular buffer index)
    uniform unsigned int *spkQuePtr;
    
    // Number of delay slots
    uniform unsigned int numDelaySlots;
    
    // Spike event counts for each delay slot
    uniform unsigned int *spkCntEvent;
    
    // Spike event indices
    varying unsigned int *spkEvent;
    
    // Previous spike event times
    varying float *prevSpikeEventTime;
    
    // Whether spike event times are delayed
    uniform bool spikeEventDelayRequired;
    
    // Current simulation time
    uniform float t;
    
    // Time step
    uniform float dt;
    
    // Number of neurons
    uniform unsigned int numNeurons;
};

// Structure for neuron recording
struct NeuronRecordingGroup {
    // Array of pointers to different neuron state variables based on variableID
    uniform varying void * uniform *stateVarPointers;
    
    // Number of recordable variables
    uniform unsigned int numRecordableVars;
    
    // Buffer for recorded variables (indexed by [timestep][neuron])
    uniform varying float *recordingBuffer;
};

// Structure for custom neuron model
struct CustomNeuronGroup {
    // Array of pointers to different neuron state variables
    uniform varying void * uniform *stateVarPointers;
    
    // Array of pointers to parameter values
    uniform varying void * uniform *paramValues;
    
    // Spike flag array
    varying int *spiked;
    
    // Number of neurons
    uniform unsigned int numNeurons;
    
    // Number of state variables
    uniform unsigned int numStateVars;
    
    // Number of parameters
    uniform unsigned int numParams;
    
    // Index of the synaptic input current in stateVarPointers (-1 if not used)
    uniform int isynIndex;
    
    // Function pointer for model simulation code
    uniform void (* uniform simCodeFunc)(uniform CustomNeuronGroup* uniform, varying unsigned int, unsigned int, uniform unsigned int, uniform float, varying int*);
    
    // Function pointer for threshold condition code
    uniform bool (* uniform thresholdConditionFunc)(uniform CustomNeuronGroup* uniform, unsigned int);
    
    // Function pointer for reset code after spike
    uniform void (* uniform resetCodeFunc)(uniform CustomNeuronGroup* uniform, unsigned int);
};

// Structure for custom current source
struct CustomCurrentSourceGroup {
    // Array of pointers to different state variables
    uniform varying void * uniform *stateVarPointers;
    
    // Array of pointers to parameter values
    uniform varying void * uniform *paramValues;
    
    // Target neuron group
    uniform varying void * uniform targetNeuronGroup;
    
    // Number of neurons
    uniform unsigned int numNeurons;
    
    // Number of state variables
    uniform unsigned int numStateVars;
    
    // Number of parameters
    uniform unsigned int numParams;
    
    // Function pointer for current source update
    uniform void (* uniform updateFunc)(uniform CustomCurrentSourceGroup* uniform, unsigned int, uniform float);
};

// Simple RNG state
static uniform unsigned int g_seed = 12345;

// Simple random number generation functions
// This uses a simple LCG (Linear Congruential Generator)
inline uniform unsigned int rand()
{
    g_seed = (1103515245 * g_seed + 12345) & 0x7FFFFFFF;
    return g_seed;
}

// Uniform random number (0-1)
inline uniform float randUniform()
{
    return (float)rand() / (float)0x7FFFFFFF;
}

// ISPC kernel function for updating LIF neurons
export void updateLIFNeurons(
    uniform float dt,                       // Time step (ms)
    uniform MergedLIFNeuronGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,         // Number of neurons
    uniform unsigned int batchSize)          // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying float V = group->V[offset];
            varying float RefracTime = group->RefracTime[offset];
            varying float Isyn = group->Isyn[offset];
            
            // Load neuron parameters (uniform across SIMD lanes)
            uniform float Vthresh = group->params.Vthresh;
            uniform float Vreset = group->params.Vreset;
            uniform float Vrest = group->params.Vrest;
            uniform float TauM = group->params.TauM;
            uniform float Ioffset = group->params.Ioffset;
            uniform float RefracTimeSetting = group->params.RefracTime;
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Decay refractory time
            RefracTime -= dt;
            
            // If out of refractory period
            if (RefracTime <= 0.0f) {
                // Reset refractory time to 0
                RefracTime = 0.0f;
                
                // Membrane potential dynamics: dV/dt = (-(V-Vrest) + Isyn + Ioffset) / TauM
                V += ((-(V - Vrest) + Isyn + Ioffset) / TauM) * dt;
                
                // Check for threshold crossing
                if (V >= Vthresh) {
                    // Reset membrane potential
                    V = Vreset;
                    
                    // Set refractory period
                    RefracTime = RefracTimeSetting;
                    
                    // Set spike flag
                    spiked = 1;
                }
            }
            
            // Store updated state
            group->V[offset] = V;
            group->RefracTime[offset] = RefracTime;
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for updating Poisson neurons
export void updatePoissonNeurons(
    uniform float dt,                       // Time step (ms)
    uniform MergedPoissonNeuronGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,         // Number of neurons
    uniform unsigned int batchSize)          // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying unsigned int timeStepToSpike = group->timeStepToSpike[offset];
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Decrement time to next spike
            timeStepToSpike--;
            
            // If it's time to spike
            if (timeStepToSpike == 0) {
                // Set spike flag
                spiked = 1;
                
                // Calculate time steps until next spike using rate
                // For Poisson process, inter-spike intervals follow exponential distribution
                uniform float rate = group->params.rate;
                
                // Generate a uniform random number and compute interval
                uniform float r = randUniform();
                uniform float interval = -log(r) / rate;  // Exponential distribution
                
                // Convert to time steps, ensure > 0
                timeStepToSpike = (unsigned int)(interval / dt) + 1;
            }
            
            // Store updated state
            group->timeStepToSpike[offset] = timeStepToSpike;
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for updating SpikeSourceArray neurons
export void updateSpikeSourceArrayNeurons(
    uniform float t,                       // Current simulation time (ms)
    uniform MergedSpikeSourceArrayGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,        // Number of neurons
    uniform unsigned int batchSize)         // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying unsigned int startSpike = group->startSpike[offset];
            varying unsigned int endSpike = group->endSpike[offset];
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Check if there are more spikes and if current time matches next spike time
            if (startSpike != endSpike && t >= group->spikeTimes[startSpike]) {
                // Set spike flag
                spiked = 1;
                
                // Move to next spike
                startSpike++;
            }
            
            // Store updated state
            group->startSpike[offset] = startSpike;
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for updating RulkovMap neurons
export void updateRulkovMapNeurons(
    uniform float dt,                       // Time step (ms)
    uniform MergedRulkovMapGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,         // Number of neurons
    uniform unsigned int batchSize)          // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying float V = group->V[offset];
            varying float Isyn = group->Isyn[offset];
            
            // Load neuron parameters (uniform across SIMD lanes)
            uniform float Vspike = group->params.Vspike;
            uniform float alpha = group->params.alpha;
            uniform float y = group->params.y;
            uniform float beta = group->params.beta;
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // RulkovMap neuron dynamics:
            // If V <= 0, calculate V[n+1] = alpha/(1-V[n]) + y + beta*Isyn
            // If V > 0, set V[n+1] = -1
            
            if (V <= 0.0f) {
                V = alpha / (1.0f - V) + y + beta * Isyn;
                
                // Check for spike
                if (V >= Vspike) {
                    spiked = 1;
                }
            } else {
                V = -1.0f;
            }
            
            // Store updated state
            group->V[offset] = V;
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for updating Izhikevich neurons
export void updateIzhikevichNeurons(
    uniform float dt,                      // Time step (ms)
    uniform MergedIzhikevichGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,        // Number of neurons
    uniform unsigned int batchSize)         // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying float V = group->V[offset];
            varying float U = group->U[offset];
            varying float Isyn = group->Isyn[offset];
            
            // Load neuron parameters (uniform across SIMD lanes)
            uniform float a = group->params.a;
            uniform float b = group->params.b;
            uniform float c = group->params.c;
            uniform float d = group->params.d;
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Update membrane potential and recovery variable
            // dV/dt = 0.04*V^2 + 5*V + 140 - U + I
            // dU/dt = a*(b*V - U)
            V = V + dt * (0.04f * V * V + 5.0f * V + 140.0f - U + Isyn);
            U = U + dt * a * (b * V - U);
            
            // Check for threshold crossing (spike detection)
            if (V >= 30.0f) {
                // Reset membrane potential and recovery variable
                V = c;
                U = U + d;
                
                // Set spike flag
                spiked = 1;
            }
            
            // Store updated state
            group->V[offset] = V;
            group->U[offset] = U;
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for updating IzhikevichVariable neurons
export void updateIzhikevichVariableNeurons(
    uniform float dt,                       // Time step (ms)
    uniform MergedIzhikevichVariableGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,         // Number of neurons
    uniform unsigned int batchSize)          // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying float V = group->V[offset];
            varying float U = group->U[offset];
            varying float Isyn = group->Isyn[offset];
            
            // Load neuron parameters (uniform across SIMD lanes)
            uniform float C = group->params.C;
            uniform float k = group->params.k;
            uniform float vr = group->params.vr;
            uniform float vt = group->params.vt;
            uniform float vpeak = group->params.vpeak;
            uniform float a = group->params.a;
            uniform float b = group->params.b;
            uniform float c = group->params.c;
            uniform float d = group->params.d;
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Update membrane potential and recovery variable
            // dV/dt = (k*(V - vr)*(V - vt) - U + Isyn)/C
            // dU/dt = a*(b*(V - vr) - U)
            V = V + dt * ((k * (V - vr) * (V - vt) - U + Isyn) / C);
            U = U + dt * a * (b * (V - vr) - U);
            
            // Check for threshold crossing (spike detection)
            if (V >= vpeak) {
                // Reset membrane potential and recovery variable
                V = c;
                U = U + d;
                
                // Set spike flag
                spiked = 1;
            }
            
            // Store updated state
            group->V[offset] = V;
            group->U[offset] = U;
            group->spiked[offset] = spiked;
        }
    }
}

// Helper functions for TraubMiles
inline float alpham(float V) {
    return 0.32f * (13.0f - (V - (-65.0f))) / (exp((13.0f - (V - (-65.0f))) / 4.0f) - 1.0f);
}

inline float betam(float V) {
    return 0.28f * ((V - (-65.0f)) - 40.0f) / (exp(((V - (-65.0f)) - 40.0f) / 5.0f) - 1.0f);
}

inline float alphah(float V) {
    return 0.128f * exp((17.0f - (V - (-65.0f))) / 18.0f);
}

inline float betah(float V) {
    return 4.0f / (1.0f + exp((40.0f - (V - (-65.0f))) / 5.0f));
}

inline float alphan(float V) {
    return 0.032f * (15.0f - (V - (-65.0f))) / (exp((15.0f - (V - (-65.0f))) / 5.0f) - 1.0f);
}

inline float betan(float V) {
    return 0.5f * exp((10.0f - (V - (-65.0f))) / 40.0f);
}

// ISPC kernel function for updating TraubMiles neurons
export void updateTraubMilesNeurons(
    uniform float dt,                      // Time step (ms)
    uniform MergedTraubMilesGroup* uniform group,  // Merged group data
    uniform unsigned int numNeurons,        // Number of neurons
    uniform unsigned int batchSize)         // Batch size (1 if not batched)
{
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for batching
            unsigned int offset = i + (batchID * numNeurons);
            
            // Load neuron state
            varying float V = group->V[offset];
            varying float h = group->h[offset];
            varying float m = group->m[offset];
            varying float n = group->n[offset];
            varying float Isyn = group->Isyn[offset];
            
            // Load neuron parameters (uniform across SIMD lanes)
            uniform float gNa = group->params.gNa;
            uniform float ENa = group->params.ENa;
            uniform float gK = group->params.gK;
            uniform float EK = group->params.EK;
            uniform float gl = group->params.gl;
            uniform float El = group->params.El;
            uniform float C = group->params.C;
            uniform float Vthresh = group->params.Vthresh;
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Calculate channel dynamics
            varying float mInf = alpham(V) / (alpham(V) + betam(V));
            varying float hInf = alphah(V) / (alphah(V) + betah(V));
            varying float nInf = alphan(V) / (alphan(V) + betan(V));
            
            varying float mTau = 1.0f / (alpham(V) + betam(V));
            varying float hTau = 1.0f / (alphah(V) + betah(V));
            varying float nTau = 1.0f / (alphan(V) + betan(V));
            
            // Update channel variables
            m = mInf + (m - mInf) * exp(-dt / mTau);
            h = hInf + (h - hInf) * exp(-dt / hTau);
            n = nInf + (n - nInf) * exp(-dt / nTau);
            
            // Calculate ionic currents
            varying float INa = gNa * m * m * m * h * (V - ENa);
            varying float IK = gK * n * n * n * n * (V - EK);
            varying float Il = gl * (V - El);
            
            // Update membrane potential
            V += dt * (-(INa + IK + Il) + Isyn) / C;
            
            // Check for threshold crossing
            if (V >= Vthresh) {
                // Set spike flag
                spiked = 1;
            }
            
            // Store updated state
            group->V[offset] = V;
            group->h[offset] = h;
            group->m[offset] = m;
            group->n[offset] = n;
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for spike queue updates
export void updateNeuronSpikeQueue(
    uniform SpikeQueueUpdateGroup* uniform group,   // Spike queue group data
    uniform unsigned int batchSize)                 // Batch size
{
    // Update spike queue pointer - circular buffer
    if (group->spkQuePtr != NULL && group->numDelaySlots > 0) {
        *(group->spkQuePtr) = (*(group->spkQuePtr) + 1) % group->numDelaySlots;
    }

    // Loop over all batches if batching is enabled
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        uniform unsigned int spikeCountIndex;
        
        // Calculate index based on whether delays are required
        if (group->spikeDelayRequired) {
            // Use spike queue pointer and batch ID
            spikeCountIndex = *(group->spkQuePtr);
            if (batchSize > 1) {
                spikeCountIndex += batchID * group->numDelaySlots;
            }
        } else {
            // Without delays, just use batch ID
            spikeCountIndex = (batchSize > 1) ? batchID : 0;
        }
        
        // Reset spike count for this batch/delay slot to zero
        group->spkCnt[spikeCountIndex] = 0;
    }
}

// ISPC kernel function for spike event queue updates
export void updateNeuronSpikeEventQueue(
    uniform SpikeEventQueueUpdateGroup* uniform group,   // Spike event queue group data
    uniform unsigned int batchSize)                      // Batch size 
{
    // Update spike queue pointer - circular buffer (already done in updateNeuronSpikeQueue if both are called)
    if (group->spkQuePtr != NULL && group->numDelaySlots > 0) {
        // Note: In practice, this should share the same queue pointer as regular spikes
        // We assume the queue pointer is already updated by updateNeuronSpikeQueue
    }

    // Loop over all batches if batching is enabled
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        uniform unsigned int spikeCountIndex;
        
        // Calculate index based on whether delays are required
        if (group->spikeEventDelayRequired) {
            // Use spike queue pointer and batch ID
            spikeCountIndex = *(group->spkQuePtr);
            if (batchSize > 1) {
                spikeCountIndex += batchID * group->numDelaySlots;
            }
        } else {
            // Without delays, just use batch ID
            spikeCountIndex = (batchSize > 1) ? batchID : 0;
        }
        
        // Reset spike event count for this batch/delay slot to zero
        group->spkCntEvent[spikeCountIndex] = 0;
    }
}

// ISPC kernel function for updating previous spike times
export void updatePrevSpikeTime(
    uniform PrevSpikeTimeUpdateGroup* uniform group,   // Previous spike time group data
    uniform unsigned int batchSize)                    // Batch size
{
    // Get the last timestep delay slot (before queue pointer was updated)
    uniform unsigned int lastTimestepDelaySlot = 0;
    
    // If delays are required, calculate the last timestep delay slot
    if (group->spikeDelayRequired && group->numDelaySlots > 0) {
        // Queue pointer was already incremented, so subtract 1 and handle wraparound
        lastTimestepDelaySlot = (*(group->spkQuePtr) + group->numDelaySlots - 1) % group->numDelaySlots;
    }
    
    // Loop over all batches if batching is enabled
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        uniform unsigned int spikeCountIndex;
        uniform unsigned int spikeOffset;
        
        // Calculate indices based on whether delays are required
        if (group->spikeDelayRequired) {
            // Use last timestep delay slot and batch ID
            spikeCountIndex = lastTimestepDelaySlot;
            if (batchSize > 1) {
                spikeCountIndex += batchID * group->numDelaySlots;
            }
            spikeOffset = spikeCountIndex * group->numNeurons;
        } else {
            // Without delays, just use batch ID
            spikeCountIndex = (batchSize > 1) ? batchID : 0;
            spikeOffset = (batchSize > 1) ? (batchID * group->numNeurons) : 0;
        }
        
        // Update previous spike times for all neurons that spiked in the last timestep
        uniform unsigned int numSpikes = group->spkCnt[spikeCountIndex];
        
        // Process spikes in SIMD-parallel fashion where possible
        foreach (i = 0 ... numSpikes) {
            // Get neuron index from spike array
            varying unsigned int neuronID = group->spk[spikeOffset + i];
            
            // Calculate neuron offset including batch
            unsigned int neuronOffset = neuronID;
            if (batchSize > 1) {
                neuronOffset += batchID * group->numNeurons;
            }
            
            // Update previous spike time to time of last timestep (t - dt)
            group->prevSpikeTime[neuronOffset] = group->t - group->dt;
        }
    }
}

// ISPC kernel function for updating previous spike event times
export void updatePrevSpikeEventTime(
    uniform PrevSpikeEventTimeUpdateGroup* uniform group,   // Previous spike event time group data
    uniform unsigned int batchSize)                         // Batch size
{
    // Get the last timestep delay slot (before queue pointer was updated)
    uniform unsigned int lastTimestepDelaySlot = 0;
    
    // If delays are required, calculate the last timestep delay slot
    if (group->spikeEventDelayRequired && group->numDelaySlots > 0) {
        // Queue pointer was already incremented, so subtract 1 and handle wraparound
        lastTimestepDelaySlot = (*(group->spkQuePtr) + group->numDelaySlots - 1) % group->numDelaySlots;
    }
    
    // Loop over all batches if batching is enabled
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        uniform unsigned int spikeCountIndex;
        uniform unsigned int spikeOffset;
        
        // Calculate indices based on whether delays are required
        if (group->spikeEventDelayRequired) {
            // Use last timestep delay slot and batch ID
            spikeCountIndex = lastTimestepDelaySlot;
            if (batchSize > 1) {
                spikeCountIndex += batchID * group->numDelaySlots;
            }
            spikeOffset = spikeCountIndex * group->numNeurons;
        } else {
            // Without delays, just use batch ID
            spikeCountIndex = (batchSize > 1) ? batchID : 0;
            spikeOffset = (batchSize > 1) ? (batchID * group->numNeurons) : 0;
        }
        
        // Update previous spike event times for all neurons that had spike events in the last timestep
        uniform unsigned int numSpikeEvents = group->spkCntEvent[spikeCountIndex];
        
        // Process spike events in SIMD-parallel fashion where possible
        foreach (i = 0 ... numSpikeEvents) {
            // Get neuron index from spike event array
            varying unsigned int neuronID = group->spkEvent[spikeOffset + i];
            
            // Calculate neuron offset including batch
            unsigned int neuronOffset = neuronID;
            if (batchSize > 1) {
                neuronOffset += batchID * group->numNeurons;
            }
            
            // Update previous spike event time to time of last timestep (t - dt)
            group->prevSpikeEventTime[neuronOffset] = group->t - group->dt;
        }
    }
}

// ISPC kernel function for recording neuron state variables
export void recordNeuronVariable(
    uniform void* uniform groupData,            // Generic pointer to neuron group data
    uniform unsigned int variableID,            // ID of variable to record
    uniform float* uniform recordingBuffer,     // Recording buffer
    uniform unsigned int numNeurons,            // Number of neurons
    uniform unsigned int timestepIndex,         // Current timestep index in recording buffer
    uniform unsigned int batchSize)             // Batch size
{
    // Cast the groupData to appropriate type based on what we know about the model structure
    // We use a simple approach - the first variableID corresponds to the first state variable
    // and so on, assuming a linear memory layout as defined in the merged group structs
    
    // Calculate buffer offset for the current timestep
    uniform unsigned int bufferOffset = timestepIndex * numNeurons;
    
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Get pointer to batch's data
        uniform varying float* uniform stateVarPtr = NULL;
        
        // Convert the void* to the specific variable pointer based on variableID
        // This is a simplification - in practice we would need to detect the neuron type
        // and access the correct member from the corresponding merged group structure
        
        // Access as a byte array to perform pointer arithmetic on void*
        unsigned char* srcPtr = ((unsigned char*)groupData);
        
        // Assuming the structure layout starts with pointers to state variables
        // The first pointer in each structure is typically to the primary state variable (V)
        // This is a simplification - in real implementation, would need a mapping from variableID to the right offset
        stateVarPtr = (varying float*)(*(void**)(srcPtr + (variableID * sizeof(void*))));
        
        // If we have a valid pointer, copy the data
        if (stateVarPtr != NULL) {
            // Process neurons in SIMD-parallel fashion
            foreach (i = 0 ... numNeurons) {
                // Calculate source and destination offsets
                unsigned int srcOffset = i + (batchID * numNeurons);
                unsigned int destOffset = bufferOffset + i;
                
                // Copy the variable value to the recording buffer
                recordingBuffer[destOffset] = stateVarPtr[srcOffset];
            }
        }
    }
}

// ISPC kernel function for recording neuron spike counts
export void recordNeuronSpikeCount(
    uniform void* uniform groupData,            // Generic pointer to spike queue data
    uniform unsigned int* uniform recordingBuffer, // Recording buffer for spike counts
    uniform unsigned int numNeurons,            // Number of neurons
    uniform unsigned int timestepIndex,         // Current timestep index in recording buffer
    uniform unsigned int batchSize)             // Batch size
{
    // Cast to spike queue update group
    uniform SpikeQueueUpdateGroup* uniform spkGroup = (uniform SpikeQueueUpdateGroup* uniform)groupData;
    
    // Calculate buffer offset for current timestep
    uniform unsigned int bufferOffset = timestepIndex * numNeurons;
    
    // Get current spike queue index
    uniform unsigned int queueIdx = 0;
    if (spkGroup->spkQuePtr != NULL) {
        queueIdx = *(spkGroup->spkQuePtr);
    }
    
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Calculate the index for this batch
        uniform unsigned int batchQueueIdx = queueIdx;
        if (batchSize > 1 && spkGroup->spikeDelayRequired) {
            batchQueueIdx += batchID * spkGroup->numDelaySlots;
        }
        
        // Get spike count for this queue position
        uniform unsigned int numSpikes = spkGroup->spkCnt[batchQueueIdx];
        
        // Get offset in spike array
        uniform unsigned int spkOffset = batchQueueIdx * numNeurons;
        
        // Initialize a local counter array to count spikes per neuron
        uniform unsigned int spikesPerNeuron[numNeurons];
        for (uniform unsigned int n = 0; n < numNeurons; n++) {
            spikesPerNeuron[n] = 0;
        }
        
        // Count spikes for each neuron
        for (uniform unsigned int s = 0; s < numSpikes; s++) {
            uniform unsigned int neuronID = spkGroup->spk[spkOffset + s];
            if (neuronID < numNeurons) {
                spikesPerNeuron[neuronID]++;
            }
        }
        
        // Copy counts to recording buffer
        for (uniform unsigned int n = 0; n < numNeurons; n++) {
            recordingBuffer[bufferOffset + n] = spikesPerNeuron[n];
        }
    }
}

// ISPC kernel function for recording synaptic variables
export void recordSynapticVariable(
    uniform void* uniform groupData,            // Generic pointer to synaptic group data
    uniform unsigned int variableID,            // ID of variable to record
    uniform float* uniform recordingBuffer,     // Recording buffer
    uniform unsigned int numPre,                // Number of presynaptic neurons
    uniform unsigned int numPost,               // Number of postsynaptic neurons
    uniform unsigned int timestepIndex,         // Current timestep index in recording buffer
    uniform unsigned int batchSize)             // Batch size
{
    // This is a placeholder implementation - synaptic recording would depend on
    // the specific synaptic model structures which aren't fully implemented yet
    
    // Calculate buffer offset for current timestep
    uniform unsigned int bufferOffset = timestepIndex * numPre * numPost;
    
    // Access as a byte array to perform pointer arithmetic on void*
    unsigned char* srcPtr = ((unsigned char*)groupData);
    
    // Assuming the first pointer is to the weight matrix in a row-major layout
    uniform varying float* uniform weightPtr = NULL;
    
    // Simplistic approach - assuming variableID 0 is the weight matrix
    if (variableID == 0) {
        weightPtr = (varying float*)(*(void**)(srcPtr));
        
        // If we have a valid weight pointer, copy the data
        if (weightPtr != NULL) {
            // Process all batches
            for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
                // Copy weights for this batch
                for (uniform unsigned int i = 0; i < numPre; i++) {
                    foreach (j = 0 ... numPost) {
                        // Calculate source offset (assuming row-major order)
                        unsigned int srcOffset = (i * numPost) + j;
                        if (batchSize > 1) {
                            srcOffset += batchID * (numPre * numPost);
                        }
                        
                        // Calculate destination offset
                        unsigned int destOffset = bufferOffset + (i * numPost) + j;
                        
                        // Copy weight to recording buffer
                        recordingBuffer[destOffset] = weightPtr[srcOffset];
                    }
                }
            }
        }
    }
}

// ISPC kernel function for updating custom neuron models
export void updateCustomNeuron(
    uniform void* uniform groupData,           // Pointer to custom neuron group data
    uniform void* uniform params,              // Pointer to additional parameter data
    uniform float dt,                          // Timestep
    uniform unsigned int numNeurons,           // Number of neurons
    uniform unsigned int batchSize)            // Batch size
{
    // Cast to custom neuron group
    uniform CustomNeuronGroup* uniform group = (uniform CustomNeuronGroup* uniform)groupData;
    
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for current batch
            unsigned int offset = i + (batchID * numNeurons);
            
            // Initialize spike flag to false
            varying int spiked = 0;
            
            // Access neuron state variables via pointers
            // Note: In a real implementation, the code below would be generated 
            // dynamically based on the model definition
            
            // Setup synaptic input current
            varying float Isyn = 0.0f;
            if (group->numStateVars > 0 && group->isynIndex != -1) {
                float* isyn = (float*)(group->stateVarPointers[group->isynIndex]);
                if (isyn != NULL) {
                    Isyn = isyn[offset];
                }
            }
            
            // Execute simulation code with access to state variables and parameters
            // This section would be replaced with user-defined code in real implementation
            
            // The custom code would be inserted here during code generation,
            // accessing relevant state variables through stateVarPointers
            // and parameters through paramValues
            
            // For example, for an Izhikevich-like model:
            if (group->simCodeFunc != NULL) {
                // Call the model-specific simulation function pointer
                // Note: In a real implementation with JIT, this would be a dynamically compiled function
                group->simCodeFunc(group, i, offset, batchID, dt, &spiked);
            }
            
            // Check threshold condition for spike detection
            if (group->thresholdConditionFunc != NULL) {
                // Call the threshold condition function pointer
                if (group->thresholdConditionFunc(group, offset)) {
                    spiked = 1;
                    
                    // Apply reset code if a spike occurred and reset code exists
                    if (group->resetCodeFunc != NULL) {
                        group->resetCodeFunc(group, offset);
                    }
                }
            }
            
            // Store spike flag in output array
            group->spiked[offset] = spiked;
        }
    }
}

// ISPC kernel function for updating custom current sources
export void updateCustomCurrentSource(
    uniform void* uniform groupData,           // Pointer to custom current source data
    uniform void* uniform params,              // Pointer to additional parameter data
    uniform float dt,                          // Timestep
    uniform unsigned int numNeurons,           // Number of neurons
    uniform unsigned int batchSize)            // Batch size
{
    // Cast to custom neuron group
    uniform CustomCurrentSourceGroup* uniform group = (uniform CustomCurrentSourceGroup* uniform)groupData;
    
    // Process all batches
    for (uniform unsigned int batchID = 0; batchID < batchSize; batchID++) {
        // Process neurons in SIMD-parallel fashion
        foreach (i = 0 ... numNeurons) {
            // Calculate offset for current batch
            unsigned int offset = i + (batchID * numNeurons);
            
            // Execute current source update code
            // This would be replaced with user-defined code in real implementation
            if (group->updateFunc != NULL) {
                group->updateFunc(group, offset, dt);
            }
        }
    }
} 