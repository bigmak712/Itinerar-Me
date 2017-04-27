//
//  Itinerary.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 4/26/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import GooglePlaces

class Preferences: NSObject {
    var location: GMSPlace?
    var radius: GMSPlace?
    var maxPrice: Int?
    var startTime: String?
    var endTime: String?
}
