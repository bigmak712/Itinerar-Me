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
import MBProgressHUD

class SignInViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    var firebaseRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let _ = user {
                // User is signed in.
//                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "profileVC")
//                self.present(vc, animated: false, completion: nil)
                
                
            } else {
                // No user is signed in.
            }
        }
        
        firebaseRef = FIRDatabase.database().reference()
        
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
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user: FIRUser?, error: Error?) in
            if error == nil {
                if (accessToken != nil) {
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
                        if error == nil {
                            let userInfo = result as! NSDictionary
                            
                            self.firebaseRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if snapshot.hasChild(userInfo["id"] as! String) {
                                    print("User already exists")
                                }else {
                                    self.firebaseRef.child("users").child(userInfo["id"] as! String).setValue(["email": userInfo["email"], "name": userInfo["name"]])
                                }
                            })
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            }else {
                print(error!.localizedDescription)
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)

            let storyboard = UIStoryboard(name: "Preferences", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "locationVC")
            self.present(vc, animated: false, completion: nil)
        })
    }
}

