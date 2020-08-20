//
//  InputMeterRenderer.mm
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import "InputMeterRenderer.h"
#include <memory>
#include "InputMeterKernel.hpp"

@implementation InputMeterRenderer {
    std::shared_ptr<InputMeterKernel> _kernel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _kernel = std::make_shared<InputMeterKernel>();
    }
    return self;
}

- (InputMeterRendererValue)value {
    auto const dataValue = _kernel->value();
    return {.level = dataValue.level, .peak = dataValue.peak};
}

- (AVAudioSinkNode *)makeSinkNodeWithSampleRate:(double)sampleRate {
    return [[AVAudioSinkNode alloc] initWithReceiverBlock:[kernel = _kernel, sampleRate] (const AudioTimeStamp * _Nonnull timestamp,
                                                                                          AVAudioFrameCount frameCount,
                                                                                          const AudioBufferList * _Nonnull inputData) {
        auto const bufferCount = inputData->mNumberBuffers;
        
        float *buffers[bufferCount];
        
        for (uint32_t i = 0; i < bufferCount; ++i) {
            buffers[i] = static_cast<float *>(inputData->mBuffers[i].mData);
        }
        
        kernel->updateLevel(buffers, inputData->mNumberBuffers, frameCount, sampleRate);
        
        return (OSStatus)noErr;
    }];
}
@end
