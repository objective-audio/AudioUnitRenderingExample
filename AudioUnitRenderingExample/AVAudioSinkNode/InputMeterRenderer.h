//
//  InputMeterRenderer.h
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

struct InputMeterRendererValue {
    float const level;
    float const peak;
};

@interface InputMeterRenderer : NSObject

@property (nonatomic, readonly) struct InputMeterRendererValue value;

- (AVAudioSinkNode *)makeSinkNodeWithSampleRate:(double)sampleRate NS_SWIFT_NAME(makeSineNode(sampleRate:));

@end

NS_ASSUME_NONNULL_END
