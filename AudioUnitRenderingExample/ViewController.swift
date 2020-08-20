//
//  ViewController.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/07/24.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import UIKit

class SineViewController: UIViewController {
    var sinePlayer: SinePlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sinePlayer = SinePlayer()
        
        do {
            try sinePlayer.start()
        } catch {
            print("start sine player failed.")
        }
    }


}

