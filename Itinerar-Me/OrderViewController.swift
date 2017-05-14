//
//  OrderViewController.swift
//  Itinerar-Me
//
//  Created by Vicky Tang on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import PopupDialog

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var orderings = ["hello my yellow fellow", "Daniel told me", "to do this", "I want a burrito"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func onDetail(_ sender: Any) {
        let popup = PopupDialog(title: "HELLO", message: "HELLO AGAIN", image: #imageLiteral(resourceName: "Collapse Arrow-50"))
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        popup.addButtons([buttonOne])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for:  indexPath as IndexPath) as! OrderCell
        
        cell.cellLabel.text = orderings[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
