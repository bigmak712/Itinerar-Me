//
//  NumberActivitiesViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class NumberActivitiesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activitiesTextField: UITextField!
    @IBOutlet weak var restaurantsTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    
    let dark_green = UIColor(red: 12/255, green: 127/255, blue: 99/255, alpha: 1.0)
    
    var preferences: Preferences!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.borderWidth = CGFloat(1.0)
        backButton.layer.cornerRadius = CGFloat(30.0)
        backButton.layer.borderColor = dark_green.cgColor
        
        finishButton.layer.borderWidth = CGFloat(1.0)
        finishButton.layer.cornerRadius = CGFloat(30.0)
        finishButton.layer.borderColor = dark_green.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        activitiesTextField.underlineTextField()
        restaurantsTextField.underlineTextField()
        
        super.viewDidLayoutSubviews()
    }
    
    func showAlert(title: String, message: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFinish(_ sender: Any) {
        guard activitiesTextField.text != nil else {
            showAlert(title: "Number of Activities Not Found", message: "Enter the Number of Activities")
            return
        }
        
        guard restaurantsTextField.text != nil else {
            showAlert(title: "Number of Restaurants Not Found", message: "Enter the Number of Restaurants")
            return
        }
        
        preferences.numOfActivities = Int(activitiesTextField.text!)
        preferences.numOfRestaurants = Int(restaurantsTextField.text!)
        
        let storyboard = UIStoryboard(name: "Selection", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionViewController
        vc.preferences = self.preferences
        self.present(vc, animated: false, completion: nil)
    }
}
