//
//  MenuViewController.swift
//  AudioUnitRenderingExample
//
//  Created by Yuki Yasoshima on 2020/08/15.
//  Copyright © 2020 Yuki Yasoshima. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SineViewController {
            switch segue.identifier {
            case "SourceDirect":
                viewController.setup(sinePlayer: .init(renderer: .init(type: .direct)))
            case "SourceDeferred":
                viewController.setup(sinePlayer: .init(renderer: .init(type: .deferred)))
            default:
                fatalError()
            }
        }
    }
}
