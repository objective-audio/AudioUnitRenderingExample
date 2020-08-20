//
//  DirectSineRenderer.h
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SineRendererType) {
    SineRendererTypeDirect,
    SineRendererTypeDeferred,
};

@interface SineRenderer : NSObject

@property (nonatomic) double frequency;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SineRendererType)type;

- (AVAudioSourceNode *)makeSourceNodeWithFormat:(AVAudioFormat *)format NS_SWIFT_NAME(makeSourceNode(format:));

@end

NS_ASSUME_NONNULL_END
