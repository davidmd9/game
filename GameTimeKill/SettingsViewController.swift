//
//  SettingsViewController.swift
//  GameTimeKill
//
//  Created by David Minasyan on 12.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var vibroSwitch: UISwitch!
    @IBAction func soundValueChanged(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).setSoundEnabled(enabled: soundSwitch.isOn)
    }
    @IBAction func vibroValueChanged(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).setVibrationEnabled(enabled: vibroSwitch.isOn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        soundSwitch.isOn = (UIApplication.shared.delegate as! AppDelegate).getSoundEnabled()
        vibroSwitch.isOn = (UIApplication.shared.delegate as! AppDelegate).getVibrationEnabled()
    }
}
