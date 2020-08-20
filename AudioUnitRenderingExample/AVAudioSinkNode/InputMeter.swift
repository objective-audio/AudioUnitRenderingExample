//
//  InputMeter.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/07/24.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import Foundation
import Combine
import AVFoundation

class InputMeter {
    var value: InputMeterRendererValue { renderer.value }
    
    var lostPublisher: AnyPublisher<Void, Never> { lostSubject.eraseToAnyPublisher() }
    
    private let session: AudioSession
    private var engine: AVAudioEngine?
    private let renderer = InputMeterRenderer()
    private let lostSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    enum StartError: Error {
        case setupAudioSession
        case inputUnavailable
        case startEngine
    }
    
    init(session: AudioSession = .shared) {
        self.session = session
    }
    
    deinit {
        stop()
    }
    
    func start() throws {
        do {
            try session.activate(category: .record)
        } catch {
            throw StartError.setupAudioSession
        }
        
        guard session.hasInput else {
            throw StartError.inputUnavailable
        }
        
        AudioSession.shared.rerouteSubject.sink { [weak self] in
            self?.reroute()
        }.store(in: &cancellables)
        
        AudioSession.shared.lostSubject.subscribe(lostSubject).store(in: &cancellables)
        
        do {
            try setupAndStartEngine()
        } catch {
            throw StartError.startEngine
        }
    }
    
    func stop() {
        disposeEngine()
        
        cancellables.removeAll()
        
        session.deactivate()
    }
}

private extension InputMeter {
    func setupAndStartEngine() throws {
        let engine = AVAudioEngine()
        
        let inputFormat = engine.inputNode.inputFormat(forBus: 0)
        let sinkNode = renderer.makeSineNode(sampleRate: inputFormat.sampleRate);
        
        engine.attach(sinkNode)
        engine.connect(engine.inputNode, to: sinkNode, format: nil)
        
        let outputFormat = engine.inputNode.outputFormat(forBus: 0)
        print("InputMeter Engine - format : \(outputFormat)")
        
        try engine.start()
        
        self.engine = engine
    }
    
    func disposeEngine() {
        engine?.stop()
        engine = nil
    }
    
    func reroute() {
        disposeEngine()
        
        do {
            try setupAndStartEngine()
        } catch {
            self.lostSubject.send()
        }
    }
}
