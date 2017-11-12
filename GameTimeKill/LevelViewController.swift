//
//  LevelViewController.swift
//  GameTimeKill
//
//  Created by Alana on 12.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let letters = UserLetters.getInstance()
    let ISOPEN = "Уровень открыт"
    let ISCLOSE = "Уровень закрыт"
    var isSelectIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !letters.getKeys().aLet[0].isActve{
          _ = letters.openLetter(letter: "А")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let d = letters.getKeys()
        print(d.aLet.count)
        return letters.getKeys().aLet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! LevelTableViewCell
        cell.letter_Label.text = letters.getKeys().aLet[indexPath.row].letter
        if letters.getKeys().aLet[indexPath.row].isActve {
            cell.status_Label.text = ISOPEN
            cell.view.backgroundColor = UIColor.green
        }
        else{
            cell.status_Label.text = ISCLOSE
            cell.view.backgroundColor = UIColor.red
        }
        if indexPath.row == isSelectIndex{
            cell.view.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if letters.getKeys().aLet[indexPath.row].isActve{
            isSelectIndex = indexPath.row
        }
        tableView.reloadData()
    }

    @IBAction func playGame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameID") as! ViewController
        controller.level = isSelectIndex
        self.present(controller, animated: true, completion: nil)
    }
}
