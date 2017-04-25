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
    
    var maxPrice = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func budgetChanged(_ sender: UISegmentedControl) {
        maxPrice = budgetSegments.selectedSegmentIndex + 1
    }
    
}
