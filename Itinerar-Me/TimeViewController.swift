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
        
        self.hideKeyboardWhenTappedAround()
        
        backButton.layer.borderWidth = CGFloat(1.0)
        backButton.layer.cornerRadius = CGFloat(30.0)
        backButton.layer.borderColor = dark_green.cgColor
        
        nextButton.layer.borderWidth = CGFloat(1.0)
        nextButton.layer.cornerRadius = CGFloat(30.0)
        nextButton.layer.borderColor = dark_green.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        startTimeTextField.greenUnderlineTextField()
        endTimeTextField.greenUnderlineTextField()
        
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        // Alert Messages
        if (startTimeTextField.text?.isEmpty)! {
            showAlert(title: "Start Time Not Found", message: "Enter a Start Time")
        }
        else if (endTimeTextField.text?.isEmpty)!  {
            showAlert(title: "End Time Not Found", message: "Enter a End Time")
        }
            
        /*
        else if (compareTimes(time1: startTimeTextField.text!, time2: endTimeTextField.text!) == -1) {
            showAlert(title: "End Time is Before Start Time", message: "Enter Valid Start/End Times")
        }
        
        else if (compareTimes(time1: startTimeTextField.text!, time2: endTimeTextField.text!) == 0) {
            showAlert(title: "Warning: Short Time Length", message: "You might not have enough time to do activities")
        }*/
        
        guard let startTime = startTimeTextField.text, !startTime.isEmpty else {
            return
        }
        
        guard let endTime = endTimeTextField.text, !endTime.isEmpty else {
            return
        }
        
        preferences.startTime = startTime
        preferences.endTime = endTime
    }
    
    /*
    // Return -1 if the time is invalid
    // Return 0 if the time is short
    // Return 1 if the time is longer than an hour
    func compareTimes(time1: String, time2: String) -> Int {
        let startTime = Array(time1.characters)
        let endTime = Array(time2.characters)
        
        let meridian1 = startTime[time1.characters.count - 2]
        let meridian2 = endTime[time2.characters.count - 2]
        
        let hourMinutes1 = time1.components(separatedBy: ":")
        let hourMinutes2 = time2.components(separatedBy: ":")
        
        let hour1 = Int(hourMinutes1[0])!
        let hour2 = Int(hourMinutes2[0])!

    
        // startTime is PM, endTime is AM
        if(String(meridian1) > String(meridian2)) {
            return -1
        }
        // startTime is AM, endTime is PM
        else if(String(meridian1) <= String(meridian2)) {
            if hour1 == 11 && hour2 == 12 {
                return 0
            }
            return 1
        }
        
        // startTime & endTime are either both AM or PM
        
        // time difference is around an hour
        if abs(hour2 - hour1) <= 1 {
            return 0
        }
        
        // time difference is longer than an hour
        return 1
    }
    */
    
    func showAlert(title: String, message: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateTitleVC" {
            let createTitleVC = segue.destination as! CreateTitleViewController
            createTitleVC.preferences = self.preferences
        }
    }
}
