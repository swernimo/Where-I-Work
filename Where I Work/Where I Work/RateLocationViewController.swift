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

class RateLocationViewController : BaseViewController, UIGestureRecognizerDelegate{
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
        website.isUserInteractionEnabled = true
    }
    
    func setFillModeForRatingControls(_ ratingControls: [CosmosView]){
        for index in 0..<ratingControls.count{
            let control = ratingControls[index]
            control.settings.fillMode = .half
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController else{
            return
        }
        
        mapViewController.loadDataFromYelp = false
    }
    
    func loadRating(_ forLocation: Location) -> Rating?{
        let ratingHelper = RatingHelper()
       return ratingHelper.getRatingForLocation(forLocation)
    }
    
    func displayRatingIfExisting(_ rating: Rating?){
        guard let r = rating , rating != nil else{
            //TODO: set the rating controls
            return
        }
        
        freeWifiSwitch.isOn = r.freeWifi
        workThereAgainSwitch.isOn = r.workThereAgain
    }
    
    func displayLocation(){
        guard let loc = location , location != nil else{
            hideControlsIfLocationIsNil()
            return
        }
        businessName.text = loc.businessName
        address.text = loc.address?.getAddressDisplayString(true)
        category.text = loc.category
        phoneNumberTextField.text = loc.phone
        
        guard let _ = loc.website , loc.website != nil else{
            websiteTapGesture.isEnabled = false
            website.isHidden = true
            return
        }
        
        website.text = "Website"
        websiteTapGesture.isEnabled = true
        website.isHidden = false
    }
    
    func hideControlsIfLocationIsNil(){
        setRatingControlsToDefaultState()
    }
    
    func setRatingControlsToDefaultState(){
        freeWifiSwitch.isOn = false
        workThereAgainSwitch.isOn = false
        //TODO: set the rating controls
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(status){
        case .notDetermined, .restricted, .denied:
            performSegue(withIdentifier: "locationDisabledSegue", sender: nil)
            break
        default:
            break
        }
        
    }
    
    func websiteLabel_Clicked(_ sender: UITapGestureRecognizer) {
        let url = URL(string: location!.website!)!
        let canOpen = UIApplication.shared.canOpenURL(url)
        if(canOpen){
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func favoriteButton_Clicked(_ sender: UIBarButtonItem) {
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
    
    @IBAction func saveButton_Clicked(_ sender: UIBarButtonItem) {
      //  let context = CoreDataStackManager.sharedInstance().managedObjectContext
        let id = UUID().uuidString
        let date = Date()
        let _ = Rating(id: id, noise: noiseRating.rating, freeWifi: freeWifiSwitch.isOn, wifiStrength: wifiRating.rating, seatingAvailabilityRating: seatingRating.rating, wouldWorkThereAgain: workThereAgainSwitch.isOn, notes: "", location: location!, created: date)
        
        //CoreDataStackManager.sharedInstance().saveContext()
        navigationController?.popToRootViewController(animated: true)
    }
}
