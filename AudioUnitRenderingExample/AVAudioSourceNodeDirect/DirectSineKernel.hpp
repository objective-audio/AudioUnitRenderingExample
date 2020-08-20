//
//  DirectSineKernel.hpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

#include "SineKernel.h"

struct DirectSineKernel: SineKernel {
    DirectSineKernel(double const sampleRate);
    
    void setFrequency(double const) override;
    
    void render(float * const * const buffers,
                int const bufferCount,
                int const frameCount) override;
    
private:
    double const sampleRate;
    double theta = 0.0;
    std::atomic<double> atomicFrequency = 1000.0;
};
