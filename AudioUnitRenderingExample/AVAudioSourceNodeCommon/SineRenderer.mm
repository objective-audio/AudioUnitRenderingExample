//
//  DirectSineRenderer.mm
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import "SineRenderer.h"
#include "DirectSineKernel.hpp"
#include "DeferredSineKernel.hpp"
#include <memory>

@implementation SineRenderer {
    SineRendererType _type;
    double _frequency;
    std::shared_ptr<SineKernel> _kernel;
}

- (instancetype)initWithType:(SineRendererType)type {
    self = [super init];
    if (self) {
        _type = type;
        _frequency = 1000.0;
    }
    return self;
}

- (double)frequency {
    return _frequency;
}

- (void)setFrequency:(double)frequency {
    _frequency = frequency;
    
    if (_kernel) {
        _kernel->setFrequency(frequency);
    }
}

- (AVAudioSourceNode *)makeSourceNodeWithFormat:(AVAudioFormat *)format {
    switch (_type) {
        case SineRendererTypeDirect:
            _kernel = std::make_shared<DirectSineKernel>(format.sampleRate);
            break;
        case SineRendererTypeDeferred:
            _kernel = std::make_shared<DeferredSineKernel>(format.sampleRate);
            break;
    }
    
    return [[AVAudioSourceNode alloc] initWithFormat:format
                                         renderBlock:[kernel = _kernel] (BOOL * _Nonnull isSilence,
                                                                         const AudioTimeStamp * _Nonnull timestamp,
                                                                         AVAudioFrameCount frameCount,
                                                                         AudioBufferList * _Nonnull outputData) {
        auto const bufferCount = outputData->mNumberBuffers;
        
        float *buffers[bufferCount];
        
        for (uint32_t i = 0; i < bufferCount; ++i) {
            buffers[i] = static_cast<float *>(outputData->mBuffers[i].mData);
        }
        
        kernel->render(buffers, bufferCount, frameCount);
        
        return (OSStatus)noErr;
    }];
}

@end
