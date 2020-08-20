//
//  SinePlayer.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/07/24.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

enum SinePlayerStartError: Error {
    case setupAudioSession
    case outputUnavailable
    case startEngine
}

class SinePlayer {
    @Published var frequency: Double
    
    private let session: AudioSession
    private var engine: AVAudioEngine?
    private let renderer: SineRenderer
    private let lostSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(session: AudioSession = .shared, renderer: SineRenderer) {
        self.session = session
        self.renderer = renderer
        self.frequency = renderer.frequency
    }
    
    deinit {
        stop()
    }

    var frequencyPublisher: AnyPublisher<Double, Never> { $frequency.eraseToAnyPublisher() }
    var lostPublisher: AnyPublisher<Void, Never> { lostSubject.eraseToAnyPublisher() }
    
    func start() throws {
        do {
            try session.activate(category: .playback)
        } catch {
            throw SinePlayerStartError.setupAudioSession
        }
        
        guard session.hasOutput else {
            throw SinePlayerStartError.outputUnavailable
        }
        
        AudioSession.shared.rerouteSubject.sink { [weak self] in
            self?.reroute()
        }.store(in: &cancellables)
        
        AudioSession.shared.lostSubject.subscribe(lostSubject).store(in: &cancellables)
        
        do {
            try setupAndStartEngine()
        } catch {
            throw SinePlayerStartError.startEngine
        }
    }
    
    func stop() {
        disposeEngine()
        
        cancellables.removeAll()
        
        session.deactivate()
    }
}

private extension SinePlayer {
    func setupAndStartEngine() throws {
        let engine = AVAudioEngine()
        
        let outputFormat = engine.outputNode.outputFormat(forBus: 0);
        let sourceNode = renderer.makeSourceNode(format: outputFormat);
        
        engine.attach(sourceNode)
        engine.connect(sourceNode, to: engine.outputNode, format: outputFormat)
        
        $frequency.sink { [weak self] value in
            self?.renderer.frequency = value
        }.store(in: &cancellables)
        
        let inputFormat = engine.outputNode.inputFormat(forBus: 0)
        print("SinePlayer Engine - format : \(inputFormat)")
        
        try engine.start()
        
        self.engine = engine
    }
    
    func disposeEngine() {
        engine?.stop()
        engine = nil
    }
    
    func reroute() {
        do {
            disposeEngine()
            try setupAndStartEngine()
        } catch {
            self.lostSubject.send()
        }
    }
}
