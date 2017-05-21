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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func onDetail(_ sender: Any) {
        let popup = PopupDialog(title: "HELLO", message: "HELLO AGAIN", image: #imageLiteral(resourceName: "Collapse Arrow-50"))
        let buttonOne = CancelButton(title: "Cancel", action: nil)
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
        
        cell.nameLabel.text = selections[indexPath.row].name
        
        return cell
    }
}
