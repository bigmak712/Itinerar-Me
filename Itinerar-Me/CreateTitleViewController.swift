//
//  CreateTitleViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class CreateTitleViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
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
        titleTextField.greenUnderlineTextField()
        
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
        guard !(titleTextField.text?.isEmpty)! else {
            showAlert(title: "Enter in a title!", message: "")
            return
        }
        
        preferences.title = titleTextField.text
        
        let storyboard = UIStoryboard(name: "Selection", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionViewController
        vc.preferences = self.preferences
        self.present(vc, animated: false, completion: nil)
    }
}
