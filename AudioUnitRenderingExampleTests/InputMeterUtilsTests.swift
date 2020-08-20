//
//  InputMeterUtilsTests.swift
//  AudioUnitRenderingExampleTests
//
//  Created by Yuki Yasoshima on 2020/08/02.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import XCTest

class InputMeterUtilsTests: XCTestCase {
    func testLinearFromDecibel() throws {
        XCTAssertEqual(linearFromDecibel(Float("-inf")!), 0.0)
        XCTAssertEqual(linearFromDecibel(0.0), 1.0)
        XCTAssertEqual(linearFromDecibel(-20.0), 0.1)
    }
    
    func testDecibelFromLinear() throws {
        XCTAssertEqual(decibelFromLinear(0.0), Float("-inf"))
        XCTAssertEqual(decibelFromLinear(1.0), 0.0)
        XCTAssertEqual(decibelFromLinear(0.1), -20.0)
    }
}
