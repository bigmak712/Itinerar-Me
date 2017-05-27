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

    var firebaseRef = FIRDatabase.database().reference()
    var itineraries = [NSArray]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        firebaseRef.child("users").child(userID!).child("itineraries").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for itinerary in snapshot.children.allObjects as! [FIRDataSnapshot] {
                self.itineraries.append(itinerary.value as! NSArray)
            }
            self.profileTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
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
        return itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        let itineraryArr = itineraries[indexPath.row]
        
        let itinerary = itineraryArr[indexPath.row] as! NSDictionary
        
        cell.titleLabel.text = itinerary["title"] as? String
        
        return cell
    }
    
}
