//
//  TextfieldHelper.swift
//  Itinerar-Me
//
//  Created by Daniel Ku on 5/27/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class TextfieldHelper: NSObject {

}

extension UITextField{
    func whiteUnderlineTextField(){
        let border = CALayer()
        let width = CGFloat(0.75)
        border.borderColor = UIColor.white.cgColor
        //border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UITextField{
    func greenUnderlineTextField(){
        let border = CALayer()
        let width = CGFloat(0.75)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
