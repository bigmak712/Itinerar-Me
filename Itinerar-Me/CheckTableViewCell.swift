//
//  CheckTableViewCell.swift
//  Itinerar-Me
//
//  Created by Vicky Tang on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var selections: SelectionsCardFormatted! {
        didSet {
            nameLabel.text = selections.name
            addressLabel.text = selections.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
