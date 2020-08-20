//
//  SineKernelTests.mm
//  AudioUnitRenderingExampleTests
//
//  Created by Yuki Yasoshima on 2020/08/10.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DirectSineKernel.hpp"
#import <memory>

static int constexpr bufferCount = 2;
static int constexpr bufferLength = 4;

@interface SineKernelTests : XCTestCase

@end

@implementation SineKernelTests {
    float *buffers[bufferCount];
    float rawBuffers[bufferCount][bufferLength];
}

- (void)setUp {
    for (int i = 0; i < bufferCount; ++i) {
        buffers[i] = rawBuffers[i];
    }
    
    [self resetPtrs];
}

- (void)resetPtrs {
    for (int i = 0; i < bufferCount; ++i) {
        for (int j = 0; j < bufferLength; ++j) {
            buffers[i][j] = 0.0f;
        }
    }
}

- (void)test_サイン波1Hz_サンプリング周波数4Hz {
    auto const data = std::make_shared<DirectSineKernel>(4);
    
    data->setFrequency(1.0);
    
    data->render(buffers, bufferCount, bufferLength);
    
    for (int bufferIndex = 0; bufferIndex < bufferCount; ++bufferIndex) {
        XCTAssertEqual(buffers[bufferIndex][0], 0.0f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][1], 0.1f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][2], 0.0f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][3], -0.1f, 0.0001f);
    }
    
    [self resetPtrs];
    
    data->render(buffers, bufferCount, bufferLength);
    
    for (int bufferIndex = 0; bufferIndex < bufferCount; ++bufferIndex) {
        XCTAssertEqual(buffers[bufferIndex][0], 0.0f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][1], 0.1f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][2], 0.0f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][3], -0.1f, 0.0001f);
    }
}

- (void)test_サイン波1Hz_サンプリング周波数8Hz {
    auto const data = std::make_shared<DirectSineKernel>(8);
    
    data->setFrequency(1.0);
    
    data->render(buffers, bufferCount, bufferLength);
    
    for (int bufferIndex = 0; bufferIndex < bufferCount; ++bufferIndex) {
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][0], 0.0f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][1], 0.0707f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][2], 0.1f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][3], 0.0707f, 0.0001f);
    }
    
    [self resetPtrs];
    
    data->render(buffers, bufferCount, bufferLength);
    
    for (int bufferIndex = 0; bufferIndex < bufferCount; ++bufferIndex) {
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][0], 0.0f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][1], -0.0707f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][2], -0.1f, 0.0001f);
        XCTAssertEqualWithAccuracy(buffers[bufferIndex][3], -0.0707f, 0.0001f);
    }
}

@end
