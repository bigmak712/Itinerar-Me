//
//  BudgetViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {

    @IBOutlet weak var budgetSegments: UISegmentedControl!
    
    var preferences: Preferences!
    var maxPrice = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func budgetChanged(_ sender: UISegmentedControl) {
        maxPrice = budgetSegments.selectedSegmentIndex + 1
    }
    
    @IBAction func onNext(_ sender: Any) {
        if budgetSegments.selectedSegmentIndex == 0 {
            preferences.maxPrice = 1
        }else if budgetSegments.selectedSegmentIndex == 1 {
            preferences.maxPrice = 2
        }else if budgetSegments.selectedSegmentIndex == 2 {
            preferences.maxPrice = 3
        }else {
            preferences.maxPrice = 4
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTime" {
            let timeVC = segue.destination as! TimeViewController
            timeVC.preferences = self.preferences
        }
    }
}
