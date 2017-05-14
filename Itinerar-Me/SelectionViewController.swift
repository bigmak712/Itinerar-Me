//
//  SelectionViewController.swift
//  Itinerar-Me
//
//  Created by Sarah Gemperle on 5/3/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import AlamofireImage

class SelectionViewController: UIViewController {

    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    let apiKey = "AIzaSyDWgrglpRDRqRVwPJMo-SkTq5xg7kJS0hk"
    
    var isRestaurant: Bool!
    var pannedOffPage: Bool?
    var cardInitialCenter: CGPoint!
    var initialPanLocation: CGFloat!
    var preferences: Preferences!
    
    var activityArray: NSArray?
    var restArray: NSArray?
    var activityJSON: NSDictionary?
    var restJSON: NSDictionary?
    var nextPageTokenRest: String?
    var nextPageTokenAct: String?
    
    var restIndex: Int = 0
    var activityIndex: Int = 0
    
    //Whether a restaurant will be shown or an activity. 0 for rest, 1 for act.
    var nextType: Int = 0
    
    var previousXLocation: CGFloat!
    
    
    /*
     * NEED: -array of Models for Itinerary objects
     *       -Array of Modesl for Itin objects that were
     *        selected by user
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRestauraunts(preferences: preferences, success: { (result: Bool) in
            if(result) {
                print("SUCCESS in fetching results. it had stuff in the query")
                print(self.restArray!.count)
                
                //Format first card for view.
                let place: SelectionsCardFormatted = self.formatPlaceForCard(dict: self.restArray?[self.restIndex] as! NSDictionary)
                self.formatCardUI(place: place)
                self.restIndex += 1
                self.nextType = 1
                
            } else {
                print("Your filters gave no results RIP. :((")
            }
        }) { (error: Error?) in
                print("Error loading results \(error?.localizedDescription)")
        }
        
        fetchActivities(preferences: preferences, success: { (result: Bool) in
            if(result) {
                print("SUCCESS in fetching results. it had stuff in the query")
                print(self.activityArray!.count)
            } else {
                print("Your filters gave no results RIP. :((")
            }
        }) { (error: Error?) in
            print("Error loading results \(error?.localizedDescription)")
        }
        
        setup()
    }
    
    //Initial setup - For UI and Gesture Recognizer.
    func setup() {
        
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 6
        
        //Initialize indeces for places
        restIndex = 0
        activityIndex = 0
        
        //GESTURE RECOGNIZERS
        //For card view
        let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        cardView.addGestureRecognizer(panGestureRec)

        
        //For Tinder animation.
        cardInitialCenter = cardView.center
        previousXLocation = cardInitialCenter.x
        
    }
    
    func formatCardUI(place: SelectionsCardFormatted?) {
        if (place == nil) {
            print("passed in a nil place for formatting card :(")
            return
        }
        
        nameLabel.text = place!.name
        addressLabel.text = place!.address
        
        for i in place!.types {
            categoriesLabel.text = categoriesLabel.text! + ", " + i
        }
        
        ratingLabel.text = place!.rating
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
            if(abs(currTranslation) > 175) {
                animateAndLoadNew(currTranslation: Int(currTranslation))
                return
            }
            
            cardView.center = CGPoint(x: cardInitialCenter.x + translation.x, y: cardInitialCenter.y + translation.y)
            
            //Tried different options, like a percentage of the translation of x but this random number worked better so 0.026 it is.
            let rotation = (translation.x > 0) ? 0.02 : -0.02
            
            //Started panning in top half.
            if( initialPanLocation <= halfPoint) {
                cardView.transform = cardView.transform.rotated(by: CGFloat(rotation))
                //Started panning in bottom half.
            } else {
                cardView.transform = cardView.transform.rotated(by: CGFloat(-rotation))
            }
            
        } else if sender.state == .ended {
            print("Gesture ended")
            
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
                UIView.animate(withDuration: 0.1, animations: { 
                    self.cardView.alpha = 1
                    //If next type is activity and there are activities left.
                    if(self.nextType == 1 && self.activityIndex != self.activityArray?.count) {
                        let nextPlace = self.formatPlaceForCard(dict: self.activityArray![self.activityIndex] as? NSDictionary)
                        self.activityIndex += 1
                        self.nextType = 0
                        self.formatCardUI(place: nextPlace)
                    }
                    //If next type is activity and no activites left.
                    if(self.nextType == 1 && self.activityIndex != self.activityArray?.count) {
                        //TODO pass in nextPageIndex to load more.
                        return
                    }
                    //If next type is rest and there are activities left.
                    if(self.nextType == 0 && self.restIndex != self.activityArray?.count) {
                        let nextPlace = self.formatPlaceForCard(dict: self.restArray![self.restIndex] as? NSDictionary)
                        self.restIndex += 1
                        self.nextType = 1
                        self.formatCardUI(place: nextPlace)
                    }
                    //If next type is rest and no activites left.
                    if(self.nextType == 0 && self.restIndex != self.activityArray?.count) {
                        //TODO pass in nextPageIndex to load more.
                        return
                    }
                })
        })
    }
    
    /*
     * Method for fetching restaurants from API.
     */
    func fetchRestauraunts(preferences: Preferences, success: @escaping (Bool) -> (), failure: @escaping (Error?) -> ()) {
        //Fetch Restaurants.
        let restParams = formatParams(pageToken: nil, type: "restaurant")
        print(restParams)
        Alamofire.request(restParams).validate().responseJSON { response in
            switch response.result {
            case .success:
                print(response.result.value)
                print("When getting restuarants: Validation Successful")

                self.restJSON = response.result.value as! NSDictionary?
                
                self.nextPageTokenRest = self.restJSON?["next_page_token"] as! String?
                if((self.restJSON?["results"]) == nil) {

                    success(false)
                } else {
                    self.restArray = self.restJSON?["results"] as? NSArray
                    print("See there's something here \(self.restArray)")
                    success(true)
                }
            case .failure(let error):
                failure(error)
            }
        }

    }
    
