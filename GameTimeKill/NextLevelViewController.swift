//
//  NextLevelViewController.swift
//  GameTimeKill
//
//  Created by Alana on 12.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import UIKit

class NextLevelViewController: UIViewController {
    
    var level : Int = 0
    var timeBegin : Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func nextLevel(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameID") as! ViewController
        controller.level = level
        controller.timeBegin = timeBegin
        self.present(controller, animated: true, completion: nil)
    }
}
