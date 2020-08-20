//
//  InputMeterKernel.hpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/05.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

#include <atomic>

struct InputMeterKernel {
    /// メーターに表示する値2つをアトミックに扱うための共用体
    /// そんなに厳密にアトミックにするほどのものではないがサンプルとして使っている
    union Value {
        void *v;
        struct {
            float const level;
            float const peak;
        };
    };
    /// Valueのサイズがvoid *のサイズを超えていないことをコンパイル時にチェック
    static_assert(sizeof(Value) == sizeof(void *), "");
    
    /// メーターに表示する値をメインスレッドから取得する。アトミック
    Value value() const;

    /// 入力されたデータを渡しメーターの値をオーディオIOスレッドから更新する
    void updateLevel(float const * const * const buffers,
                     int const bufferCount,
                     int const frameCount,
                     double const sampleRate);
    
private:
    std::atomic<void *> atomicValue;
    double peakDuration = 0.0;
};
