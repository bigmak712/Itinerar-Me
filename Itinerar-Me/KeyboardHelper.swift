//
//  KeyboardHelper.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 5/22/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class KeyboardHelper: NSObject {

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
