//
//  CheckViewController.swift
//  Itinerar-Me
//
//  Created by Vicky Tang on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import PopupDialog

class CheckViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selections: [SelectionsCardFormatted]!
    var finalSelections = [SelectionsCardFormatted]()
    
    var preferences: Preferences?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrderVC" {
            let orderVC = segue.destination as! OrderViewController
            orderVC.selections = finalSelections
        }
    }
    
    @IBAction func onDetail(_ sender: Any) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? CheckTableViewCell {
                    indexPath = tableView.indexPath(for: cell) as NSIndexPath!
                }
            }
        }
        let item = selections[indexPath.row]
                
        let popup = PopupDialog(title: item.name, message: item.address, image: item.image)
        let buttonOne = CancelButton(title: "Close", action: nil)
        popup.addButtons([buttonOne])
        
        self.present(popup, animated: true, completion: nil)
    }
}

extension CheckViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for:  indexPath as IndexPath) as! CheckTableViewCell
        
        cell.selections = selections[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        finalSelections.append(selections[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //finalSelections.remove(at: indexPath.row)
    }
}
