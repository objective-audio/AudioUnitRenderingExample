//
//  InputMeterKernelTests.mm
//  AudioUnitRenderingExampleTests
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InputMeterKernel.hpp"
#import <memory>

static int constexpr bufferCount = 2;
static int constexpr length = 2;
static double constexpr sampleRate = length;

@interface InputMeterKernelTests : XCTestCase

@end

@implementation InputMeterKernelTests {
    std::shared_ptr<InputMeterKernel> data;
    float *buffers[bufferCount];
    float rawBuffers[bufferCount][length];
}

- (void)setUp {
    data = std::make_shared<InputMeterKernel>();

    XCTAssertEqual(data->value().level, 0.0);
    XCTAssertEqual(data->value().peak, 0.0);
    
    for (int i = 0; i < bufferCount; ++i) {
        buffers[i] = rawBuffers[i];
    }
    
    [self resetPtrs];
}

- (void)resetPtrs {
    for (int i = 0; i < bufferCount; ++i) {
        for (int j = 0; j < length; ++j) {
            buffers[i][j] = 0.0f;
        }
    }
}

- (void)test_レベルを更新するたびに少しずつレベルが下がる {
    buffers[0][0] = 1.0f;
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqual(data->value().level, 1.0);
    
    buffers[0][0] = 0.0f;
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqualWithAccuracy(data->value().level, 0.0316, 0.0001);
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqualWithAccuracy(data->value().level, 0.001, 0.0001);
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqualWithAccuracy(data->value().level, 0.0, 0.0001);
}

- (void)test_更新時のデータの最大値が自動で下がった値よりも低ければ無視される {
    buffers[0][0] = 1.0;
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqual(data->value().level, 1.0);
    
    buffers[0][0] = 0.03;
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqualWithAccuracy(data->value().level, 0.0316, 0.0001);
}

- (void)test_更新時のデータの最大値が自動で下がった値よりも高ければ上書きされる {
    buffers[0][0] = 1.0;
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqual(data->value().level, 1.0);
    
    buffers[0][0] = 0.04;
    
    data->updateLevel(buffers, bufferCount, length, sampleRate);
    
    XCTAssertEqualWithAccuracy(data->value().level, 0.04, 0.0001);
}

- (void)test_データのどの位置の値でも最大値として扱われる {
    [XCTContext runActivityNamed:@"0番目のポインタの0番目の値でレベルを更新する" block:^(id<XCTActivity> _Nonnull activity) {
        buffers[0][0] = 1.0;
        
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqual(data->value().level, 1.0);
        
        [self resetPtrs];
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqualWithAccuracy(data->value().level, 0.0, 0.0001);
    }];
    
    [XCTContext runActivityNamed:@"0番目のポインタの1番目の値でレベルを更新する" block:^(id<XCTActivity> _Nonnull activity) {
        buffers[0][1] = 1.0;
        
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqual(data->value().level, 1.0);
        
        [self resetPtrs];
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqualWithAccuracy(data->value().level, 0.0, 0.0001);
    }];
    
    [XCTContext runActivityNamed:@"1番目のポインタの0番目の値でレベルを更新する" block:^(id<XCTActivity> _Nonnull activity) {
        buffers[1][0] = 1.0;
        
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqual(data->value().level, 1.0);
        
        [self resetPtrs];
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqualWithAccuracy(data->value().level, 0.0, 0.0001);
    }];
    
    [XCTContext runActivityNamed:@"1番目のポインタの1番目の値でレベルを更新する" block:^(id<XCTActivity> _Nonnull activity) {
        buffers[1][1] = 1.0;
        
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqual(data->value().level, 1.0);
        
        [self resetPtrs];
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        data->updateLevel(buffers, bufferCount, length, sampleRate);
        
        XCTAssertEqualWithAccuracy(data->value().level, 0.0, 0.0001);
    }];
}

@end
