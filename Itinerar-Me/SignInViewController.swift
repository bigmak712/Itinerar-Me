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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    var firebaseRef: FIRDatabaseReference!
    
    let dark_green = UIColor(colorLiteralRed: 12, green: 127, blue: 99, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.init(red: 12, green: 128, blue: 102, alpha: 1)])
        //passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.cyan])
        
        loginButton.layer.borderWidth = CGFloat(1.0)
        loginButton.layer.cornerRadius = CGFloat(7.0)
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        facebookButton.setBackgroundImage(nil, for: .normal)
        facebookButton.setBackgroundImage(nil, for: .highlighted)
        facebookButton.setTitleColor(UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.5), for: .normal)
        facebookButton.tintColor = UIColor.init(displayP3Red: 0, green: 0, blue: 255, alpha: 0.5)
        
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
    
    override func viewDidLayoutSubviews() {
        emailField.underLineTextField()
        passwordField.underLineTextField()
        
        super.viewDidLayoutSubviews()
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

            let storyboard = UIStoryboard(name: "Order", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "orderVC")
            self.present(vc, animated: false, completion: nil)
        })
    }
}

