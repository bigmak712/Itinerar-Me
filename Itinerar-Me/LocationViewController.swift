//
//  LocationViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var locationTblView: UITableView!
    
    var location: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup table view
        locationTblView.dataSource = self
        locationTblView.delegate = self
        
    }

    func autocomplete() -> [String] {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