    /*
     * Method calls for fetching data from Google Places API!!
     */
    
    func fetchActivities(preferences: Preferences, success: @escaping (Bool) -> (), failure: @escaping (Error?) -> ()) {
        
        //Fetch Activities.
        let activityParams = formatParams(pageToken: nil, type: "point_of_interest")
        print(activityParams)
        Alamofire.request(activityParams).validate().responseJSON { response in
            switch response.result {
            case .success:
                print(response.result.value)
                print("When getting activities: Validation Successful")

                self.activityJSON = response.result.value as! NSDictionary?
                
                //If there are more places to be pulled.
                if (self.activityJSON?["next_page_token"] != nil) {
                    self.nextPageTokenAct = self.activityJSON?["next_page_token"] as! String?
                }
                if((self.activityJSON?["results"]) == nil) {
                    success(false)
                } else {
                    self.activityArray = self.activityJSON?["results"] as? NSArray
                    success(true)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    /* Formats parameters for API call to google places.*/
    func formatParams(pageToken: String?, type: String) -> String {
        
        var params: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        
        //Get coordinates/radius
        let location = preferences.location?.coordinate
        params.append("location=\(location!.latitude)")
        params.append(",\(location!.longitude)")
        
        //Note radius is in meters not miles. Multiply by 1000
        let radius = Int(self.preferences.radius!)! * 1000
        
        params.append("&radius=\(radius)")
        
        let maxPrice = "\(preferences.maxPrice)"
        params.append("&maxprice=4")
       
        //Either restauraunt or point of interest
        params.append("&type=\(type)")
        
        params.append("&key=\(apiKey)")

        
        //params.append("&keyword=mexican")  //Will edit with filters for users?
        return params

    }
    
    func formatPlaceForCard(dict: NSDictionary?) -> SelectionsCardFormatted {
        
        if(dict == nil) {
            print("ERROR in format place for card")
            return SelectionsCardFormatted()
        }
        
        let place: SelectionsCardFormatted = SelectionsCardFormatted()
        
        let photos = dict?["photos"] as? NSArray
        let photosDict = photos?[0] as! NSDictionary
        let reference = photosDict["photo_reference"]
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=\(reference!)&key=\(apiKey)")
        print("\(url)   blahhhh ")
        
        
        //ANOTHER API call to get the photo from the json result.
        
        Alamofire.request(url!).responseImage { (
            response) in
            if let err = response.error {
                print("There's an error: \(err.localizedDescription)")
            }
            print("something")
            if let image = response.result.value {
                self.cardImageView.image = image
                print("alamofire:  \(image)")
            }
        }
        
        place.address = dict?["vicinity"] as! String
        
        place.name = dict?["name"] as! String
            
        place.id = dict?["id"] as! String
        
        place.types = dict?["types"] as! [String]
        
        place.rating =  "\((dict!["rating"])!)" + "/5"
        
        return place
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata) { (callback: UIImage?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.cardImageView.image = callback
            }
        }
    }
}
