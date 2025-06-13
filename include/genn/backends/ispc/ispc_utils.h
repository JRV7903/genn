#pragma once

// Forward declarations of ISPC functions for C++ code to call

#ifdef __cplusplus
extern "C" {
#endif

// Neuron update functions
void updateLIFNeurons(float dt, void* group, unsigned int numNeurons, unsigned int batchSize);
void updatePoissonNeurons(float dt, void* group, unsigned int numNeurons, unsigned int batchSize);
void updateSpikeSourceArrayNeurons(float t, void* group, unsigned int numNeurons, unsigned int batchSize);
void updateRulkovMapNeurons(float dt, void* group, unsigned int numNeurons, unsigned int batchSize);
void updateIzhikevichNeurons(float dt, void* group, unsigned int numNeurons, unsigned int batchSize);
void updateIzhikevichVariableNeurons(float dt, void* group, unsigned int numNeurons, unsigned int batchSize);
void updateTraubMilesNeurons(float dt, void* group, unsigned int numNeurons, unsigned int batchSize);

// Spike queue update functions
void updateNeuronSpikeQueue(void* group, unsigned int batchSize);
void updateNeuronSpikeEventQueue(void* group, unsigned int batchSize);

// Previous spike time update functions
void updatePrevSpikeTime(void* group, unsigned int batchSize);
void updatePrevSpikeEventTime(void* group, unsigned int batchSize);

// Random number generation functions
void initRNG(unsigned int seed);
float randUniform();
float randNormal();
float randExponential();
float randLogNormal(float mean, float stdev);
float randGamma(float shape);
unsigned int randBinomial(unsigned int n, float p);

// Batch-specific RNG functions
void initBatchRNG(unsigned int seed, unsigned int batchSize);
float batchRandUniform(unsigned int batchID);
float batchRandNormal(unsigned int batchID);
float batchRandExponential(unsigned int batchID);
float batchRandLogNormal(unsigned int batchID, float mean, float stdev);
float batchRandGamma(unsigned int batchID, float shape);
unsigned int batchRandBinomial(unsigned int batchID, unsigned int n, float p);

// Recordable variable functions
void recordNeuronVariable(void* groupData, unsigned int variableID, float* recordingBuffer, 
                          unsigned int numNeurons, unsigned int timestepIndex, unsigned int batchSize);
void recordNeuronSpikeCount(void* groupData, unsigned int* recordingBuffer,
                           unsigned int numNeurons, unsigned int timestepIndex, unsigned int batchSize);
void recordSynapticVariable(void* groupData, unsigned int variableID, float* recordingBuffer,
                           unsigned int numPre, unsigned int numPost, unsigned int timestepIndex, unsigned int batchSize);

// Custom neuron model functions
void updateCustomNeuron(void* groupData, void* params, float dt, unsigned int numNeurons, unsigned int batchSize);
void updateCustomCurrentSource(void* groupData, void* params, float dt, unsigned int numNeurons, unsigned int batchSize);

#ifdef __cplusplus
}
#endif 