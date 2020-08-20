//
//  DeferredSineKernel.cpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#include "DeferredSineKernel.hpp"
#include <thread>
#include "RingBuffer.hpp"

DeferredSineKernel::~DeferredSineKernel() {
    ringBuffer->disposed = true;
}

DeferredSineKernel::DeferredSineKernel(double const sampleRate) : ringBuffer(std::make_shared<RingBuffer>(sampleRate)) {
    std::thread thread{[ringBuffer = ringBuffer]{
        while (!ringBuffer->disposed) {
            ringBuffer->fillSineIfNeeded();
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
        }
    }};
    
    thread.detach();
}

void DeferredSineKernel::setFrequency(double const frequency) {
    ringBuffer->frequency = frequency;
}

void DeferredSineKernel::render(float * const * const buffers,
                                int const bufferCount,
                                int const frameCount) {
    if (bufferCount < 1 || frameCount < 1) {
        return;
    }
    
    ringBuffer->read(buffers, bufferCount, frameCount);
}
