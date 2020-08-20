//
//  SineUtilsTests.m
//  AudioUnitRenderingExampleTests
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "SineUtils.hpp"
#include <vector>

@interface SineUtilsTests : XCTestCase

@end

@implementation SineUtilsTests

- (void)test_fillSine {
    std::vector<float> buffer(10, 2.0f);
    
    XCTAssertEqual(buffer.size(), 10);
    
    auto const outTheta = SineUtils::fillSine(&buffer.data()[1], 8, 1.0, 8, 0.0);
    
    XCTAssertEqualWithAccuracy(outTheta, 0.0f, 0.000f);
    
    XCTAssertEqual(buffer[0], 2.0f);
    XCTAssertEqualWithAccuracy(buffer[1], 0.0f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[2], 0.0707f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[3], 0.1f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[4], 0.0707f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[5], 0.0f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[6], -0.0707f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[7], -0.1f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[8], -0.0707f, 0.0001f);
    XCTAssertEqual(buffer[9], 2.0f);
}

- (void)test_fillSine_thetaをずらす {
    std::vector<float> buffer(10, 2.0f);
    
    XCTAssertEqual(buffer.size(), 10);
    
    auto const outTheta = SineUtils::fillSine(&buffer.data()[1], 8, 1.0, 8, M_PI);
    
    XCTAssertEqualWithAccuracy(outTheta, M_PI, 0.000f);
    
    XCTAssertEqual(buffer[0], 2.0f);
    XCTAssertEqualWithAccuracy(buffer[1], 0.0f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[2], -0.0707f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[3], -0.1f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[4], -0.0707f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[5], 0.0f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[6], 0.0707f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[7], 0.1f, 0.0001f);
    XCTAssertEqualWithAccuracy(buffer[8], 0.0707f, 0.0001f);
    XCTAssertEqual(buffer[9], 2.0f);
}

@end
