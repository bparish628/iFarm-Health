//
//  SafetyTableViewCell.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/23/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit

class SafetyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
