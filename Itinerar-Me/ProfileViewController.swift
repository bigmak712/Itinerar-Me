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
    @IBOutlet weak var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.delegate = self
        profileTableView.dataSource = self
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
    
    @IBAction func onCreateItinerary(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Preferences", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "locationVC")
        self.present(vc, animated: false, completion: nil)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        return cell
    }
    
}
