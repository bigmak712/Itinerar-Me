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
        
        self.itineraryTableView.estimatedRowHeight = 300
        self.itineraryTableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension FinalItineraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
//        let itineraryCell = itineraryTableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as! FinalItineraryTableViewCell
//        itineraryCell.nameLabel.text = itinerary[indexPath.row].name
//        itineraryCell.addressLabel.text = itinerary[indexPath.row].address
        
        timelineCell.titleLabel.text = "8:00AM"
        timelineCell.descriptionLabel.font = timelineCell.descriptionLabel.font.withSize(16)
        timelineCell.descriptionLabel.text = "\(itinerary[indexPath.row].name!)\r\(itinerary[indexPath.row].address!)"
        
        return timelineCell
    }
}
