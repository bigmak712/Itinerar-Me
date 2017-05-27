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

    let dark_green = UIColor(red: 12/255, green: 127/255, blue: 99/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startTimeTextField.greenUnderlineTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func setStartTime(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(TimeViewController.startPickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func startPickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        startTimeTextField.text = dateFormatter.string(from: sender.date)
        
    }
}
