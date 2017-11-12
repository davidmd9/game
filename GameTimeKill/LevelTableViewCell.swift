//
//  LevelTableViewCell.swift
//  GameTimeKill
//
//  Created by Alana on 12.11.17.
//  Copyright © 2017 David Minasyan. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    @IBOutlet weak var view: DesignableView!

    @IBOutlet weak var status_Label: UILabel!
    @IBOutlet weak var letter_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
