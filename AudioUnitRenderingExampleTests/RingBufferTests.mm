//
//  RingBufferTests.m
//  AudioUnitRenderingExampleTests
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "RingBuffer.hpp"

@interface RingBufferTests : XCTestCase

@end

@implementation RingBufferTests

- (void)test_element {
    RingBufferElement element{2};
    
    XCTAssertEqual(element.frameCount(), 2);
    XCTAssertEqual(element.readableData()[0], 0.0f);
    XCTAssertEqual(element.readableData()[1], 0.0f);
    XCTAssertEqual(element.writableData()[0], 0.0f);
    XCTAssertEqual(element.writableData()[1], 0.0f);
}

@end
