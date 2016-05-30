//
//  RateLocationViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/7/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//  
// star rating control creator: https://github.com/marketplacer/Cosmos
//

import Foundation
import UIKit
import MapKit
import Cosmos

class RateLocationViewController : UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    var location: Location?
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var freeWifiSwitch: UISwitch!
    @IBOutlet weak var workThereAgainSwitch: UISwitch!
    @IBOutlet weak var seatingRating: CosmosView!
    @IBOutlet weak var noiseRating: CosmosView!
    @IBOutlet weak var wifiRating: CosmosView!
    @IBOutlet weak var valueRating: CosmosView!
    @IBOutlet weak var parkingRating: CosmosView!
    @IBOutlet weak var powerRating: CosmosView!
    @IBOutlet weak var loyaltySwitch: UISwitch!
    @IBOutlet weak var wifiTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phoneNumberTextField: UILabel!
    @IBOutlet var websiteTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        displayLocation()
        if(location != nil){
            let rating = loadRating(location!)
            displayRatingIfExisting(rating)
        }
        setFillModeForRatingControls([seatingRating, noiseRating, wifiRating])
        seatingRating.didFinishTouchingCosmos = {
            rating in
            print("rating: \(rating)")
            //TODO: if the rating changed enable the save button
        }
        websiteTapGesture.delegate = self
        websiteTapGesture.addTarget(self, action:#selector(RateLocationViewController.websiteLabel_Clicked))
        website.addGestureRecognizer(websiteTapGesture)
        website.userInteractionEnabled = true
    }
    
    func setFillModeForRatingControls(ratingControls: [CosmosView]){
        for index in 0..<ratingControls.count{
            let control = ratingControls[index]
            control.settings.fillMode = .Half
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mapViewController = segue.destinationViewController as? MapViewController else{
            return
        }
        
        mapViewController.loadDataFromYelp = false
    }
    
    func loadRating(forLocation: Location) -> Rating?{
        let ratingHelper = RatingHelper()
       return ratingHelper.getRatingForLocation(forLocation)
    }
    
    func displayRatingIfExisting(rating: Rating?){
        guard let r = rating where rating != nil else{
            //TODO: set the rating controls
            return
        }
        
        freeWifiSwitch.on = (r.freeWifi == 1)
        workThereAgainSwitch.on = (r.workThereAgain == 1)
    }
    
    func displayLocation(){
        guard let loc = location where location != nil else{
            hideControlsIfLocationIsNil()
            return
        }
        businessName.text = loc.businessName
        address.text = loc.address?.getAddressDisplayString(true)
        category.text = loc.category
        phoneNumberTextField.text = loc.phone
        
        guard let _ = loc.website where loc.website != nil else{
            websiteTapGesture.enabled = false
            website.hidden = true
            return
        }
        
        website.text = "Website"
        websiteTapGesture.enabled = true
        website.hidden = false
    }
    
    func hideControlsIfLocationIsNil(){
        setRatingControlsToDefaultState()
    }
    
    func setRatingControlsToDefaultState(){
        freeWifiSwitch.on = false
        workThereAgainSwitch.on = false
        //TODO: set the rating controls
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .NotDetermined, .Restricted, .Denied:
            performSegueWithIdentifier("locationDisabledSegue", sender: nil)
            break
        default:
            break
        }
        
    }
    
    func websiteLabel_Clicked(sender: UITapGestureRecognizer) {
        let url = NSURL(string: location!.website!)!
        let canOpen = UIApplication.sharedApplication().canOpenURL(url)
        if(canOpen){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func favoriteButton_Clicked(sender: UIBarButtonItem) {
        let img = sender.image
        let emptyHeart = UIImage(named: "Heart")
        let filledHeart = UIImage(named: "Heart-Filled")
        if(img == emptyHeart){
            sender.image = filledHeart
            //TODO: if the location is NOT a favorite then add it to the favorites list
        }else{
            sender.image = emptyHeart
            //TODO: if the location is a favorite then remove it from the favorites list
        }
    }
    
    @IBAction func saveButton_Clicked(sender: UIBarButtonItem) {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        let id = NSUUID().UUIDString
        let date = NSDate()
        let _ = Rating(id: id, noise: noiseRating.rating, freeWifi: freeWifiSwitch.on, wifiStrength: wifiRating.rating, seatingAvailabilityRating: seatingRating.rating, wouldWorkThereAgain: workThereAgainSwitch.on, notes: "", location: location!, created: date, context: context)
        
        //CoreDataStackManager.sharedInstance().saveContext()
        navigationController?.popToRootViewControllerAnimated(true)
    }
}