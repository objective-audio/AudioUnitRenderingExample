//
//  DeferredSineKernel.hpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

#include "SineKernel.h"
#include <memory>

class RingBuffer;

struct DeferredSineKernel: SineKernel {
    DeferredSineKernel(double const sampleRate);
    ~DeferredSineKernel();
    
    void setFrequency(double const) override;
    
    void render(float * const * const buffers,
                int const bufferCount,
                int const frameCount) override;
    
private:
    std::shared_ptr<RingBuffer> ringBuffer;
};
