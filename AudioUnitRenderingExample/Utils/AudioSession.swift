//
//  AudioSession.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/07/26.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

private func printAudioSession(message: String) {
    let session = AVAudioSession.sharedInstance()
    print("AVAudioSession \(message) sampleRate : \(session.sampleRate) - outputChannelCount : \(session.outputNumberOfChannels) - inputChannelCount : \(session.inputNumberOfChannels)")
}

class AudioSession {
    static let shared = AudioSession()
    
    let rerouteSubject = PassthroughSubject<Void, Never>()
    let lostSubject = PassthroughSubject<Void, Never>()
    
    var hasOutput: Bool { session.outputNumberOfChannels > 0 }
    var hasInput: Bool { session.isInputAvailable && session.inputNumberOfChannels > 0 }
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        let session = AVAudioSession.sharedInstance()
        
        let routePublisher = NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification, object: session)
        
        let routeShared = routePublisher.map { _ in Void() }.receive(on: OperationQueue.main).share()
        routeShared.sink { _ in printAudioSession(message: "routeChanged") }.store(in: &cancellables)
        routeShared.subscribe(rerouteSubject).store(in: &cancellables)
        
        let interruptionPublisher = NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification, object: session)
        let lostPublisher = NotificationCenter.default.publisher(for: AVAudioSession.mediaServicesWereLostNotification, object: session)
        let resetPublisher = NotificationCenter.default.publisher(for: AVAudioSession.mediaServicesWereResetNotification, object: session)
        
        interruptionPublisher
            .merge(with: lostPublisher, resetPublisher)
            .map { _ in Void() }
            .receive(on: OperationQueue.main)
            .subscribe(lostSubject)
            .store(in: &cancellables)
    }
    
    func activate(category: AVAudioSession.Category) throws {
        let session = AVAudioSession.sharedInstance()
        
        try session.setCategory(category)
        try session.setActive(true, options: [])
        
        printAudioSession(message: "activated")
    }
    
    func deactivate() {
        try? session.setActive(false, options: [])
    }
}

private extension AudioSession {
    var session: AVAudioSession { AVAudioSession.sharedInstance() }
}
