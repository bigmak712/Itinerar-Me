//
//  OrderViewController.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 5/15/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class OrderViewController: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!

    var selections: [SelectionsCardFormatted]!
    var firebaseRef = FIRDatabase.database().reference()
    var preferences: Preferences!
    var itineraries = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        self.orderTableView.isEditing = true
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFinish(_ sender: Any) {
        // Save start times in selections
        let cells = self.orderTableView.visibleCells as! Array<OrderTableViewCell>

        var index = 0
        for cell in cells {
            selections[index].startTime = cell.startTimeTextField.text!
            index += 1
        }
        
        //Store itinerary into database
        let key = firebaseRef.child("itineraries").childByAutoId().key
        for selection in selections {
            let itinerary = ["address": selection.address,
                //image: UIImage!
                "name": selection.name!,
                "id": selection.id!,
                "types": selection.types!,
                "rating": selection.rating!,
                "startTime": selection.startTime!] as [String : Any]
            
            itineraries.append(itinerary)
        }
        let childUpdates = ["users/\((FIRAuth.auth()?.currentUser?.uid)!)/\(key)/\(preferences.title!)": itineraries]
        firebaseRef.updateChildValues(childUpdates)
        
        let storyboard = UIStoryboard(name: "Itinerary", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "itineraryVC") as! FinalItineraryViewController
        vc.itinerary = self.selections
        vc.preferences = self.preferences
        self.present(vc, animated: true, completion: nil)
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.selections[sourceIndexPath.row]
        selections.remove(at: sourceIndexPath.row)
        selections.insert(movedObject, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for:  indexPath as IndexPath) as! OrderTableViewCell
        
        cell.nameLabel.text = selections[indexPath.row].name
        cell.addressLabel.text = selections[indexPath.row].address
        
        return cell
    }
}
