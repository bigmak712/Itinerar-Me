//
//  FinalItineraryViewController.swift
//  Itinerar-Me
//
//  Created by Vicky Tang on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import TimelineTableViewCell

class FinalItineraryViewController: UIViewController {
    var itinerary: [SelectionsCardFormatted]!

    @IBOutlet weak var itineraryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itineraryTableView.delegate = self
        itineraryTableView.dataSource = self

        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        itineraryTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
    }
}

extension FinalItineraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
//        let cell = itineraryTableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as! FinalItineraryTableViewCell
//        
//        cell.nameLabel.text = itinerary[indexPath.row].name
//        cell.addressLabel.text = itinerary[indexPath.row].address
        cell.titleLabel.text = "HELLO"
        cell.descriptionLabel.text = itinerary[indexPath.row].name
        
        return cell
    }
}
