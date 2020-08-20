//
//  InputMeterViewController.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/07/25.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import UIKit
import Combine

class InputMeterViewController: UIViewController {
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var levelConstraint: NSLayoutConstraint!
    @IBOutlet private weak var peakConstraint: NSLayoutConstraint!
    @IBOutlet private weak var meterLabel: UILabel!
    
    private let meter = InputMeter()
    private var displayLink: CADisplayLink?
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        meter.lostPublisher.sink { [weak self] _ in
            self?.showAlert(title: "Lost", message: nil)
        }.store(in: &cancellables)
        
        levelConstraint.constant = 0.0
        peakConstraint.constant = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try meter.start()
        } catch {
            let message = (error as? InputMeter.StartError).flatMap { "\($0)" }
            showAlert(title: "Error", message: message)
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateMeter))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        displayLink?.invalidate()
        displayLink = nil
        
        meter.stop()
    }
}

private extension InputMeterViewController {
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default) { [weak self] _ in self?.popViewController() })
        present(alert, animated: true, completion: nil)
    }
    
    func popViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func updateMeter() {
        let value = meter.value
        
        let maxWidth = baseView.frame.width
        levelConstraint.constant = CGFloat(value.level) * maxWidth
        peakConstraint.constant = CGFloat(value.peak) * maxWidth
        
        let dbValue = String(format: "%.1f", decibelFromLinear(value.peak))
        meterLabel.text = "\(dbValue) dB"
    }
}
