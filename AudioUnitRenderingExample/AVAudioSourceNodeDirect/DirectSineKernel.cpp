//
//  DirectSineKernel.cpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/06.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#include "DirectSineKernel.hpp"
#include <Accelerate/Accelerate.h>
#include "SineUtils.hpp"

DirectSineKernel::DirectSineKernel(double const sampleRate) : sampleRate(sampleRate) {
}

void DirectSineKernel::setFrequency(double const frequency) {
    atomicFrequency = frequency;
}

void DirectSineKernel::render(float * const * const buffers,
                              int const bufferCount,
                              int const frameCount) {
    if (bufferCount < 1 || frameCount < 1) {
        return;
    }
    
    theta = SineUtils::fillSine(buffers[0], frameCount, atomicFrequency, sampleRate, theta);
    
    for (int bufferIndex = 1; bufferIndex < bufferCount; ++bufferIndex) {
        cblas_scopy(frameCount, buffers[0], 1, buffers[bufferIndex], 1);
    }
}
