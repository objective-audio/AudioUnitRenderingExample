//
//  SineUtils.cpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#include "SineUtils.hpp"
#include <cmath>
#include <Accelerate/Accelerate.h>

double SineUtils::fillSine(float *buffer,
                           int const frameCount,
                           double const frequency,
                           double const sampleRate,
                           double const inTheta) {
    auto theta = inTheta;
    auto const twoPi = 2.0 * M_PI;
    auto const thetaDiff = frequency / sampleRate * twoPi;

    int frame = 0;
    while (frame < frameCount) {
        buffer[frame] = theta;
        theta = std::fmod(theta + thetaDiff, twoPi);
        ++frame;
    }
    
    vvsinf(buffer, buffer, &frameCount);
    
    float const volume = 0.1f;
    vDSP_vsmul(buffer, 1, &volume, buffer, 1, frameCount);
    
    return theta;
}
