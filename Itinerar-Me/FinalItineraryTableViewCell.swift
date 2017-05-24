//
//  FinalItineraryTableViewCell.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 5/23/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class FinalItineraryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
