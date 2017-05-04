//
//  NumberActivitiesViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class NumberActivitiesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var activitiesTextField: UITextField!
    @IBOutlet weak var restaurantsTextField: UITextField!
    
    let pickerView = UIPickerView()
    
    var list = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10+"]
    var numActivities = 0
    var numRestaurants = 0
    
    // 1: activities 2: restaurants
    var selectedTextField = 1
    
    var preferences: Preferences!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        activitiesTextField.inputView = pickerView
        restaurantsTextField.inputView = pickerView
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didEditActivities(_ sender: UITextField) {
        selectedTextField = 1
    }

    @IBAction func didEditRestaurants(_ sender: UITextField) {
        selectedTextField = 2
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.view.endEditing(true)
        
        if selectedTextField == 1 {
            activitiesTextField.text = list[row]
            numActivities = row + 1
        }
        else if selectedTextField == 2 {
            restaurantsTextField.text = list[row]
            numRestaurants = row + 1
        }
    }
    
    
    @IBAction func onFinish(_ sender: Any) {
        preferences.numOfActivities = numActivities
        preferences.numOfRestaurants = numRestaurants
        
        let storyboard = UIStoryboard(name: "Selection", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectionVC")
        self.present(vc, animated: false, completion: nil)
    }
}
