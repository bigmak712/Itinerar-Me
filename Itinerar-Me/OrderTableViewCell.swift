//
//  OrderTableViewCell.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 5/15/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startTimeTextField.layer.borderWidth = CGFloat(1.0)
        startTimeTextField.layer.cornerRadius = CGFloat(7.0)
        startTimeTextField.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
