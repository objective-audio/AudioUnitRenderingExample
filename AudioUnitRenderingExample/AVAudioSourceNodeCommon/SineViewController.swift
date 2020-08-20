//
//  ViewController.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/07/24.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import UIKit
import Combine

class SineViewController: UIViewController {
    @IBOutlet private weak var frequencySlider: UISlider!
    
    private var sinePlayer: SinePlayer!
    
    private var cancellables = Set<AnyCancellable>()
    
    func setup(sinePlayer: SinePlayer) {
        self.sinePlayer = sinePlayer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sinePlayer.frequencyPublisher.map { Float($0) }.sink { [weak self] value in
            self?.frequencySlider.value = value
        }.store(in: &cancellables)
        
        sinePlayer.lostPublisher.sink { [weak self] _ in
            self?.showAlert(title: "Lost", message: nil)
        }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try sinePlayer.start()
        } catch {
            let message = (error as? SinePlayerStartError).flatMap { "\($0)" }
            showAlert(title: "Error", message: message)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sinePlayer.stop()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sinePlayer.frequency = Double(sender.value)
    }
}

private extension SineViewController {
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default) { [weak self] _ in self?.popViewController() })
        present(alert, animated: true, completion: nil)
    }
    
    func popViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}
