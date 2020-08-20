//
//  SineKernel.h
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

#include <atomic>

/// サイン波再生用の共有データのためのインターフェース
struct SineKernel {
    virtual ~SineKernel() = default;
    
    /// サイン波の周波数をメインスレッドからセットする
    virtual void setFrequency(double const) = 0;
    
    /// 出力するデータをオーディオIOスレッドから取得する
    virtual void render(float * const * const buffers,
                        int const bufferCount,
                        int const frameCount) = 0;
};
