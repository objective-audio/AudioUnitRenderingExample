//
//  SineUtils.hpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

namespace SineUtils {
/// バッファにサイン波を書き込む
/// 返り値は次に書き込む際のinThetaに渡す値を返す
double fillSine(float *buffer,
                int const frameCount,
                double const frequency,
                double const sampleRate,
                double const inTheta);
};
