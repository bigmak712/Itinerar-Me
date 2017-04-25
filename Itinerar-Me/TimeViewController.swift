//
//  TimeViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//


/* NOTE:
 - Must ensure that the end time is later than the start time
 */


import UIKit

class TimeViewController: UIViewController {

    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
    }
    
    @IBAction func startTimeChanged(_ sender: Any) {
        var dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let timeAsString = dateFormatter.stringFromDate(dateOnPicker)
        //dateFormatter.dateFormat = "HH:mm"
        //var strDate = dateFormatter.stringFromDate(myDatePicker.date)
        self.startTimeLabel.text = timeAsString
    }
    
    @IBAction func endTimeChanged(_ sender: Any) {
        var dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let timeAsString = dateFormatter.stringFromDate(dateOnPicker)
        //dateFormatter.dateFormat = "HH:mm"
        //var strDate = dateFormatter.stringFromDate(myDatePicker.date)
        self.endTimeLabel.text = timeAsString
    }
}
