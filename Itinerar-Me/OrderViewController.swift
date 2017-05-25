//
//  OrderViewController.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 5/15/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import TimelineTableViewCell

class OrderViewController: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!

    var selections: [SelectionsCardFormatted]!

    override func viewDidLoad() {
        super.viewDidLoad()

        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.orderTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        self.orderTableView.isEditing = true
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for:  indexPath as IndexPath) as! TimelineTableViewCell
        
        cell.titleLabel.text = selections[indexPath.row].name
        
        var timelineFrontColor = UIColor.clear
       
        /*if (indexPath.row > 0) {
            timelineFrontColor = sectionData[indexPath.row - 1].1
        }*/
       /* cell.timelinePoint = timelinePoint
        cell.timeline.frontColor = timelineFrontColor
        cell.timeline.backColor = timelineBackColor
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.lineInfoLabel.text = lineInfo
        if let thumbnail = thumbnail {
            cell.thumbnailImageView.image = UIImage(named: thumbnail)
        }*/
        
        
        return cell
    }
}
