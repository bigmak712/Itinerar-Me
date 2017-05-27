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
    
    var activityArray: Array<NSDictionary> = Array()
    var restArray: Array<NSDictionary>? = Array()
    var activityJSON: NSDictionary?
    var restJSON: NSDictionary?
    var nextPageTokenRest: String?
    var nextPageTokenAct: String?
    
    var swipedRightArr: Array<SelectionsCardFormatted> = Array()
    var currPlace: SelectionsCardFormatted?
    var restIndex: Int = 0
    var activityIndex: Int = 0
    var maxTranslation: Int! = 0
    
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
                //So first show a restaurant.
                let place: SelectionsCardFormatted = self.formatPlaceForCard(dict: self.restArray![self.restIndex] )
                self.currPlace = place
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
                print(self.activityArray.count)
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
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        
        //Initialize indeces for places
        restIndex = 0
        activityIndex = 0
        
        //GESTURE RECOGNIZERS
        //For card view
        let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        cardView.addGestureRecognizer(panGestureRec)

        //For Tinder animation.
        cardInitialCenter = self.view.center
        print(cardInitialCenter)
        print(cardView.center)
        previousXLocation = cardInitialCenter.x
        
    }
    
    func formatCardUI(place: SelectionsCardFormatted?) {
        if (place == nil) {
            print("passed in a nil place for formatting card :(")
            return
        }
        
        nameLabel.text = place!.name
        addressLabel.text = place!.address
        
        categoriesLabel.text = "Categories: \(place!.types[0])"
        var i = 1
        while(i < place!.types.count) {
            categoriesLabel.text = categoriesLabel.text! + ", " + place!.types[i]
            i += 1
        }
        
        ratingLabel.text = place!.rating
    }
    
    @IBAction func onDone(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "checkVC") as! CheckViewController
        vc.selections = swipedRightArr
        vc.preferences = preferences
        self.show(vc, sender: nil)
    }
    
    @IBAction
    func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let translation = sender.translation(in: view)
        
        let halfPoint = cardView.center.y
        
        if sender.state == .began {
            
            //Give an initial rotation
            cardView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            initialPanLocation = location.y
            
            //During user panning:
        } else if sender.state == .changed {
            
            print(translation)
            let currTranslation = translation.x
            maxTranslation = Int(currTranslation)
            
            cardView.center = CGPoint(x: cardInitialCenter.x + translation.x, y: cardInitialCenter.y + translation.y)
            
            //Tried different options, like a percentage of the translation of x but this random number worked better so 0.02 it is.
            let rotation = (translation.x > 0) ? 0.018 : -0.018
            
            //Started panning in top half.
            if( initialPanLocation <= halfPoint) {
                cardView.transform = cardView.transform.rotated(by: CGFloat(rotation))
                //Started panning in bottom half.
            } else {
                cardView.transform = cardView.transform.rotated(by: CGFloat(rotation * -1))
            }
            
        } else if sender.state == .ended {
            
            //Load new card if the last position of the changed state prompted either left or right swipe off page.
            if(abs(maxTranslation!) > 100) {
                animateAndLoadNew(currTranslation: Int(maxTranslation!))
            } else  {
                self.cardView.center = cardInitialCenter
                self.cardView.transform = CGAffineTransform.identity
                self.previousXLocation = self.cardInitialCenter.x
            }
        }
    }
    
    
    /* When user swipes far enough to left or right animate a new card onto the screen.*/
    func animateAndLoadNew(currTranslation: Int) {
        
        let temp = currPlace
        
        //Load new card:
        //If next type is activity and there are activities left.
        if(self.nextType == 1 && self.activityIndex != self.activityArray.count) {
            self.currPlace = self.formatPlaceForCard(dict: self.activityArray[self.activityIndex] )
            self.activityIndex += 1
            self.nextType = 0
            
        //If next type is activity and no activites left.
        } else if(self.nextType == 1 && self.activityIndex == self.activityArray.count) {
            
            fetchActivities(preferences: preferences, success: { (success: Bool) in
                if(success ) {
                    if(self.activityArray.count == 0) {
                        let outOfActivitiesAlertCont = UIAlertController(title: "Done With Activities", message: "We have no more activity results for you! If you would like more try increasing your radius in your preference.", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        outOfActivitiesAlertCont.addAction(action)
                        
                        self.present(outOfActivitiesAlertCont, animated: true, completion: nil)
                    } else {
                        self.activityIndex = 0
                        self.currPlace = self.formatPlaceForCard(dict: self.activityArray[self.activityIndex] )
                        self.activityIndex += 1
                        self.nextType = 0
                    }
                }
                }, failure: { (error: Error?) in
                    print(error?.localizedDescription)
            })
           
        }
        //If next type is rest and there are activities left.
        else if(self.nextType == 0 && self.restIndex != self.restArray?.count) {
            self.currPlace = self.formatPlaceForCard(dict: self.restArray![self.restIndex] )
            self.restIndex += 1
            self.nextType = 1
        }
        //If next type is rest and no activites left.
        else  {
            restArray?.removeAll()
            
            fetchRestauraunts(preferences: preferences, success: { (success: Bool) in
                if(success ) {
                    if(self.restArray?.count == 0) {
                        let outOfRestaurantsAlertCont = UIAlertController(title: "Done With Restaurants", message: "We have no more restaurant results for you! If you would like more try increasing your radius in your preference.", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        outOfRestaurantsAlertCont.addAction(action)

                        self.present(outOfRestaurantsAlertCont, animated: true, completion: nil)
                    } else {
                        self.nextType = 0
                        self.restIndex = 0
                        self.currPlace = self.formatPlaceForCard(dict: self.restArray?[self.restIndex])
                        self.restIndex += 1
                    }
                }
                }, failure: { (error: Error?) in
                    print(error?.localizedDescription)
            })
            
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.cardView.alpha = 0
            
            if(currTranslation > 0) {
                self.cardView.center = CGPoint(x: self.cardInitialCenter.x + self.view.frame.width, y: self.cardInitialCenter.y)
            } else {
                self.cardView.center = CGPoint(x: self.cardInitialCenter.x - self.view.frame.width, y: self.cardInitialCenter.y)
            }
            }, completion: { (bool: Bool) in
                self.cardView.alpha = 1

                //Either add to itinerary array, or don't
                //If Swipe right :)
                if(currTranslation > 0) {
                    self.swipedRightArr.append(temp!)
                    //If user Swiped left :(
                }
                
                //Animate cardView with spring animations back to initial location with new data loaded.
                UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.cardView.center = self.cardInitialCenter
                    self.cardView.transform = CGAffineTransform.identity
                    self.previousXLocation = self.cardInitialCenter.x
                    
                    //self.cardView.center = CGPoint(x: self.cardInitialCenter.x, y: self.cardInitialCenter.y)
                    }, completion: { (bool: Bool) in
                        print("Entered Completion for animation.")
                })
        })
    }
    
    /*
     * Method for fetching restaurants from API.
     */
    func fetchRestauraunts(preferences: Preferences, success: @escaping (Bool) -> (), failure: @escaping (Error?) -> ()) {
        //Fetch Restaurants.
        let restParams = formatParams(pageToken: self.nextPageTokenRest, type: "query=restaurants")
        print(restParams)
        Alamofire.request(restParams).validate().responseJSON { response in
            switch response.result {
            case .success:
                print(response.result.value)
                print("When getting restuarants: Validation Successful")

                self.restJSON = response.result.value as! NSDictionary?
                if (self.restJSON?["next_page_token"] != nil) {
                    self.nextPageTokenRest = self.restJSON?["next_page_token"] as! String?
                }
                if((self.restJSON?["results"]) == nil) {

                    success(false)
                } else {
                    self.restArray = self.restJSON?["results"] as? Array
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
        
       // let types: Array = [ "zoo", "park","amusement_park", "movie_theater", "university", "aquarium", "art_gallery", "museum", "night_club", "casino", "cafe", "bowling_alley",  "spa", "jewelry_store", "library"  ]
        
        var succ: Bool = false
       // for s in types {
            //Fetch Activities.
            let placeName = preferences.location?.name
            let placeNameParam = placeName?.replacingOccurrences(of: " ", with: "+")
        
            let activityParams = formatParams(pageToken: nil, type: "things+to+do+in+\(placeNameParam)" )
            print(activityParams)
        
            Alamofire.request(activityParams).validate().responseJSON { response in
                switch response.result {
                case .success:
                    self.activityJSON = response.result.value as! NSDictionary?
                    
                    //If there are more places to be pulled.
                    if (self.activityJSON?["next_page_token"] != nil) {
                        self.nextPageTokenAct = self.activityJSON?["next_page_token"] as! String?
                    }
                    if((self.activityJSON?["results"]) == nil) {
                    } else {
                        let temp = self.activityJSON?["results"] as? Array<NSDictionary>
                        if(temp?.count != 0) {
                            if let temp = temp {
                                if(self.activityArray.count == 0) {
                                    self.activityArray = temp
                                } else {
                                    self.activityArray.append(contentsOf: temp)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    failure(error)
                    succ = false
                }
            }
        //}
        success(succ)
    }
    
    /* Formats parameters for API call to google places.*/
    func formatParams(pageToken: String?, type: String) -> String {
        
        var params: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        
        //If querying for more results from page.
        if let pageToken = pageToken {
            params.append("pagetoken=\(pageToken)")
            params.append("&key=\(apiKey)")
            return params
        }
        
        //Get coordinates/radius
        let location = preferences.location?.coordinate
        params.append("location=\(location!.latitude)")
        params.append(",\(location!.longitude)")
        
        //Note radius is in meters not miles. Multiply by 1000
        let radius = Int(self.preferences.radius!)! * 1000
        print("radius: \(radius)")
        
        params.append("&radius=\(radius)")
        
       // let maxPrice = "\(preferences.maxPrice)"
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
        if let photos = photos {
            let photosDict = photos[0] as! NSDictionary
            let reference = photosDict["photo_reference"]
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=550&photoreference=\(reference!)&key=\(apiKey)")
            //ANOTHER API call to get the photo from the json result.
            Alamofire.request(url!).responseImage { (
                response) in
                if let err = response.error {
                    print("There's an error: \(err.localizedDescription)")
                }
                print("something")
                if let image = response.result.value {
                    self.cardImageView.image = image
                    place.image = image
                    print("alamofire:  \(image)")
                }
            }
        }
        place.address = dict?["vicinity"] as! String
        
        place.name = dict?["name"] as! String
            
        place.id = dict?["id"] as! String
        
        place.types = dict?["types"] as! [String]
        
        if dict!["rating"] != nil {
            place.rating = "\((dict!["rating"])!)" + "/5"
        } else {
            place.rating = ""
        }
        
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
