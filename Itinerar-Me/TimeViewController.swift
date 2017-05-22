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
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let dark_green = UIColor(red: 12/255, green: 127/255, blue: 99/255, alpha: 1.0)
    
    var preferences: Preferences!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.borderWidth = CGFloat(1.0)
        backButton.layer.cornerRadius = CGFloat(30.0)
        backButton.layer.borderColor = dark_green.cgColor
        
        nextButton.layer.borderWidth = CGFloat(1.0)
        nextButton.layer.cornerRadius = CGFloat(30.0)
        nextButton.layer.borderColor = dark_green.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        startTimeTextField.underlineTextField()
        endTimeTextField.underlineTextField()
        
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func startTime(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(TimeViewController.startPickerValueChanged), for: UIControlEvents.valueChanged)
    }

    @IBAction func endTime(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(TimeViewController.endPickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func startPickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        startTimeTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func endPickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        endTimeTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func onNext(_ sender: Any) {
        guard let startTime = startTimeTextField.text, !startTime.isEmpty else {
            return
        }
        
        guard let endTime = endTimeTextField.text, !endTime.isEmpty else {
            return
        }
        
        preferences.startTime = startTime
        preferences.endTime = endTime
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toActivities" {
            let activitiesVC = segue.destination as! NumberActivitiesViewController
            activitiesVC.preferences = self.preferences
        }
    }
}
