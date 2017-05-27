//
//  SignUpViewController.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    var firebaseRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        firebaseRef = FIRDatabase.database().reference()
        
        let buttonBorderWidth = CGFloat(1.0)
        let buttonCornerRadius = CGFloat(7.0)
        
        signupButton.layer.borderWidth = buttonBorderWidth
        signupButton.layer.cornerRadius = buttonCornerRadius
        signupButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        fullNameField.whiteUnderlineTextField()
        emailField.whiteUnderlineTextField()
        passwordField.whiteUnderlineTextField()
        confirmPasswordField.whiteUnderlineTextField()
        
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
    
    @IBAction func onSignUp(_ sender: Any) {
        guard let fullName = fullNameField.text, !fullName.isEmpty else {
            // Alert Messages
            if (fullNameField.text?.isEmpty)! {
                showAlert(title: "No Name Found", message: "Enter your full name")
            }
            
            print("NO NAME")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            // Alert Messages
            if (emailField.text?.isEmpty)! {
                showAlert(title: "No Email Found", message: "Enter your email")
            }
            
            print("NO EMAIL")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            // Alert Messages
            if (passwordField.text?.isEmpty)! {
                showAlert(title: "No Password Found", message: "Enter your password")
            }
            
            print("NO PASSWORD")
            return
        }
        
        if ((passwordField.text?.characters.count)! < 6 && (passwordField.text?.characters.count)! > 0) {
            showAlert(title: "Password Length is Invalid", message: "The password must be at least 6 characters long")
        }
        
        if password != confirmPasswordField.text {
            // Alert Messages
            showAlert(title: "Passwords Don't Match", message: "Re-enter your passwords")
            
            print("PASSWORDS DON'T MATCH")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)

            if error == nil {
                self.firebaseRef.child("users").child(user!.uid).setValue(["email": email, "name": fullName])
                let storyboard = UIStoryboard(name: "Preferences", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "locationVC")
                self.present(vc, animated: false, completion: nil)
            }else {
                print(error!.localizedDescription)
            }
        })
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
