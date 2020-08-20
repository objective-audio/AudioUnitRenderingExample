//
//  RingBuffer.hpp
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

#pragma once

#include <atomic>
#include <vector>
#include <memory>

/// リングバッファの1要素。1秒分のオーディオデータを持つ
struct RingBufferElement {
    /// バッファにアクセスする状態
    /// writingなら書き込みようスレッドから書き込める
    /// readingならオーディオIOスレッドから読み込める
    enum State: int {
        writing,
        reading,
    };
    
    RingBufferElement(std::size_t const length);
    
    /// 状態を取得する。アトミック
    State state() const;
    
    /// 状態をセットする。アトミック
    void setState(State const);
    
    /// バッファの長さ
    int frameCount() const;
    
    /// 書き込み用にデータの先頭ポインタを取得する
    float *writableData();
    
    /// 読み込み用にデータの先頭ポインタを取得する
    float const *readableData() const;
    
private:
    std::vector<float> rawData;
    std::atomic<int> rawState{State::writing};
};

/// オーディオデータの要素を2つ持つリングバッファ
struct RingBuffer {
    /// リングバッファを破棄して良いかのフラグ。trueなら書き込み用スレッドを終了する
    std::atomic<bool> disposed{false};
    
    /// 書き込むサイン波の周波数
    std::atomic<double> frequency{1000.0};
    
    RingBuffer(double const sampleRate);
    
    /// 書き込み可能ならサイン波を書き込む
    void fillSineIfNeeded();
    
    /// 読み込み可能ならデータを読み込む
    void read(float * const * const outBuffers,
              int const outBufferCount,
              int const outFrameCount);
    
private:
    std::vector<std::unique_ptr<RingBufferElement>> elements;
    double const sampleRate;
    int readElementIndex = 0;
    int readElementFrame = 0;
    double theta = 0.0;
};
