//
//  ActivitiesViewController.swift
//  Itinerar-Me
//
//  Created by Sarah Gemperle on 4/26/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    
    var pannedOffPage: Bool?
    var cardInitialCenter: CGPoint!
    var initialPanLocation: CGFloat!
    
    var previousXLocation: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        cardInitialCenter = cardView.center
        previousXLocation = cardInitialCenter.x
    }
    
    @IBAction
    func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let translation = sender.translation(in: view)
        
        let halfPoint = cardView.center.y
        
        if sender.state == .began {
            print("Gesture began")
            //Give an initial rotation
            cardView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            initialPanLocation = location.y
            
            //During user panning:
        } else if sender.state == .changed {
            print("Gesture is changing")
            
            //If x translation great enough, animate off the view.
            if(abs(translation.x) > 120) {
                UIView.animate(withDuration: 0.35, animations: {
                    self.cardView.alpha = 0
                    }, completion: { (bool: Bool) in
                        
                })
            }
            
            cardView.center = CGPoint(x: cardInitialCenter.x + translation.x, y: cardInitialCenter.y + translation.y)
            
            //Tried different options, like a percentage of the translation of x but this random number worked better so 0.026 it is.
            let rotation = (translation.x > 0) ? 0.026 : -0.026
            
            //Started panning in top half.
            if( initialPanLocation <= halfPoint) {
                cardView.transform = cardView.transform.rotated(by: CGFloat(rotation))
                //Started panning in bottom half.
            } else {
                cardView.transform = cardView.transform.rotated(by: CGFloat(-rotation))
            }
            
        } else if sender.state == .ended {
            print("Gesture ended")
            
            //Reset position of card fyi ryan gosling wut a babe :)))
            cardView.center = cardInitialCenter
            cardView.transform = CGAffineTransform.identity
            previousXLocation = cardInitialCenter.x
        }

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
