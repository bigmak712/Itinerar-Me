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

    
    @IBAction func onSignUp(_ sender: Any) {
        guard let fullName = fullNameField.text, !fullName.isEmpty else {
            print("NO NAME")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            print("NO EMAIL")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            print("NO PASSWORD")
            return
        }
        
        if password != confirmPasswordField.text {
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
