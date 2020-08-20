//
//  InputMeterUtils.h
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

#include <math.h>

float linearFromDecibel(float const decibel) {
    return powf(10.0f, decibel / 20.0f);
}

float decibelFromLinear(float const linear) {
    return 20.0f * log10f(linear);
}
