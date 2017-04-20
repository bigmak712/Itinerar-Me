//
//  SignInViewController.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 4/10/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email", "public_profile"]
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty else {
            print("NO EMAIL")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            print("NO Password")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error == nil {
                print("SIGN IN SUCCESS")

                let storyboard = UIStoryboard(name: "Preferences", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "locationVC")
                self.present(vc, animated: false, completion: nil)
            }else {
                print(error!.localizedDescription)
            }
        })
    }
}

extension SignInViewController: FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LOGGED OUT")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            print("Access token invalid")
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            let storyboard = UIStoryboard(name: "Preferences", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "locationVC")
            self.present(vc, animated: false, completion: nil)
        })
    }
}

