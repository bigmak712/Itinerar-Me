//
//  LocationViewController.swift
//  Itinerar-Me
//
//  Created by Timothy Mak on 4/17/17.
//  Copyright © 2017 ItinerarMe. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationViewController: UIViewController  {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var radiusTextField: UITextField!
    
    var pickedLocation: GMSPlace?
    var preferences = Preferences()
    var locationPicked = false

    let dark_green = UIColor(red: 12/255, green: 127/255, blue: 99/255, alpha: 1.0)
    
    //Instance of autocomplete view controller for the class.
    let autoCompleteCtllr = GMSAutocompleteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //textField.frame.height = 45
        textField.textColor = UIColor.lightGray
        radiusTextField.textColor = UIColor.lightGray

        autoCompleteCtllr.delegate = self
        
        nextButton.layer.borderWidth = CGFloat(1.0)
        nextButton.layer.cornerRadius = CGFloat(30.0)
        nextButton.layer.borderColor = dark_green.cgColor
    }
   
    override func viewDidLayoutSubviews() {
        textField.greenUnderlineTextField()
        radiusTextField.greenUnderlineTextField()
        
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func userTouchedTxtField(_ sender: AnyObject) {
        
        self.present(autoCompleteCtllr, animated: true) {
            self.adjustUI()
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata) { (callback: UIImage?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.backgroundView.image = callback
            }
        }
    }
    
    func adjustUI() {
        if(locationPicked) {
            self.textField.textColor = UIColor.darkGray
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: (pickedLocation?.placeID)!, callback: { (photo: GMSPlacePhotoMetadataList?, error: Error?) in
                if let error = error {
                    print("Error loading image for place: \(error.localizedDescription)")
                } else {
                    self.loadImageForMetadata(photoMetadata: (photo?.results.first)!)
                }
            })

           
        } else {
            self.textField.textColor = UIColor.lightGray
        }
        if(radiusTextField.text?.isEmpty)! {
            self.textField.textColor = UIColor.lightGray
        } else {
            self.textField.textColor = UIColor.darkGray
        }

    }
    
    @IBAction func onNext(_ sender: Any) {
        
        // Alert Messages
        if (textField.text?.isEmpty)! {
            showAlert(title: "Location Not Found", message: "Enter a Location")
        }
        else if (radiusTextField.text?.isEmpty)! {
            showAlert(title: "Radius Not Found", message: "Enter a Radius")
        }
        else if Int(radiusTextField.text!)! <= 0 {
            showAlert(title: "Invalid Radius", message: "Enter a Valid Radius")
        }

        guard !textField.text!.isEmpty else {
            print("NO TEXTFIELD")
            return
        }
        guard !radiusTextField.text!.isEmpty else {
            print("NO TEXTFIELD")
            return
        }
        
    }
    
    @IBAction func radiusEditingDidEnd(_ sender: AnyObject) {
        if(radiusTextField.text?.isEmpty)! {
            print("No radius entered")
            return
        }
        preferences.radius = radiusTextField.text
    }
    
    func showAlert(title: String, message: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimeVC" {
            let timeVC = segue.destination as! TimeViewController
            timeVC.preferences = self.preferences
        }
    }
}

extension LocationViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.pickedLocation = place
        textField.text = place.name
        preferences.location = place
        
        dismiss(animated: true, completion: nil)
    }
    
    //If error occured in autocomplete
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
