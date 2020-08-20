//
//  InputMeterKernel.cpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#include "InputMeterKernel.hpp"
#include "InputMeterUtils.h"
#include <cmath>
#include <Accelerate/Accelerate.h>

InputMeterKernel::Value InputMeterKernel::value() const {
    return InputMeterKernel::Value{.v = atomicValue};
}

void InputMeterKernel::updateLevel(float const * const * const buffers,
                                 int const bufferCount,
                                 int const frameCount,
                                 double const sampleRate) {
    float currentLinear = 0.0f;
    
    int bufferIndex = 0;
    while (bufferIndex < bufferCount) {
        float max = 0.0f;
        vDSP_maxmgv(buffers[bufferIndex], 1, &max, frameCount);
        currentLinear = std::fmax(max, currentLinear);
        ++bufferIndex;
    }
    
    currentLinear = std::fmin(currentLinear, 1.0f);
    
    peakDuration += (double)frameCount / sampleRate;
    
    auto const prevValue = value();
    auto const prevDecibel = decibelFromLinear(prevValue.level) - (float)frameCount / (float)sampleRate * 30.0f;
    auto const prevLinear = linearFromDecibel(prevDecibel);
    auto const nextLinear = std::fmax(prevLinear, currentLinear);
    auto const updatePeak = (prevValue.peak < nextLinear) || (peakDuration > 1.0);
    
    if (updatePeak) {
        peakDuration = 0.0;
    }
    
    Value const value{
        .level = nextLinear,
        .peak = updatePeak ? nextLinear : prevValue.peak
    };
    
    atomicValue = value.v;
}
