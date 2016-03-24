//
//  RateLocationViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/7/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RateLocationViewController : UIViewController, CLLocationManagerDelegate{
    var location: Location? = nil
    
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var noiseLevelStepper: UIStepper!
    @IBOutlet weak var noiseLevelLabel: UILabel!
    @IBOutlet weak var freeWifiSwitch: UISwitch!
    @IBOutlet weak var wifiStrengthStepper: UIStepper!
    @IBOutlet weak var wifiStrengthLabel: UILabel!
    @IBOutlet weak var seatingAvailabliityStepper: UIStepper!
    @IBOutlet weak var seatingAvailabiltyLabel: UILabel!
    @IBOutlet weak var workThereAgainSwitch: UISwitch!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    override func viewDidLoad() {
        displayLocation()
    }
    
    func displayLocation(){
        if(location != nil){
            businessName.text = location?.businessName
            address.text = location?.address?.getAddressDisplayString()
            category.text = location?.category
            website.text = location?.website
        }
        else{
            hideControlsIfLocationIsNil()
        }
    }
    
    func hideControlsIfLocationIsNil(){
        setRatingControlsToDefaultState()
    }
    
    func setRatingControlsToDefaultState(){
        noiseLevelLabel.text = ""
        noiseLevelStepper.stepValue = 1
        freeWifiSwitch.on = false
        wifiStrengthLabel.text = ""
        wifiStrengthStepper.stepValue = 1
        seatingAvailabiltyLabel.text = ""
        seatingAvailabliityStepper.stepValue = 1
        workThereAgainSwitch.on = false
        notesTextView.text = ""
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .NotDetermined, .Restricted, .Denied:
            performSegueWithIdentifier("locationNotAuthorizedSegue", sender: nil)
            break
        default:
            break
        }
        
    }
    
    @IBAction func cancelButton_Clicked(sender: UIBarButtonItem) {
        setRatingControlsToDefaultState()
        performSegueWithIdentifier("mapViewSegue", sender: nil)
    }

    @IBAction func saveButton_Clicked(sender: UIBarButtonItem) {
        //TODO: create new rating object OR get the existing rating for this business
        //TODO: save to CoreData
        performSegueWithIdentifier("mapViewSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        location = nil
        hideControlsIfLocationIsNil()
    }
}