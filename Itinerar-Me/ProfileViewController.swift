//
//  ProfileViewController.swift
//  Itinerar-Me
//
//  Created by Vicky Tang on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        do {
        try FIRAuth.auth()!.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginVC")
            self.present(vc, animated: true, completion: nil)
        }catch {
            
        }
    }
}
