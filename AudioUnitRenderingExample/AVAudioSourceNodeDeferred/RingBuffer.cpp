//
//  RingBuffer.cpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#include "RingBuffer.hpp"
#include "SineUtils.hpp"
#include <Accelerate/Accelerate.h>
#include <thread>

#pragma mark -

RingBufferElement::RingBufferElement(std::size_t const length) : rawData(length, 0.0f) {}

RingBufferElement::State RingBufferElement::state() const {
    return static_cast<State>(rawState.load());
}

void RingBufferElement::setState(State const state) {
    rawState.store(state);
}

int RingBufferElement::frameCount() const {
    return static_cast<int>(rawData.size());
}

float *RingBufferElement::writableData() {
    return rawData.data();
}

float const *RingBufferElement::readableData() const {
    return rawData.data();
}

#pragma mark -

RingBuffer::RingBuffer(double const sampleRate) : sampleRate(sampleRate) {
    auto const length = static_cast<std::size_t>(sampleRate);
    for (int i = 0; i < 2; ++i) {
        elements.emplace_back(std::make_unique<RingBufferElement>(length));
    }
}

void RingBuffer::fillSineIfNeeded() {
    for (auto &element : elements) {
        if (element->state() == RingBufferElement::State::writing) {
            theta = SineUtils::fillSine(element->writableData(), element->frameCount(), frequency, sampleRate, theta);
            element->setState(RingBufferElement::State::reading);
            std::this_thread::yield();
        }
    }
}

void RingBuffer::read(float * const * const outBuffers,
                      int const outBufferCount,
                      int const outFrameCount) {
    int outFrame = 0;
    
    while (outFrame < outFrameCount) {
        auto const &element = elements[readElementIndex];
        
        if (element->state() == RingBufferElement::State::reading) {
            int const outRemainFrameCount = outFrameCount - outFrame;
            int const elementFrameCount = element->frameCount();
            int const elementRemainFrameCount = elementFrameCount - readElementFrame;
            int const readFrameCount = std::min(outRemainFrameCount, elementRemainFrameCount);
            
            for (int bufferIndex = 0; bufferIndex < outBufferCount; ++bufferIndex) {
                cblas_scopy(readFrameCount,
                            &element->readableData()[readElementFrame],
                            1,
                            &outBuffers[bufferIndex][outFrame],
                            1);
            }

            readElementFrame += readFrameCount;
            outFrame += readFrameCount;

            if (elementFrameCount <= readElementFrame) {
                elements[readElementIndex]->setState(RingBufferElement::State::writing);
                readElementIndex = (readElementIndex + 1) % elements.size();
                readElementFrame = 0;
            }
        } else {
            // Elementが準備されていないので打ち切る
            break;
        }
    }
}
