//
//  SignUpViewController.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        guard fullNameField.text != nil else {
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
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error == nil {
                print("Sign up success")
                self.dismiss(animated: true, completion: nil)
            }else {
                print(error!.localizedDescription)
            }
        })
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
