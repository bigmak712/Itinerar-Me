//
//  SelectionViewController.swift
//  Itinerar-Me
//
//  Created by Sarah Gemperle on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    var isRestaurant: Bool!
    
    /*
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    */
    var pannedOffPage: Bool?
    var cardInitialCenter: CGPoint!
    var initialPanLocation: CGFloat!
    
    var previousXLocation: CGFloat!
    
    /*
     * NEED: -array of Models for Itinerary objects
     *       -Array of Modesl for Itin objects that were
     *        selected by user
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //Initial setup - For UI and Gesture Recognizer.
    func setup() {
        //For card view
        let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        
        //For left and right arrows.
        let leftTapRec = UITapGestureRecognizer(target: self, action: #selector(didTapLeft(sender:)))
        let rightTapRec = UITapGestureRecognizer(target: self, action: #selector(didTapRight(sender:)))
        leftArrow.addGestureRecognizer(leftTapRec)
        rightArrow.addGestureRecognizer(rightTapRec)
        
        //For Tinder animation.
        cardInitialCenter = cardView.center
        previousXLocation = cardInitialCenter.x
        
        cardView.addGestureRecognizer(panGestureRec)
        
        //Load images.
        leftArrow.image = #imageLiteral(resourceName: "Left-50")
        rightArrow.image = #imageLiteral(resourceName: "Right-50")
        
    }
    
    @IBAction
    func didTapRight(sender: UITapGestureRecognizer) {
        animateAndLoadNew(currTranslation: 1)
    }
    
    @IBAction
    func didTapLeft(sender: UITapGestureRecognizer) {
        animateAndLoadNew(currTranslation: -1)
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
            
            let currTranslation = translation.x
            
            //If x translation great enough, animate off the view.
            if(abs(currTranslation) > 150) {
                animateAndLoadNew(currTranslation: Int(currTranslation))
                return
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
    
    func animateAndLoadNew(currTranslation: Int) {
        UIView.animate(withDuration: 0.35, animations: {
            self.cardView.alpha = 0
            if(currTranslation > 0) {
                self.cardView.center = CGPoint(x: self.cardInitialCenter.x + self.view.frame.width, y: self.cardInitialCenter.y)
            } else {
                self.cardView.center = CGPoint(x: self.cardInitialCenter.x - self.view.frame.width, y: self.cardInitialCenter.y)
            }
            }, completion: { (bool: Bool) in
                
                //TODO: Do something here.. Either add to itinerary array, or don't
                self.cardView.center = CGPoint(x: self.cardInitialCenter.x, y: self.cardInitialCenter.y)
                //If Swipe right :)
                if(currTranslation > 0) {
                    
                    
                    //If user Swiped left :(
                } else {
                    
                }
                //self.cardImageView.image = something else
                //self.cardLabel.text = something else
                
                //TODO: Add a new view from database.
                
        })
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
